//
//  UIView+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIView+Custom.h"

static NSString * const kBgLayerColor = @"UIViewRoundLayerColor";

@implementation UIView (Frame)

- (void)setOrigin:(CGPoint)origin{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (CGPoint)thisCenter {
    return CGPointMake(self.sizeW * 0.5,self.sizeH * 0.5);
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

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSizeW:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width  = width;
    self.frame = rect;
}

- (CGFloat)sizeW {
    return self.size.width;
}

- (void)setSizeH:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (CGFloat)sizeH {
    return self.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    self.top = bottom - self.sizeH;
}

- (void)setRight:(CGFloat)right {
    self.left = right - self.sizeW;
}

- (CGFloat)right {
    return self.left + self.sizeW;
}

- (CGFloat)bottom {
    return self.top + self.sizeH;
}

@end


@implementation UIView (Radius)

- (void)roundCorner:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.layer.allowsEdgeAntialiasing = YES;
}

- (void)toRound {
    CGFloat diameter = 0.0f;
    
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == self && constraint.secondItem == nil
            && constraint.firstAttribute == NSLayoutAttributeWidth) {
            diameter = constraint.constant;
            break;
        }
    }
    
    if (diameter == 0) {
        diameter = self.bounds.size.width;
    }
    
    self.layer.allowsEdgeAntialiasing = YES;
    self.layer.cornerRadius = diameter / 2.0f;
    self.layer.masksToBounds = YES;
}

- (void)setBorderWidth:(CGFloat)lineWidth color:(UIColor *)color {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = lineWidth;
}

- (void)setRoundCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {
    
    UIColor * bgColor = self.backgroundColor;
    self.backgroundColor = [UIColor clearColor];
    
    for (CALayer * layer in [self.layer sublayers]) {
        if ([layer.name isEqualToString:kBgLayerColor] && [layer isKindOfClass:[CAShapeLayer class]]) {
            bgColor = [UIColor colorWithCGColor:((CAShapeLayer *)layer).fillColor];
            [layer removeFromSuperlayer];
            break;
        }
    }
    
    UIBezierPath * roundPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer * roundLayer = [[CAShapeLayer alloc] init];
    roundLayer.name = kBgLayerColor;
    roundLayer.frame = self.bounds;
    roundLayer.path = roundPath.CGPath;
    roundLayer.fillColor = bgColor.CGColor;
    
    [self.layer insertSublayer:roundLayer atIndex:0];
}
@end


@implementation UIView (Shadow)

- (void)addGradientShadow:(GradientShadowDirection)direction withLength:(CGFloat)length {
    CGRect rect;
    
    switch (direction) {
        case GradientShadowFromTop:
            rect = CGRectMake(0, 0, self.bounds.size.width, length);
            break;
        case GradientShadowFromLeft:
            rect = CGRectMake(0, 0, length, self.bounds.size.height);
            break;
        case GradientShadowFromBottom:
            rect = CGRectMake(0, self.bounds.size.height - length, self.bounds.size.width, length);
            break;
        case GradientShadowFromRight:
            rect = CGRectMake(self.bounds.size.width - length, 0, length, self.bounds.size.height);
            break;
        default:
            rect = CGRectMake(0, 0, self.bounds.size.width, length);
            break;
    }
    
    [self addGradientShadow:direction inRect:rect];
}

- (void)addGradientShadow:(GradientShadowDirection)direction inRect:(CGRect)rect {
    
    UIColor * startColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UIColor * endColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.000001];
    
    [self addGradientShadow:direction inRect:rect startColor:startColor endColor:endColor];
}

- (void)addGradientShadow:(GradientShadowDirection)direction withLength:(CGFloat)length startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    CGRect rect;
    
    switch (direction) {
        case GradientShadowFromTop:
            rect = CGRectMake(0, 0, self.bounds.size.width, length);
            break;
        case GradientShadowFromLeft:
            rect = CGRectMake(0, 0, length, self.bounds.size.height);
            break;
        case GradientShadowFromBottom:
            rect = CGRectMake(0, self.bounds.size.height - length, self.bounds.size.width, length);
            break;
        case GradientShadowFromRight:
            rect = CGRectMake(self.bounds.size.width - length, 0, length, self.bounds.size.height);
            break;
        default:
            rect = CGRectMake(0, 0, self.bounds.size.width, length);
            break;
    }
    
    [self addGradientShadow:direction inRect:rect startColor:startColor endColor:endColor];
}

- (void)addGradientShadow:(GradientShadowDirection)direction inRect:(CGRect)rect startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    
    CGPoint startPoint, endPoint;
    
    switch (direction) {
        case GradientShadowFromTop:
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(0, 1);
            break;
        case GradientShadowFromLeft:
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(1, 0);
            break;
        case GradientShadowFromBottom:
            startPoint = CGPointMake(1, 1);
            endPoint = CGPointMake(1, 0);
            break;
        case GradientShadowFromRight:
            startPoint = CGPointMake(1, 0);
            endPoint = CGPointMake(0, 0);
            break;
        default:
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(0, 1);
            break;
    }
    
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    
    [self.layer addSublayer:gradientLayer];
}

- (UIImage *)convertToImage {
    CGSize size = CGSizeMake(self.layer.bounds.size.width, self.layer.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

