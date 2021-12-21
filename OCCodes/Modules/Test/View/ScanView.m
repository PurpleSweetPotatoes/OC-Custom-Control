// *******************************************
//  File Name:      ScanView.m       
//  Author:         MrBai
//  Created Date:   2021/12/21 4:30 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "ScanView.h"

#import "CALayer+Custom.h"
#import "UILabel+Custom.h"
#import "UIView+Custom.h"
#import "UIColor+Custom.h"

@interface ScanView ()
@property (nonatomic, strong) CALayer         * guideLayer;
@property (nonatomic, strong) CAShapeLayer    * borderLayer;
@property (nonatomic, strong) CALayer         * animationLayer;
@property (nonatomic, strong) UILabel         * tipLab;
@end

@implementation ScanView


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)dealloc {
    [self stopAnimation];
}

- (instancetype)initWithFrame:(CGRect)frame scanFrame:(CGRect)scanFrame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scanFrame = scanFrame;
        [self configUI];
    }
    return self;
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

#pragma mark - *** Delegate

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    [self.layer addSublayer:self.guideLayer];
    
    [self.guideLayer addSublayer:self.borderLayer];
    
    [self.borderLayer addSublayer:self.animationLayer];
}

- (void)showAnimation {
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.fromValue = @(self.animationLayer.top);
    animation.toValue = @(self.borderLayer.bottom + 4);
    animation.duration = 2.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = CGFLOAT_MAX;
    [self.animationLayer addAnimation:animation forKey:@"animationLayer"];
}

- (void)stopAnimation {
    [self.animationLayer removeAllAnimations];
}


- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        [self stopAnimation];
    } else {
        [self showAnimation];
    }
}
#pragma mark - *** Set

#pragma mark - *** Get
    
- (CALayer *)guideLayer {
    if (_guideLayer == nil) {
        CALayer * guideLayer = [CALayer guideLayerWithFrame:self.scanFrame inSize:CGSizeMake(self.width, self.top + self.height) bgColor:[UIColor colorWithWhite:0 alpha:0.5] radius:0];
        _guideLayer = guideLayer;
    }
    return _guideLayer;
}

- (CAShapeLayer *)borderLayer {
    if (_borderLayer == nil) {
        CAShapeLayer * borderLayer = [CAShapeLayer layer];
        borderLayer.frame = self.scanFrame;
        borderLayer.masksToBounds = YES;
        CGFloat lineW = 20;
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, lineW)];
        [path addLineToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(lineW, 0)];
        
        [path moveToPoint:CGPointMake(borderLayer.width - lineW, 0)];
        [path addLineToPoint:CGPointMake(borderLayer.width , 0)];
        [path addLineToPoint:CGPointMake(borderLayer.width, lineW)];
        
        [path moveToPoint:CGPointMake(borderLayer.width, borderLayer.height - lineW)];
        [path addLineToPoint:CGPointMake(borderLayer.width, borderLayer.height)];
        [path addLineToPoint:CGPointMake(borderLayer.width - lineW, borderLayer.height)];
        
        [path moveToPoint:CGPointMake(lineW, borderLayer.height)];
        [path addLineToPoint:CGPointMake(0, borderLayer.height)];
        [path addLineToPoint:CGPointMake(0, borderLayer.height - lineW)];
        
        borderLayer.lineWidth = 6;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [UIColor greenColor].CGColor;
        borderLayer.path = path.CGPath;
        
        _borderLayer = borderLayer;
    }
    return _borderLayer;
}

- (CALayer *)animationLayer {
    if (_animationLayer == nil) {
        UIColor * color = [UIColor colorWithCGColor:self.borderLayer.strokeColor];
        CAGradientLayer * animationLayer = [CAGradientLayer layer];
        animationLayer.frame = CGRectMake(5, -4, self.borderLayer.width - 10, 4);
        animationLayer.colors = @[(__bridge  id)[UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:0.2].CGColor, (__bridge  id)self.borderLayer.strokeColor, (__bridge  id)[UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:0.2].CGColor];
        animationLayer.locations = @[@0.05, @0.5, @0.95];
        animationLayer.startPoint = CGPointMake(0, 0.5);
        animationLayer.endPoint = CGPointMake(1, 0.5);
        _animationLayer = animationLayer;
    }
    return _animationLayer;
}

- (UILabel *)tipLab {
    if (_tipLab == nil) {
        UILabel * tipLab = [UILabel labWithFrame:CGRectMake(0, self.borderLayer.bottom + 10, self.width, 20) title:@"扫描二维码或条形码" fontSize:16 textColor:[UIColor whiteColor]];
        tipLab.textAlignment = NSTextAlignmentCenter;
        _tipLab = tipLab;
    }
    return _tipLab;
}
@end
