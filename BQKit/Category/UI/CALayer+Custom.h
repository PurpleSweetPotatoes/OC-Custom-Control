//
//  CALayer+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (Custom)

#pragma mark - Frame

@property (nonatomic, assign          ) CGFloat bottom;
@property (nonatomic, assign          ) CGFloat height;
@property (nonatomic, assign          ) CGFloat left;
@property (nonatomic, assign          ) CGPoint origin;
@property (nonatomic, assign          ) CGFloat right;
@property (nonatomic, assign          ) CGSize  size;
@property (nonatomic, readonly, assign) CGPoint sizeCenter;
@property (nonatomic, assign          ) CGFloat top;
@property (nonatomic, assign          ) CGFloat width;

#pragma mark - Create

/** 同cell底部灰线颜色相同 */
+ (instancetype)cellLineLayerWithFrame:(CGRect)frame;

/** 线条layer */
+ (instancetype)layerWithFrame:(CGRect)frame
                         color:(UIColor *)backColor;

/** 带圆角layer */
+ (CAShapeLayer *)roundLayerWithFrame:(CGRect)frame
                                color:(UIColor *)color
                               radius:(CGFloat)radius
                             corner:(UIRectCorner)corner;

/// 转化为图片
- (UIImage *)convertToImage;

/// 创建全屏引导视图
/// @param rect 留白区域
+ (instancetype)guideLayerWithFrame:(CGRect)rect;

/// 创建引导视图
/// @param rect 留白区域
/// @param inSize 引导图大小
+ (instancetype)guideLayerWithFrame:(CGRect)rect inSize:(CGSize)size;

/// 创建引导视图
/// @param rect 留白区域
/// @param inSize 引导图大小
/// @param bgColor 引导图背景色
+ (instancetype)guideLayerWithFrame:(CGRect)rect inSize:(CGSize)size bgColor:(UIColor *)color;

@end
