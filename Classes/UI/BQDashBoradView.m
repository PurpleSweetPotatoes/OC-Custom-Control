// *******************************************
//  File Name:      BQDashBoradView.m       
//  Author:         MrBai
//  Created Date:   2022/1/10 3:19 PM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQDashBoradView.h"

#import "UILabel+Custom.h"
#import "UIView+Custom.h"

@interface BQDashBoradView ()
{
    CGPoint _center;
    CGFloat _preSpeed;
}
@property (nonatomic, assign) CGFloat     ringWidth;
@property (nonatomic, assign) NSInteger   areaNum;
@property (nonatomic, assign) NSInteger   areaDailNum;
@property (nonatomic, assign) CGFloat     maxNum;
@property (nonatomic, assign) CGFloat     startAngle;
@property (nonatomic, assign) CGFloat     endAngle;
@property (nonatomic, strong) UILabel     * tipLab;
@property (nonatomic, strong) UIImageView * pointerView;
@end

@implementation BQDashBoradView


#pragma mark - *** Public method

- (void)setDailTextList:(NSArray<NSString *> *)list {
    if (list.count == self.areaNum + 1) {
        // 刻度 外点半径
        CGFloat outsideRadius = (self.width - self.ringWidth) * 0.5 - self.ringWidth / 2;
        // 刻度 内点半径
        CGFloat insideRadius = outsideRadius - self.ringWidth - 18;
        CGFloat areaAngle = (self.endAngle - self.startAngle) / self.areaNum;
        for (NSInteger i = 0; i < list.count; i++) {
            CGFloat angle = self.startAngle - i * areaAngle;
            CATextLayer * textLayer = [CATextLayer layer];
            textLayer.frame = CGRectMake(0, 0, 50, 16);
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.foregroundColor = [UIColor whiteColor].CGColor;
            textLayer.fontSize = 14;
            textLayer.string = list[i];
            textLayer.position = CGPointMake(_center.x - (insideRadius * sin(angle)), _center.y - (insideRadius * cos(angle)));
            [self.layer addSublayer:textLayer];
        }
    } else {
        NSLog(@"数字刻度盘长度与区域不对应");
    }
}

- (void)reSetSpeed:(CGFloat)speed {
    if (speed >= self.maxNum) {
        speed = self.maxNum;
    } else if (speed < 0) {
        speed = 0;
    }
    // 旋转角度 默认竖直角度为0度
    CGFloat angle = (speed / self.maxNum - 0.5) * 270/180.0*M_PI;
    [UIView animateWithDuration:0.5 animations:^{
        self.pointerView.transform = CGAffineTransformMakeRotation(angle);
    }];
    self.tipLab.text = [NSString stringWithFormat:@"%.2f\n km/h", speed];
}
#pragma mark - *** Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame ringWidth:10 areaNum:10 areaDailNum:2 maxNum:100];
}

- (instancetype)initWithFrame:(CGRect)frame ringWidth:(CGFloat)ringWidth areaNum:(NSInteger)areaNum areaDailNum:(NSInteger)areaDailNum maxNum:(CGFloat)maxNum {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.ringWidth = ringWidth;
        self.areaNum = areaNum;
        self.areaDailNum = areaDailNum;
        self.maxNum = maxNum;
        self.startAngle = M_PI_2 + M_PI_4;
        self.endAngle = M_PI * 2 + M_PI_4;
        _preSpeed = 0;
        _center = self.thisCenter;
        
        [self configUI];
    }
    return self;
}

#pragma mark - *** UI method

- (void)configUI {
    [self addCircleLayer];
    [self addSubview:self.tipLab];
    [self addSubview:self.pointerView];
}

/// 渐变色圆环仪表盘
- (void)addCircleLayer {
    // 渐变层
    CALayer * gradientLayer = [CALayer layer];
    [gradientLayer addSublayer:[self gradientLayerWithFrame:CGRectMake(0, 0, self.width * 0.5, self.height) colors:@[(id)[UIColor greenColor].CGColor, (id)[UIColor yellowColor].CGColor] locations:@[@(0.1), @(0.7)]]];
    [gradientLayer addSublayer:[self gradientLayerWithFrame:CGRectMake(self.width * 0.5, 0, self.width * 0.5, self.height) colors:@[(id)[UIColor greenColor].CGColor, (id)[UIColor redColor].CGColor] locations:@[@(0.1), @(0.7)]]];
    [self.layer addSublayer:gradientLayer];
    
    // 遮罩层
    gradientLayer.mask = [self maskLayer];
    
}

- (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame
                                     colors:(NSArray *)colors
                                  locations:(NSArray<NSNumber *> *)locations {
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    gradientLayer.colors = colors;
    gradientLayer.locations = locations;
    return gradientLayer;
}

- (CALayer *)maskLayer {
    
    CALayer * maskLayer = [CALayer layer];
    // 环形Layer层
    [self addCircleLayerWithLayar:maskLayer];
    // 添加刻度层
    [self addDialLayerWithLayer:maskLayer];
    
    return maskLayer;
}

- (void)addCircleLayerWithLayar:(CALayer *)supLayer {
    CAShapeLayer * circleLayer = [self shapeLayerWithLineWidth:self.ringWidth];
    circleLayer.path = [UIBezierPath bezierPathWithArcCenter:_center radius:(self.width - self.ringWidth) * 0.5 startAngle:self.startAngle endAngle:self.endAngle clockwise:YES].CGPath;
    [supLayer addSublayer:circleLayer];
}

- (void)addDialLayerWithLayer:(CALayer *)supLayer {
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGFloat areaAngle = (self.endAngle - self.startAngle) / self.areaNum;
    // 区域内刻度 偏移角度
    CGFloat dialAngle = areaAngle / self.areaDailNum;
    // 刻度 外点半径
    CGFloat outsideRadius = (self.width - self.ringWidth) * 0.5 - self.ringWidth / 2;
    // 刻度 内点半径
    CGFloat insideRadius = outsideRadius - self.ringWidth - 5;
    // 区域 刻度长度
    CGFloat areainsidRadius = outsideRadius - self.ringWidth;
    
    for (NSInteger i = 0; i <= self.areaNum; i++) {
        CGFloat angle = self.startAngle - i * areaAngle;
        CGPoint insidePoint = CGPointMake(_center.x - (insideRadius * sin(angle)), _center.y - (insideRadius * cos(angle)));// 刻度内点
        CGPoint outsidePoint = CGPointMake(_center.x - (outsideRadius * sin(angle)), _center.y - (outsideRadius * cos(angle)));// 刻度外点
        [path moveToPoint:insidePoint];
        [path addLineToPoint:outsidePoint];
        
        // 区域内刻度
        for (NSInteger j = 1; j < self.areaDailNum && i < self.areaNum; j++) {
            angle -= dialAngle;
            insidePoint = CGPointMake(_center.x - (areainsidRadius * sin(angle)), _center.y - (areainsidRadius * cos(angle)));// 刻度内点
            outsidePoint = CGPointMake(_center.x - (outsideRadius * sin(angle)), _center.y - (outsideRadius * cos(angle)));// 刻度外点
            [path moveToPoint:insidePoint];
            [path addLineToPoint:outsidePoint];
        }
    }
    
    CAShapeLayer * dailLayer = [self shapeLayerWithLineWidth:1];
    dailLayer.path = path.CGPath;
    [supLayer addSublayer:dailLayer];
}

- (CAShapeLayer *)shapeLayerWithLineWidth:(CGFloat)width {
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = width;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    return shapeLayer;
}

#pragma mark - *** get

- (UILabel *)tipLab {
    if (_tipLab == nil) {
        UILabel * tipLab = [UILabel labWithFrame:CGRectMake(0, self.height - 80, self.width, 80) title:@"0\n km/h" font:[UIFont fontWithName:@"Helvetica Neue" size:30] textColor:[UIColor whiteColor]];
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.numberOfLines = 0;
        _tipLab = tipLab;
    }
    return _tipLab;
}

- (UIImageView *)pointerView {
    if (!_pointerView) {
        _pointerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointerV2.png"]];
        _pointerView.frame =  CGRectMake(_center.x - 10, _center.y - self.bounds.size.width/6, 20, self.bounds.size.width/3);
        _pointerView.contentMode = UIViewContentModeScaleAspectFit;
        _pointerView.layer.anchorPoint = CGPointMake(0.5f, 0.9f); // 锚点
        _pointerView.transform = CGAffineTransformMakeRotation(-(M_PI_2 + M_PI_4));
    }
    return _pointerView;
}

@end
