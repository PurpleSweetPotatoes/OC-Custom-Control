//
//  UIButton+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Custom)

/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;

/**设置点击范围,外扩为负,内缩为正*/
@property (nonatomic,assign) UIEdgeInsets hitTestEdgeInsets;

/**
 设置倒计时功能

 @param time 总时长
 @param interval 间隔时长
 @param block 回调
 */
- (void)reduceTime:(NSTimeInterval)time interval:(NSTimeInterval)interval callBlock:(void(^)(NSTimeInterval sec))block;

@end
