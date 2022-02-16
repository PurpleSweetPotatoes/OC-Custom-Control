// *******************************************
//  File Name:      BQProgressView.m       
//  Author:         MrBai
//  Created Date:   2022/2/16 9:39 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQProgressView.h"

@interface BQProgressView ()
@property (nonatomic, assign) BQProgressType type;
@property (nonatomic, strong) CAShapeLayer   * bgLayer;
@property (nonatomic, strong) CAShapeLayer   * colorLayer;
@property (nonatomic, strong) UILabel        * textLab;
@end

@implementation BQProgressView


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (instancetype)initWithFrame:(CGRect)frame type:(BQProgressType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
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
    if (BQProgressTypeCircleText >= self.type) {
        [self configCirleUI];
    }
    
    [self.layer addSublayer:self.bgLayer];
    [self.layer addSublayer:self.colorLayer];
}

- (void)configCirleUI {
    [self configCirLayer:self.bgLayer storeColor:UIColor.lightGrayColor];
    [self configCirLayer:self.colorLayer storeColor:UIColor.whiteColor];
    
    
    self.bgLayer.path = [self getCirlePathWithPercent:1].CGPath;
    
    if (BQProgressTypeCircleText == self.type) {
        [self addSubview:self.textLab];
    }
}

- (void)configCirLayer:(CAShapeLayer *)layer storeColor:(UIColor *)color {
    layer.frame = self.bounds;
    layer.lineWidth = self.bounds.size.height * 0.1;
    layer.strokeColor = color.CGColor;
    layer.lineCap = kCALineCapRound;
    layer.fillColor = UIColor.clearColor.CGColor;
}

- (UIBezierPath *)getCirlePathWithPercent:(CGFloat)percent {
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5) radius:self.bounds.size.width * 0.5 startAngle:1.5 * M_PI endAngle:1.5 * M_PI + 2 * M_PI * percent clockwise:YES];
    return path;
}

#pragma mark - *** Set

- (void)setPercent:(CGFloat)percent {
    if (percent >= 0 && percent <= 1) {
        if (self.type <= BQProgressTypeCircleText) {
            self.colorLayer.path = [self getCirlePathWithPercent:percent].CGPath;
            if (BQProgressTypeCircleText == self.type) {
                self.textLab.text = [NSString stringWithFormat:@"%.0f%%", percent * 100];
            }
        }
    }
}

- (void)setColorHeight:(CGFloat)height {
    if (self.type <= BQProgressTypeCircleText) {
        self.bgLayer.lineWidth = height;
        self.colorLayer.lineWidth = height;
    }
}

- (void)setShowColor:(UIColor *)showColor {
    self.colorLayer.strokeColor = showColor.CGColor;
}

- (void)setBgColor:(UIColor *)bgColor {
    self.bgLayer.strokeColor = bgColor.CGColor;
}

#pragma mark - *** Get
    
- (UILabel *)textLab {
    if (_textLab == nil) {
        UILabel * textLab = [[UILabel alloc] initWithFrame:self.bounds];
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.font = [UIFont fontWithName:@"Helvetica Neue" size:self.bgLayer.lineWidth * 2.5];
        textLab.textColor = UIColor.whiteColor;
        textLab.text = @"0%";
        _textLab = textLab;
    }
    return _textLab;
}

- (CAShapeLayer *)bgLayer {
    if (_bgLayer == nil) {
        CAShapeLayer * bgLayer = [[CAShapeLayer alloc] init];
        _bgLayer = bgLayer;
    }
    return _bgLayer;
}

- (CAShapeLayer *)colorLayer {
    if (_colorLayer == nil) {
        CAShapeLayer * colorLayer = [[CAShapeLayer alloc] init];
        _colorLayer = colorLayer;
    }
    return _colorLayer;
}

@end
