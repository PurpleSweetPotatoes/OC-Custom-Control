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

@property (nonatomic, assign) StatusColorType  statuType;                       ///< 状态栏颜色
@property (nonatomic, readonly, assign) CGFloat  navbarBottom;                  ///< 导航栏底部高度
@property (nonatomic, readonly, assign) CGFloat  tabbarHeight;                  ///< tabbar栏高度

+ (UIViewController *)currentDisPalyVc;

- (void)setNavBarLeftItem:(UIBarButtonItem *)item;

@end

NS_ASSUME_NONNULL_END
