//
//  UIView+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIView+Custom.h"
#import "objc/runtime.h"


@interface UIView()

@property (nonatomic, strong) CAShapeLayer * bgColorLayer;
@property (nonatomic, assign) UIRectCorner  corners;

@end

@implementation UIView (Custom)

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

#pragma mark - 圆角

- (void)bq_setFrame:(CGRect)frame {
    [self bq_setFrame:frame];
    if (self.bgColorLayer) {
        self.bgColorLayer.frame = self.bounds;
        [self configBgLayer];
    }
}

- (void)bq_setBackgroundColor:(UIColor *)backgroundColor {
    if (self.bgColorLayer.superlayer) {
        [self bq_setBackgroundColor:[UIColor clearColor]];
        self.bgColorLayer.backgroundColor = backgroundColor.CGColor;
    } else {
        [self bq_setBackgroundColor:backgroundColor];
    }
}

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

- (void)setLayerRoundCorners:(UIRectCorner)corners withRadius:(CGFloat)radius {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] exchangeMethod:@selector(setBackgroundColor:) with:@selector(bq_setBackgroundColor:)];
        [[self class] exchangeMethod:@selector(setFrame:) with:@selector(bq_setFrame:)];
    });
    
    self.layer.cornerRadius = radius;
    self.corners = corners;
    [self configBgLayer];
}

- (void)removeLayerRoundCorners {
    self.layer.cornerRadius = 0;
    [self.bgColorLayer removeFromSuperlayer];
    self.backgroundColor = [UIColor colorWithCGColor:self.bgColorLayer.backgroundColor];
}

- (void)configBgLayer {
    
    CGColorRef bgColor = self.bgColorLayer ? self.bgColorLayer.fillColor : self.backgroundColor.CGColor;
    
    [self.bgColorLayer removeFromSuperlayer];
    self.bgColorLayer = [CAShapeLayer layer];
    UIBezierPath * roundPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.corners cornerRadii:CGSizeMake(self.layer.cornerRadius, self.layer.cornerRadius)];
    NSLog(@"配置新layer == %ld",self.corners);
    self.bgColorLayer.frame = self.bounds;
    self.bgColorLayer.path = roundPath.CGPath;
    self.bgColorLayer.fillColor = bgColor;
    [self.layer insertSublayer:self.bgColorLayer atIndex:0];
}

#pragma mark - 阴影

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

#pragma mark - 截图

- (UIImage *)convertToImage {
    CGSize size = CGSizeMake(self.layer.bounds.size.width, self.layer.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)tailorWithFrame:(CGRect)frame {
    
    if (CGRectGetMaxX(frame) > self.sizeW || CGRectGetMaxY(frame) > self.sizeH) {
        return nil;
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIImage * img = [self convertToImage];
    
    UIImage * image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, CGRectMake(frame.origin.x * scale, frame.origin.y * scale, frame.size.width * scale, frame.size.height * scale))];
    
    UIView * view = [[UIView alloc] initWithFrame:frame];
    view.layer.contents = (__bridge id)image.CGImage;
    return view;
    
}
#pragma mark - Associate

- (UIRectCorner)corners {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (void)setCorners:(UIRectCorner)corners {
    NSNumber * num = [NSNumber numberWithUnsignedInteger:corners];
    objc_setAssociatedObject(self, @selector(corners), num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)bgColorLayer {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBgColorLayer:(CAShapeLayer *)bgColorLayer {
    objc_setAssociatedObject(self, @selector(bgColorLayer), bgColorLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

