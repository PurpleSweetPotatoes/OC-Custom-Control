//
//  SwipeSubTableVc.h
//  tianyaTest
//
//  Created by baiqiang on 2019/3/12.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BQSwipTableViewDelegate <NSObject>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) NSString * itemTitle;                   ///< 子视图标示符,也可用其他类型代替
@property (nonatomic, assign) CGFloat  headerHeight;                ///< 头部视图高度(广告位+按钮位高度)
@property (nonatomic, assign) BOOL  needScrollBlock;                ///< 滑动时是否需要回调

/* 更新数据源方法 */
- (void)reloadWithDatas:(NSArray *)datas;

/* 当tableView上下滑动时需回调此方法中的block */
- (void)scrollViewDidScrollBlock:(void(^)(CGFloat offsetY))block;

@end



/// 左右滑动视图控制器
@interface BQSwipeSubTableVc : UIViewController

@property (nonatomic, strong) UIView * headerView;              ///< 头部视图，所有子视图公用
@property (nonatomic, strong) UIView * barView;                 ///< 导航按钮栏
@property (nonatomic, strong) NSArray<UIViewController<BQSwipTableViewDelegate> *> * tabArrs;   ///< 子控制器数组
@property (nonatomic, assign) CGFloat  navBottom;               ///< 导航栏底部高度

/// 重载子控制器视图
/// @param tabArrs 子控制器数组
- (void)resetTabArrs:(NSArray<UIViewController<BQSwipTableViewDelegate> *> *)tabArrs;

/// 切换子控制器视图
/// @param index 切换到第几个视图
- (void)switchToTabVc:(NSInteger)index;

/// 子控制器将要切换
/// @param changeBlock 将切换到第几个视图
- (void)tabVcWillSwitchToIndex:(void(^)(NSInteger index))changeBlock;

@end

NS_ASSUME_NONNULL_END
