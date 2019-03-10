//
//  UIAlertController+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQDefineHead.h"

@interface UIAlertController (Custom)

+ (void)showWithTitle:(NSString *)title;

+ (void)showWithContent:(NSString *)content;

/**  警告消息展示 */
+ (void)showWithTitle:(nullable NSString *)title content:(nullable NSString *)content;

/**  警告消息展示，带点击回调 */
+ (void)showWithTitle:(nullable NSString *)title content:(nullable NSString *)content handle:(nullable void(^)(NSInteger index))clickedBtn;

/**  警告消息展示,自定义按钮名称带按钮事件 */
+ (void)showWithTitle:(nullable NSString *)title content:(nullable NSString *)content buttonTitles:(NSArray <NSString *> *)titles clickedHandle:(nullable void(^)(NSInteger index))clickedBtn;

/**  警告消息展示,自定义按钮名称带按钮事件、警告框弹出完成回调 */
+ (void)showWithTitle:(nullable NSString * )title content:(nullable NSString *)content buttonTitles:(NSArray <NSString *> *)titles clickedHandle:(nullable void(^)(NSInteger index))clickedBtn compeletedHandle:(nullable VoidBlock)handle;

/**  添加弹出框点击背景视图消失事件 */
- (void)tapGesDismissAlert;

@end

