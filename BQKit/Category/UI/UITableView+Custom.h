//
//  UITableView+Custom.h
//  Test-demo
//
//  Created by baiqiang on 2018/1/27.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Custom)

/**
 registerCell use className as identifier
 when load can use loadCell:indexPath:
 */
- (void)registerCell:(Class)cellClass isNib:(BOOL)isNib;

/**
 load cell use className as identifier
 */
- (UITableViewCell *)loadCell:(Class)cellClass indexPath:(NSIndexPath *)indexPath;

/**
 fetch cell real height after config data
 @param configBlock use set datas
 @return max in NSLayoutConstraint.value and cell.height
 */
- (CGFloat)fetchCellHeightWithIdentifier:(NSString *)identifier configBlock:(void(^)(id cell))configBlock;

/**
 registerHeaderFooterView use className as identifier
 when load can use loadHeaderFooterView:
 */
- (void)registerHeaderFooterView:(Class)aClass  isNib:(BOOL)isNib;

/**
 load headerFooterView use className as identifier
 */
- (UITableViewHeaderFooterView *)loadHeaderFooterView:(Class)aClass;




@end
