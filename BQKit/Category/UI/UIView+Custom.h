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

@interface UIView (Frame)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat sizeW;
@property (nonatomic, assign) CGFloat sizeH;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, readonly, assign) CGPoint thisCenter;

@end

@interface UIView (Radius)

/** 设置View的圆角 */
- (void)roundCorner:(CGFloat)radius;

/** 使图片变成圆形 */
- (void)toRound;


/** 设置边框 */
- (void)setBorderWidth:(CGFloat)lineWidth color:(UIColor *)color;

/** 添加部分圆角 */
- (void)setRoundCorners:(UIRectCorner)corners withRadius:(CGFloat)radius;

@end

@interface UIView (Shadow)

/** 添加渐变阴影 length:阴影宽度 */
- (void)addGradientShadow:(GradientShadowDirection)direction withLength:(CGFloat)length;

/** 添加渐变阴影 rect:阴影位置 */
- (void)addGradientShadow:(GradientShadowDirection)direction inRect:(CGRect)rect;

/** 自定义渐变颜色值 */
- (void)addGradientShadow:(GradientShadowDirection)direction withLength:(CGFloat)length startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

- (void)addGradientShadow:(GradientShadowDirection)direction inRect:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

 /** View to Image */
- (UIImage *)convertToImage;

@end
