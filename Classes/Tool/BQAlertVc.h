//
//  BQAlertVc.h
//  tianyaTest
//
//  Created by baiqiang on 2019/5/7.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VoidAlertBlock)(void);

typedef NS_ENUM(NSUInteger, AlertBtnType) {
    AlertBtnTypeNormal,
    AlertBtnTypeDestroy,
};

/// 自定义弹窗控制器
@interface BQAlertVc : UIViewController

/// 配置弹窗控制器
/// @param title 标题
/// @param content 文本
+ (instancetype)configAlertVcWithTile:(NSString *)title content:(NSString *)content;

/// 自定义弹窗控制器视图
/// @param customView 自定义视图
- (void)addCustomView:(UIView *)customView;

/// 添加控制器按钮
/// @param title 按钮名称
/// @param type 按钮类型
/// @param handle 回调方法
- (void)addBtnWithTitle:(NSString *)title type:(AlertBtnType)type handle:(_Nullable VoidAlertBlock)handle;

/// 展示弹窗控制器
- (void)showVc;

@end

NS_ASSUME_NONNULL_END
