// *******************************************
//  File Name:      BQLinearLayout.m       
//  Author:         MrBai
//  Created Date:   2022/1/4 2:42 PM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQLinearLayout.h"

@interface BQLinearLayout ()

@end

@implementation BQLinearLayout

- (void)prepareLayout{
    [super prepareLayout];
    NSLog(@"准备布局");
    // 设置内边距
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个数组中存放的都是UICollectionViewLayoutAttributes对象
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）*/
/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 计算collectionView最中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // cell的中心点x 和 collectionView最中心点的x值 的间距
        CGFloat delta = ABS(attrs.center.x - centerX);
        if (delta < self.collectionView.bounds.size.width * 0.5) {
            // 根据间距值 计算 cell的缩放比例
            CGFloat scale = 1 - delta / self.collectionView.frame.size.width;
            // 设置缩放比例
            attrs.transform = CGAffineTransformMakeScale(scale, scale);
        } else {
            attrs.transform = CGAffineTransformIdentity;
        }
        
    }
    
    return array;
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 * proposedContentOffset：原本情况下，collectionView停止滚动时最终的偏移量
 * velocity：滚动速率，通过这个参数可以了解滚动的方向
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 存放最小的间距值
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

@end
