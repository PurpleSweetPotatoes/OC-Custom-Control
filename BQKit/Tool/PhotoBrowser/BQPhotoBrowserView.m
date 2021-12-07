// *******************************************
//  File Name:      BQPhotoBrowserView.m
//  Author:         MrBai
//  Created Date:   2020/3/4 2:27 PM
//
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQPhotoBrowserView.h"
#import "UIView+Custom.h"
#import "UIImage+Custom.h"
#import "BQMsgView.h"

@interface BQPhotoBrowserView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
BQPhotoViewDelegate
>
@property (nonatomic, strong) UICollectionView * collectV;
@property (nonatomic, strong) UILabel * numLab;
@property (nonatomic, assign) NSInteger  num;
@end



@interface BQPhotoBrowserCollectionCell : UICollectionViewCell
@property (nonatomic, strong) BQPhotoView * photoView;

@end

@implementation BQPhotoBrowserView


#pragma mark - *** Public method
+ (instancetype)showWithDelegate:(id<BQPhotoBrowserViewDelegate>)delegate {
    BQPhotoBrowserView * browserV = [BQPhotoBrowserView configViewWithFrame:[UIScreen mainScreen].bounds delegate:delegate];
    [[UIApplication sharedApplication].keyWindow addSubview:browserV];
    return browserV;
}

+ (instancetype)configViewWithFrame:(CGRect)frame delegate:(id<BQPhotoBrowserViewDelegate>)delegate {
    if (delegate == nil) {
        return nil;
    }
    BQPhotoBrowserView * browserV = [[BQPhotoBrowserView alloc] initWithFrame:frame];
    browserV.delegate = delegate;
    [browserV reLoadData];
    return browserV;
}

- (void)scrollToIndex:(NSInteger)index {
    self.index = index;
    [self.collectV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)reLoadData {
    self.num = [self.delegate numberOfBrowser];
    self.numLab.hidden = self.num == 0;
    [self scrollViewDidScroll:self.collectV];
    [self.collectV reloadData];
}

#pragma mark - *** Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.num = 0;
        self.tapBack = YES;
        [self configUI];
    }
    return self;
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action
- (void)downBtnAction:(UIButton *)sender {
    NSLog(@"图片保存");
    BQPhotoBrowserCollectionCell * cell = (BQPhotoBrowserCollectionCell *)[self.collectV cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0]];
    if (cell.photoView.imgV.image) {
        [cell.photoView.imgV.image saveToPhotosWithReslut:^(NSError *error) {
            [BQMsgView showInfo:@"图片保存成功"];
        }];
    }
}
#pragma mark - *** Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BQPhotoBrowserCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BQPhotoBrowserCollectionCell" forIndexPath:indexPath];
    cell.photoView.delegate = self;
    [self.delegate browserConfigImgV:cell.photoView index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    BQPhotoBrowserCollectionCell * cel = (BQPhotoBrowserCollectionCell *)cell;
    [cel.photoView resetNormal];
    [self.delegate browserConfigImgV:cel.photoView index:indexPath.row];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.index = (NSInteger)((scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width);
}

- (void)photoTapAction {
    if (self.tapBack) {
        [self removeFromSuperview];
    }
}

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = self.bounds.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView * collectV = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectV.dataSource = self;
    collectV.delegate = self;
    collectV.showsHorizontalScrollIndicator = NO;
    collectV.pagingEnabled = YES;
    [collectV registerClass:[BQPhotoBrowserCollectionCell class] forCellWithReuseIdentifier:@"BQPhotoBrowserCollectionCell"];
    [self addSubview:collectV];
    self.collectV = collectV;
    
    self.numLab = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 60) * 0.5, self.bounds.size.height - 80, 80, 30)];
    self.numLab.font = [UIFont systemFontOfSize:14];
    self.numLab.layer.cornerRadius = 15;
    self.numLab.layer.masksToBounds = YES;
    self.numLab.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.numLab.textColor = [UIColor whiteColor];
    self.numLab.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.numLab];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.bounds.size.width - 60, self.numLab.top, 30, 30);
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn setImage:[self downImg] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(downBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = self.numLab.backgroundColor;
    [self addSubview:btn];
    
}


#pragma mark - *** Set

- (void)setIndex:(NSInteger)index {
    
    if (index < 0) {
        _index = 0;
    } else {
        _index = index;
    }
    
    if (!self.numLab.hidden) {
        self.numLab.text = [NSString stringWithFormat:@"%zd / %zd",_index + 1, self.num];
    }
}

#pragma mark - *** Get
    
- (UIImage *)downImg {
    
    UIColor * color = [UIColor whiteColor];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(60, 60), NO, 2);
    CGContextRef ct = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ct, 10, 40);
    CGContextAddLineToPoint(ct, 10, 50);
    CGContextAddLineToPoint(ct, 50, 50);
    CGContextAddLineToPoint(ct, 50, 40);
    
    CGContextMoveToPoint(ct, 20, 30);
    CGContextAddLineToPoint(ct, 30, 40);
    CGContextAddLineToPoint(ct, 40, 30);
    
    CGContextMoveToPoint(ct, 30, 10);
    CGContextAddLineToPoint(ct, 30, 40);
    
    CGContextSetLineJoin(ct, kCGLineJoinRound);
    CGContextSetLineCap(ct, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ct, color.CGColor);
    CGContextSetLineWidth(ct, 2);
    CGContextStrokePath(ct);
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRelease(ct);
    return img;
}

@end

@implementation BQPhotoBrowserCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}


- (void)configUI {
    BQPhotoView * photoView = [[BQPhotoView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:photoView];
    self.photoView = photoView;
}

@end
