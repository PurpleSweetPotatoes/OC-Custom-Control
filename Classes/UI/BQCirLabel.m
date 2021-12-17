//
//  BQCirLabel.m
//  tianyaTest
//
//  Created by baiqiang on 2019/4/28.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "BQCirLabel.h"
#import "UIColor+Custom.h"

@interface BQCirLabel()
@property (nonatomic, strong) CAShapeLayer * cirBgLayer;
@property (nonatomic, strong) CAShapeLayer * cirShowLayer;
@end

@implementation BQCirLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cirBgColor = [UIColor hexstr:@"f2f2f2"];
        _cirShowColor = [UIColor blueColor];
        _cirpercentNum = 0;
        _cirWidth = 10;
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setCirBgColor:(UIColor *)cirBgColor {
    _cirBgColor = cirBgColor;
    [self setNeedsLayout];
}
- (void)setCirWidth:(CGFloat)cirWidth {
    _cirWidth = cirWidth;
    [self setNeedsLayout];
}

- (void)setCirShowColor:(UIColor *)cirShowColor {
    _cirShowColor = cirShowColor;
    [self setNeedsLayout];
}

- (void)setCirpercentNum:(CGFloat)cirpercentNum {
    _cirpercentNum = cirpercentNum;
    [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.cirBgLayer removeFromSuperlayer];
    [self.cirShowLayer removeFromSuperlayer];
    
    CAShapeLayer * cirLayer = [CAShapeLayer layer];
    cirLayer.frame = self.bounds;
    cirLayer.lineWidth = self.cirWidth;
    cirLayer.strokeColor = self.cirBgColor.CGColor;
    cirLayer.lineCap = kCALineCapRound;
    cirLayer.fillColor = [UIColor clearColor].CGColor;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.width * 0.5) radius:(self.bounds.size.width - self.cirWidth) * 0.5 startAngle:-0.5 * M_PI endAngle:1.5 * M_PI clockwise:true];
    cirLayer.path = path.CGPath;
    [self.layer addSublayer:cirLayer];
    self.cirBgLayer =  cirLayer;
    
    if (self.cirpercentNum >= 1) {
        cirLayer.strokeColor = self.cirShowColor.CGColor;
    } else if (self.cirpercentNum != 0){
        CAShapeLayer * cirShowLayer = [CAShapeLayer layer];
        cirShowLayer.frame = self.bounds;
        cirShowLayer.lineWidth = self.cirWidth;
        cirShowLayer.strokeColor = self.cirShowColor.CGColor;
        cirShowLayer.lineCap = kCALineCapRound;
        cirShowLayer.fillColor = [UIColor clearColor].CGColor;
        
        UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.width * 0.5) radius:(self.bounds.size.width - self.cirWidth) * 0.5 startAngle:-0.5 * M_PI endAngle:2 * M_PI * self.cirpercentNum - 0.5 * M_PI clockwise:true];
        cirShowLayer.path = path.CGPath;
        [self.layer addSublayer:cirShowLayer];
        self.cirShowLayer = cirShowLayer;
    }
    
}

@end
