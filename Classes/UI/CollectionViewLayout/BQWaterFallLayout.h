//
//  BQWaterLayout.h
//  瀑布流测试
//
//  Created by baiqiang on 15/9/22.
//  Copyright (c) 2015年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef CGFloat(^HeightBlock)(NSIndexPath *indexPath , CGFloat width);

/// 必须实现 configCellHeightWithBlock: 方法
@interface BQWaterFallLayout : UICollectionViewLayout

/** 列数，默认3列 */
@property (nonatomic, assign) NSInteger lineNumber;

/** 行间距，默认行间距 10.0f */
@property (nonatomic, assign) CGFloat rowSpacing;

/** 列间距，默认列间距 10.0f*/
@property (nonatomic, assign) CGFloat lineSpacing;

/** 内边距， 默认内边距 top:0 left:10 bottom:10 right:10*/
@property (nonatomic, assign) UIEdgeInsets sectionInset;

/**
 *  计算各个item高度方法 必须实现
 *  @param block 设计计算item高度的block
 */
- (void)configCellHeightWithBlock:(CGFloat(^)(NSIndexPath *indexPath , CGFloat width))block;

@end
