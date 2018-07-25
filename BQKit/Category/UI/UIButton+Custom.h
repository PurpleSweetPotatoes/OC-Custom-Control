//
//  UIButton+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BtnEdgeType) {
    EdgeTypeCenter,
    EdgeTypeLeft,
    EdgeTypeRight,
    EdgeTypeImageTopLabBottom,
};

@interface UIButton (Custom)

/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;

/** 调整button imgView和lab位置 默认间距为5 */
- (void)adjustLabAndImageLocation:(BtnEdgeType)type;

/** 调整button imgView和lab位置 */
- (void)adjustLabAndImageLocation:(BtnEdgeType)type spacing:(CGFloat)spacing;



/**
 设置倒计时功能

 @param time 总时长
 @param interval 间隔时长
 @param block 回调
 */
- (void)reduceTime:(NSTimeInterval)time interval:(NSTimeInterval)interval callBlock:(void(^)(NSTimeInterval sec))block;

@end
