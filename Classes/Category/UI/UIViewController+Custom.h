//
//  UIViewController+Custom.h
//  tianyaTest
//
//  Created by baiqiang on 2019/4/24.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, StatusColorType) {
    StatusColorType_Normal,
    StatusColorType_White,
};

@interface UIViewController (Custom)

@property (nonatomic, assign          ) StatusColorType statuType;///< 状态栏颜色
@property (nonatomic, readonly, assign) CGFloat         navbarBottom;///< 导航栏底部高度
@property (nonatomic, readonly, assign) CGFloat         tabbarHeight;///< tabbar栏高度

/// 当前最上层控制器
+ (UIViewController *)currentDisPalyVc;

/// 配置导航栏左item，保证可执行手势滑动pop
/// @param item barItem
- (void)setNavBarLeftItem:(UIBarButtonItem *)item;

#pragma mark - 配置导航栏颜色

/// 开启自定义导航栏
+ (void)startConfigNavBar;

/// 必须先设置barView颜色
- (void)bq_configsetShadowLine:(BOOL)hide;

/// 在所有界面添加完成后使用保证视图在最上层
/// @param color 导航栏视图颜色
- (void)bq_setNavBarBackgroundColor:(UIColor *)color;

/// 配置导航栏视图透明度
/// @param alpha 透明度
- (void)bq_setNavBarGgViewAlpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
