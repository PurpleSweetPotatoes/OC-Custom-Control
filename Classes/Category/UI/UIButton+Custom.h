//
//  UIButton+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, BtnImgPosition) {
    BtnImgPosition_Left = 0,             //图片在左，文字在右，默认
    BtnImgPosition_Right,                //图片在右，文字在左
    BtnImgPosition_Top,                  //图片在上，文字在下
    BtnImgPosition_Bottom,               //图片在下，文字在上
};


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


/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)configImagePosition:(BtnImgPosition)postion spacing:(CGFloat)spacing;

@end
