// *******************************************
//  File Name:      CollectionViewVc.m       
//  Author:         MrBai
//  Created Date:   2022/1/4 11:10 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "CollectionViewVc.h"

#import "BQAlertSheetView.h"
#import "BQLinearLayout.h"
#import "BQPhotoBrowserView.h"
#import "BQWaterFallLayout.h"
#import "CollectionImgCell.h"
#import "ImgModel.h"
#import "UICollectionView+Custom.h"
#import "UILabel+Custom.h"

@interface CollectionViewVc ()
<
UICollectionViewDataSource
,UICollectionViewDelegate
,BQPhotoBrowserViewDelegate
,BQLinearLayoutDelegate
>
@property (nonatomic, strong) UILabel * tipLab;
@property (nonatomic, strong) UICollectionView * collectionV;
@property (nonatomic, strong) NSArray<ImgModel *> * datas;
@property (nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic, strong) BQWaterFallLayout * waterFallLayout;
@property (nonatomic, strong) BQLinearLayout * linearLayout;
@end

@implementation CollectionViewVc


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    [self configUI];
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)changeCollectionLayout {
    NSArray * arr = @[@"常规布局",@"瀑布流",@"线性布局"];
    [BQAlertSheetView showSheetViewWithTitles:arr callBlock:^(NSInteger index, NSString *title) {
        if (index == 0) {
            self.collectionV.collectionViewLayout = self.flowLayout;
        } else if (index == 1) {
            self.collectionV.collectionViewLayout = self.waterFallLayout;
        } else if (index == 2) {
            self.collectionV.collectionViewLayout = self.linearLayout;
        }
        self.collectionV.height = index == 2 ? 150 : (self.view.height - self.tipLab.bottom);
        self.tipLab.text = [NSString stringWithFormat:@"当前布局:%@",arr[index]];
        [self.collectionV reloadData];
        [self.collectionV setContentOffset:CGPointZero animated:YES];
    }];
}
#pragma mark - *** Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datas.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionImgCell * cell = [CollectionImgCell loadFromCollectionView:collectionView indexPath:indexPath];
    [cell configInfo:self.datas[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    BQPhotoBrowserView * view = [BQPhotoBrowserView showWithDelegate:self];
    [view scrollToIndex:indexPath.row];
}

- (NSInteger)numberOfBrowser {
    return self.datas.count;
}

- (void)browserConfigImgV:(BQPhotoView *)photoV index:(NSInteger)index {
    photoV.imgV.image = [UIImage imageNamed:self.datas[index].imgName];
}

- (void)didLoadLayoutAttributes:(NSArray *)attributes layout:(UICollectionViewLayout *)layout {
    if (layout == self.linearLayout) {
        // 计算collectionView最中心点的x值
        CGFloat centerX = layout.collectionView.contentOffset.x + layout.collectionView.frame.size.width * 0.5;
        BQLinearLayout * linear = (BQLinearLayout *)layout;
        // 在原有布局属性的基础上，进行微调
        for (UICollectionViewLayoutAttributes *attrs in attributes) {
            // cell的中心点x 和 collectionView最中心点的x值 的间距
            CGFloat delta = ABS(attrs.center.x - centerX);
            if (delta < (attrs.size.width + linear.minimumLineSpacing)) {
                // 根据间距值 计算 cell的缩放比例
                CGFloat scale = 1.5 - delta / (attrs.size.width + linear.minimumLineSpacing) * 0.5;
                // 设置缩放比例
                attrs.transform = CGAffineTransformMakeScale(scale, scale);
            } else {
                attrs.transform = CGAffineTransformIdentity;
            }
        }
    }
}
#pragma mark - *** Instance method

- (void)configData {
    NSMutableArray * arr = [NSMutableArray array];
    for (NSInteger i = 1; i < 21; i++) {
        NSString * imgName = [NSString stringWithFormat:@"collection_%zd.jpg",i];
        UIImage * img = [UIImage imageNamed:imgName];
        ImgModel * model = [[ImgModel alloc] init];
        model.imgName = imgName;
        model.width = img.size.width;
        model.height = img.size.height;
        [arr addObject:model];
    }
    self.datas = [arr copy];
}
#pragma mark - *** UI method

- (void)configUI {
    [self.view addSubview:self.tipLab];
    [self.view addSubview:self.collectionV];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"模式" style:UIBarButtonItemStylePlain target:self action:@selector(changeCollectionLayout)];
}

#pragma mark - *** Set

#pragma mark - *** Get
    

- (UICollectionView *)collectionV {
    if (_collectionV == nil) {
        UICollectionView * collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.tipLab.bottom, self.view.width, self.view.height - self.tipLab.bottom) collectionViewLayout:self.flowLayout];
        collectionV.backgroundColor = [UIColor clearColor];
        collectionV.dataSource = self;
        collectionV.delegate = self;
        [collectionV registerCell:[CollectionImgCell class] isNib:NO];
        _collectionV = collectionV;
    }
    return _collectionV;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (_flowLayout == nil) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 8, 20);
        CGFloat width = (self.view.width - 20 * 4) / 3;
        flowLayout.itemSize = CGSizeMake(width, width);
        flowLayout.minimumLineSpacing = 20;
        flowLayout.minimumInteritemSpacing = 20;
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}

- (BQWaterFallLayout *)waterFallLayout {
    if (_waterFallLayout == nil) {
        BQWaterFallLayout * waterFallLayout = [[BQWaterFallLayout alloc] init];
        [waterFallLayout configCellHeightWithBlock:^CGFloat(NSIndexPath *indexPath, CGFloat width) {
            ImgModel * model = self.datas[indexPath.item];
            model.height = model.height / model.width * width;
            model.width = width;
            return model.height;
        }];
        _waterFallLayout = waterFallLayout;
    }
    return _waterFallLayout;
}

- (UILabel *)tipLab {
    if (_tipLab == nil) {
        UILabel * tipLab = [UILabel labWithFrame:CGRectMake(0, self.navbarBottom, self.view.width, 40) title:@"当前模式:常规布局" font:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] textColor:[UIColor blackColor]];
        tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab = tipLab;
    }
    return _tipLab;
}

- (BQLinearLayout *)linearLayout {
    if (_linearLayout == nil) {
        BQLinearLayout * linearLayout = [[BQLinearLayout alloc] init];
        linearLayout.delegate = self;
        linearLayout.scorllReset = YES;
        linearLayout.minimumLineSpacing = 60;
        linearLayout.itemSize = CGSizeMake(180, 100);
        linearLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        linearLayout.sectionInset = UIEdgeInsetsMake(0, (self.collectionV.width - linearLayout.itemSize.width) * 0.5, 0, (self.collectionV.width - linearLayout.itemSize.width) * 0.5);
        _linearLayout = linearLayout;
    }
    return _linearLayout;
}

@end
