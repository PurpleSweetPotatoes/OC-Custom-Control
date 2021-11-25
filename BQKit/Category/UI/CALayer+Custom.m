//
//  CALayer+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "CALayer+Custom.h"

#import "UIColor+Custom.h"

@implementation CALayer (Custom)

- (void)setOrigin:(CGPoint)origin{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (CGPoint)sizeCenter {
    return CGPointMake(self.width * 0.5,self.height * 0.5);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setLeft:(CGFloat)left {
    CGRect rect = self.frame;
    rect.origin.x  = left;
    self.frame = rect;
}

- (CGFloat)left {
    return self.origin.x;
}

- (void)setTop:(CGFloat)top {
    CGRect rect = self.frame;
    rect.origin.y  = top;
    self.frame = rect;
}

- (CGFloat)top {
    return self.origin.y;
}

- (void)setSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (CGSize)size{
    return self.bounds.size;
}

- (void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width  = width;
    self.frame = rect;
}

- (CGFloat)width {
    return self.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)height {
    return self.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    self.top = bottom - self.height;
}

- (void)setRight:(CGFloat)right {
    self.left = right - self.width;
}

- (CGFloat)right {
    return self.left + self.width;
}

- (CGFloat)bottom {
    return self.top + self.height;
}

- (UIImage *)convertToImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    [self renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)cellLineLayerWithFrame:(CGRect)frame {
    return [self layerWithFrame:frame color:[UIColor hexstr:@"c9c9c9"]];
}

+ (instancetype)layerWithFrame:(CGRect)frame color:(UIColor *)backColor {
    CALayer * lineLayer = [self layer];
    lineLayer.frame = frame;
    lineLayer.backgroundColor = backColor.CGColor;
    return lineLayer;
}

/** 带圆角layer */
+ (CAShapeLayer *)roundLayerWithFrame:(CGRect)frame
                                color:(UIColor *)color
                               radius:(CGFloat)radius
                             corner:(UIRectCorner)corner {
    CAShapeLayer * shapLayer = [CAShapeLayer layer];
    shapLayer.frame = frame;
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:shapLayer.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    shapLayer.fillColor = color.CGColor;
    shapLayer.path = path.CGPath;
    return shapLayer;
}

+ (instancetype)guideLayerWithFrame:(CGRect)rect {
    return [self guideLayerWithFrame:rect inSize:[UIScreen mainScreen].bounds.size];
}

+ (instancetype)guideLayerWithFrame:(CGRect)rect inSize:(CGSize)size {
    return [self guideLayerWithFrame:rect inSize:size bgColor:[UIColor colorWithWhite:0 alpha:0.8]];
}

+ (instancetype)guideLayerWithFrame:(CGRect)rect inSize:(CGSize)size bgColor:(UIColor *)color {
    CALayer * outLayer = [CALayer layerWithFrame:CGRectMake(0, 0, size.width, size.height) color:[UIColor clearColor]];
    if (CGRectEqualToRect(rect, CGRectZero)) {
        return outLayer;
    }
    [outLayer addSublayer:[CALayer layerWithFrame:CGRectMake(0, 0, size.width, rect.origin.y) color:color]];
    [outLayer addSublayer:[CALayer layerWithFrame:CGRectMake(0, rect.origin.y, rect.origin.x, rect.size.height) color:color]];
    [outLayer addSublayer:[CALayer layerWithFrame:CGRectMake(0, CGRectGetMaxY(rect), size.width, size.height - CGRectGetMaxY(rect)) color:color]];
    [outLayer addSublayer:[CALayer layerWithFrame:CGRectMake(CGRectGetMaxX(rect), rect.origin.y, size.width - CGRectGetMaxX(rect), CGRectGetMaxY(rect) - rect.origin.y) color:color]];
    return outLayer;
}

@end
