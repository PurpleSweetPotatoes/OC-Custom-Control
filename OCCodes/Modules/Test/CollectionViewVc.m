// *******************************************
//  File Name:      CollectionViewVc.m       
//  Author:         MrBai
//  Created Date:   2022/1/4 11:10 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "CollectionViewVc.h"

#import "BQWaterFallLayout.h"
#import "CollectionImgCell.h"
#import "ImgModel.h"
#import "UICollectionView+Custom.h"
#import "UILabel+Custom.h"
#import "BQAlertSheetView.h"
#import "BQLinearLayout.h"
@interface CollectionViewVc ()
<
UICollectionViewDataSource
,UICollectionViewDelegate
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
    NSArray * arr = @[@"常规布局",@"瀑布流"];
    [BQAlertSheetView showSheetViewWithTitles:arr callBlock:^(NSInteger index, NSString *title) {
        if (index == 0) {
            self.collectionV.collectionViewLayout = self.flowLayout;
        } else if (index == 1) {
            self.collectionV.collectionViewLayout = self.waterFallLayout;
        }
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
        UICollectionView * collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.tipLab.bottom, self.view.width, 100) collectionViewLayout:self.linearLayout];
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
        linearLayout.minimumInteritemSpacing = 10;
        CGFloat width = (self.view.width - linearLayout.minimumInteritemSpacing * 2) * 0.5;
        linearLayout.itemSize = CGSizeMake(width, 100);
        linearLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _linearLayout = linearLayout;
    }
    return _linearLayout;
}

@end
