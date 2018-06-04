//
//  BQHintViewTool.h
//  TianyaTest
//
//  Created by MrBai on 2018/6/1.
//  Copyright © 2018年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 弹出视图管理工具
 使用时先添加提示视图，然后展示即可
 */
@interface BQHintViewTool : NSObject

/** 展示提示视图, 如hintView需要写加载动画，可以复写willMoveToSuperview方法*/
+ (void)showHintView;

/** 展示下一个提示视图, 如hintView需要自己写移除动画，则在移除后执行此方法*/
+ (void)showNextView;

/** 添加提示视图 */
+ (void)addHintView:(UIView *)hintView;

@end
