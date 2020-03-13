//
//  BQPopView.h
//  Test
//
//  Created by MAC on 16/11/2.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQDefineHead.h"

/// 消息提示视图
@interface BQMsgView : UIView

/// 展示消息
/// @param info 展示文本
+ (void)showInfo:(NSString *)info;

/// 展示信息
/// @param info 展示文本
/// @param callblock 展示完成回调
+ (void)showInfo:(NSString *)info
   completeBlock:(VoidBlock)callblock;

/// 展示信息
/// @param title 展示标题
/// @param info 展示文本
+ (void)showTitle:(NSString *)title
             info:(NSString *)info;

/// 展示信息
/// @param title 展示标题
/// @param info 展示文本
/// @param callblock 展示完成回调
+ (void)showTitle:(NSString *)title
             info:(NSString *)info
    completeBlock:(VoidBlock)callblock;
@end
