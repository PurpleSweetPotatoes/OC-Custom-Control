//
//  BQImagePickerVc.m
//  DrawingBoard
//
//  Created by baiqiang on 2019/3/22.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "BQImagePickerVc.h"

#import "PHAsset+Picker.h"

#import "BQImgPickerCell.h"
#import "BQMsgView.h"

@interface BQImagePickerVc ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
BQImgPickCellDelegate
>
@property (nonatomic, strong) UICollectionView          * collectionView;///<  列表视图
@property (nonatomic, strong) NSMutableArray<PHAsset *> * datasArr;///<  数据源
@property (nonatomic, strong) NSMutableArray            * backArr;///<  选取的数据
@property (nonatomic, assign) NSInteger                 currentNum;///<  已选择数量
@property (nonatomic, copy  ) PickerCompletedBlock      selectedHandle;
@property (nonatomic, copy  ) PickerCompletedBlock      failHandle;
@property (nonatomic, strong) PHImageRequestOptions     * options;
@property (nonatomic, assign) CGSize                    itemSize;
@property (nonatomic, assign) CGSize                    targetSize;
@end

static NSString * const kImagePickerCell = @"BQImgPickerCell";

@implementation BQImagePickerVc

- (void)dealloc {
    NSLog(@"%@ 被释放了",self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datasArr = [NSMutableArray array];
    
    if (self.maxSelecd == 0) {
        self.maxSelecd = 1;
    }
    
    self.backArr = [NSMutableArray arrayWithCapacity:self.maxSelecd];
    
    [self setupUI];
    
    [self checkPhotoAuthor];
    
    self.navigationItem.title = [NSString stringWithFormat:@"请选择"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(clickCompletedAction:)];
    
}

- (void)setupUI {
    
    NSInteger lineNum = 4;
    CGFloat spacing = 2;
    CGFloat itemW = (self.view.bounds.size.width - spacing * (1 + lineNum)) / lineNum;
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.minimumInteritemSpacing = spacing;
    layout.minimumLineSpacing = spacing;
    layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, 0, spacing);
    CGFloat navBottom = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, navBottom, self.view.bounds.size.width, self.view.bounds.size.height - navBottom) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[BQImgPickerCell class] forCellWithReuseIdentifier:kImagePickerCell];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.networkAccessAllowed = YES;
    self.options = options;
    
    self.targetSize = CGSizeMake(self.view.bounds.size.width * [UIScreen mainScreen].scale, self.view.bounds.size.height * [UIScreen mainScreen].scale);
    self.itemSize = CGSizeMake(itemW * [UIScreen mainScreen].scale, itemW * [UIScreen mainScreen].scale);
}

- (void)configSelectCompletedHandle:(PickerCompletedBlock)handle {
    self.selectedHandle = handle;
}

- (void)configAuthFailHanle:(PickerCompletedBlock)failBlock {
    self.failHandle = failBlock;
}

#pragma mark - BQImgPickCellDelegate

- (BOOL)imgPiackCellBtnActionWithAsset:(PHAsset *)assetModel {
    
    if (assetModel.selected) {
        [self.backArr removeObject:assetModel.image];
        self.currentNum -= 1;
    } else if (self.currentNum == self.maxSelecd) {
        //to do any thing
        [BQMsgView showInfo:@"已达到最大选择数"];
        return NO;
    } else {
        self.currentNum += 1;
    }
    if (self.currentNum != 0) {
        self.navigationItem.title = [NSString stringWithFormat:@"已选择%ld项",self.currentNum];
    } else {
        self.navigationItem.title = [NSString stringWithFormat:@"请选择"];
    }
    
    __weak typeof(self) weakSelf = self;
    static dispatch_queue_t load_image_queue;
    if (!load_image_queue) {
        load_image_queue = dispatch_queue_create("BQImagePickerVcLoadImgQueue", 0);
    }
    dispatch_async(load_image_queue, ^{
        [weakSelf loadImgWithAsset:assetModel];
    });
    
    return YES;
}

#pragma mark - Btn Action

- (void)clickCompletedAction:(UIBarButtonItem *)sender {
    
    if (self.selectedHandle && self.backArr.count > 0) {
        self.selectedHandle(self.backArr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CollectionView method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BQImgPickerCell * imgCell = [collectionView dequeueReusableCellWithReuseIdentifier:kImagePickerCell forIndexPath:indexPath];
    imgCell.delegate = self;
    imgCell.assetModel = self.datasArr[indexPath.item];
    
    return imgCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - Photo image method

- (void)checkPhotoAuthor {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"已验证");
            [self getAllPhoto];
        } else {
            NSLog(@"未验证");
            if (self.failHandle) {
                self.failHandle(@"验证失败");
            }
        }
    }];
}

- (void)getAllPhoto {
    
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:self.sourceType options:nil];
    
    NSMutableArray * list = [NSMutableArray array];
    
    
    
    for (PHAssetCollection *albums in smartAlbums) {
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:albums options:nil];
        for (PHAsset * asset in assets) {
            [list addObject:asset];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.datasArr = list;
        [self.collectionView reloadData];
    });
    
    for (PHAsset * asset in list) {
        [self loadImgWithAsset:asset];
    }
}


- (void)loadImgWithAsset:(PHAsset *)asset {
    CGSize size = asset.selected ? self.targetSize : self.itemSize;
    WeakSelf;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        asset.image = result;
        if (asset.selected && result) {
            NSLog(@"添加");
            [weakSelf.backArr addObject:result];
        }
    }];
}

@end

