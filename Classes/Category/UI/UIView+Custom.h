//
//  UIView+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientShadowDirection) {
    GradientShadowFromTop = 0,
    GradientShadowFromLeft,
    GradientShadowFromBottom,
    GradientShadowFromRight
};

@interface UIView (Custom)

#pragma mark - Frame

@property (nonatomic, assign          ) CGSize  size;
@property (nonatomic, assign          ) CGPoint origin;
@property (nonatomic, assign          ) CGFloat left;
@property (nonatomic, assign          ) CGFloat top;
@property (nonatomic, assign          ) CGFloat width;
@property (nonatomic, assign          ) CGFloat height;
@property (nonatomic, assign          ) CGFloat right;
@property (nonatomic, assign          ) CGFloat bottom;
@property (nonatomic, readonly, assign) CGPoint midPoint;

#pragma mark - 圆角

/** 设置View的圆角 */
- (void)setRadius:(CGFloat)radius;

/** 使图片变成圆形 */
- (void)toRound;

/** 设置边框 */
- (void)setBorderWidth:(CGFloat)lineWidth color:(UIColor *)color;

/** 利用Layer添加部分圆角 */
- (void)setLayerRoundCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;

/** 移除Layer圆角 */
- (void)removeLayerRoundCorners;

#pragma mark - 阴影

/** 添加渐变阴影 length:阴影宽度 */
- (void)addGradientShadow:(GradientShadowDirection)direction withLength:(CGFloat)length;

/** 添加渐变阴影 rect:阴影位置 */
- (void)addGradientShadow:(GradientShadowDirection)direction inRect:(CGRect)rect;

/** 自定义渐变颜色值 */
- (void)addGradientShadow:(GradientShadowDirection)direction withLength:(CGFloat)length startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

- (CALayer *)addGradientShadow:(GradientShadowDirection)direction inRect:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

#pragma mark - 截图

 /** View to Image */
- (UIImage *)convertToImage;

/** 范围内裁剪 */
- (UIView *)tailorWithFrame:(CGRect)frame;


/** 视图对应的控制器 */
- (UIViewController *)viewController;


/// 视图滤镜灰度处理，使用后视图为灰色(私有api)
- (void)showGray;

/// 清除自定义滤镜
- (void)clearFilters;

@end
