//
//  UITableView+Custom.h
//  Test-demo
//
//  Created by baiqiang on 2018/1/27.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableViewNoDataProtocol <NSObject>

@required
- (BOOL)noDataCanShow:(UITableView *)tableView;
- (UIView *)configNoDataShowView:(UITableView *)tableView;

@end

@interface UITableView (Custom)

@property (nonatomic, weak) id<UITableViewNoDataProtocol>  noDataDelegate;

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
- (CGFloat)fetchCellHeight:(Class)cellClass configBlock:(void(^)(id cell))configBlock;

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
