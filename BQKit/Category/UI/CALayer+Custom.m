//
//  CALayer+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "CALayer+Custom.h"

@implementation CALayer (Frame)

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

- (void)setSize:(CGSize)size{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (CGSize)size{
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

+ (instancetype)cellLineLayerWithFrame:(CGRect)frame {
    return [self layerWithFrame:frame color:[UIColor colorWithRed:0xca/ 255.0 green:0xc9/ 255.0 blue:0xc9/ 255.0 alpha:1]];
}

+ (instancetype)layerWithFrame:(CGRect)frame color:(UIColor *)backColor {
    CALayer * lineLayer = [self layer];
    lineLayer.frame = frame;
    lineLayer.backgroundColor = backColor.CGColor;
    return lineLayer;
}
@end
