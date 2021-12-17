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
 registerHeaderFooterView use className as identifier
 when load can use loadHeaderFooterView:
 */
- (void)registerHeaderFooterView:(Class)aClass  isNib:(BOOL)isNib;

@end

@interface UICollectionViewCell (Custom)
/**
 auto load tableViewCell, use this need with "registerCell:isNib:" method
 */
+ (instancetype)loadFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end

@interface UICollectionReusableView (Custom)

/**
 load headerFooterView use className as identifier
 */
+ (instancetype)loadHeaderFooterView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
