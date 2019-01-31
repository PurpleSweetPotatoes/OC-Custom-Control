//
//  UICollectionView+Custom.h
//  tianyaTest
//
//  Created by baiqiang on 2019/1/4.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (Custom)

/**
 registerCell use className as identifier
 when load can use loadCell:indexPath:
 */
- (void)registerCell:(Class)cellClass isNib:(BOOL)isNib;

/**
 load cell use className as identifier
 */
- (UICollectionViewCell *)loadCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath;

/**
 registerHeaderFooterView use className as identifier
 when load can use loadHeaderFooterView:
 */
- (void)registerHeaderFooterView:(Class)aClass  isNib:(BOOL)isNib;

/**
 load headerFooterView use className as identifier
 */
- (UICollectionReusableView *)loadHeaderFooterView:(Class)aClass indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
