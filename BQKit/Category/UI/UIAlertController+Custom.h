//
//  UIAlertController+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Custom)
/**  警告消息展示 */
+ (void)showWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content;

/**  警告消息展示，带点击回调 */
+ (void)showWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content handle:(void(^ _Nullable)())clickedBtn;

/**  警告消息展示,自定义按钮名称带按钮事件 */
+ (void)showWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content buttonTitles:(NSArray <NSString *> * _Nullable)titles clickedHandle:(void(^ _Nullable)(NSInteger index))clickedBtn;

/**  警告消息展示,自定义按钮名称带按钮事件、警告框弹出完成回调 */
+ (void)showWithTitle:(NSString * _Nullable)title content:(NSString * _Nullable)content buttonTitles:(NSArray <NSString *> * _Nullable)titles clickedHandle:(void(^ _Nullable)(NSInteger index))clickedBtn compeletedHandle:(void(^ _Nullable)())handle;

/**  添加弹出框点击背景视图消失事件 */
- (void)tapGesDismissAlert;

@end

