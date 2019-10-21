//
//  BQSliderView.m
//  tianyaTest
//
//  Created by baiqiang on 2019/6/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BQSliderView.h"
#import "NSBundle+BQPlayer.h"
#import "UIView+Custom.h"
#import "UILabel+Custom.h"
#import "CALayer+Custom.h"

@interface BQSliderView ()
@property (nonatomic, strong) CALayer * bgLayer;
@property (nonatomic, strong) CALayer * bufferLayer;
@property (nonatomic, strong) CALayer * sliderLayer;
@property (nonatomic, strong) UIView * gestureView;
@property (nonatomic, strong) UIImageView * imgV;
@property (nonatomic, strong) UILabel * leftLab;
@property (nonatomic, strong) UILabel * rightLab;
@end

@implementation BQSliderView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configData];
        [self configUI];
        [self configGesture];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self adjustFrame];
}
#pragma mark - Public method

#pragma mark - NetWork method

#pragma mark - Btn Action
- (void)gestureAction:(UIGestureRecognizer *)sender {
    
    if (!self.canSlide) return;
    
    CGPoint point = [sender locationInView:sender.view];
    if (point.x >= 0 && point.x <= _gestureView.sizeW) {
        self.sliderValue = point.x / _gestureView.sizeW * _maxValue;
    }
    if (sender.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(sliderBeignChange:)]) {
            [self.delegate sliderBeignChange:self];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(sliderEndChange:)]) {
            [self.delegate sliderEndChange:self];
        }
    }
}
#pragma mark - Delegate

#pragma mark - Instance method
- (void)configData {
    _sliderBgColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
    _bufferColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    _sliderColor = [UIColor whiteColor];
    _sliderValue = 0;
    _maxValue = 0;
    _showValueInfo = YES;
    self.userInteractionEnabled = NO;
}

- (void)configLabInfo {
    _leftLab.text = [self stringFromWithTime:_sliderValue];
    _rightLab.text = [self stringFromWithTime:_maxValue];
    
    [_leftLab widthToFit];
    [_rightLab widthToFit];
    
    _leftLab.left = 0;
    _leftLab.sizeH = self.sizeH;
    
    _rightLab.right = self.sizeW;
    _rightLab.sizeH = self.sizeH;
}

- (void)configGesture {
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [_gestureView addGestureRecognizer:pan];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [_gestureView addGestureRecognizer:tap];
}

- (NSString *)stringFromWithTime:(NSInteger)time {
    if (time >= 3600) {
        NSInteger hour = time / 3600;
        NSInteger min = (time - 3600 * hour) / 60;
        NSInteger second = time % 60;
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hour, min, second];
    } else {
        NSInteger min = time / 60;
        NSInteger second = time % 60;
        return [NSString stringWithFormat:@"%02ld:%02ld",min, second];
    }
}

#pragma mark - UI method

- (void)configUI {
    self.backgroundColor = [UIColor clearColor];
    
    _bgLayer = [self configLayerWithColor:_sliderBgColor];
    _bufferLayer = [self configLayerWithColor:_bufferColor];
    _sliderLayer = [self configLayerWithColor:_sliderColor];
    
    _gestureView = [[UIView alloc] init];
    [self addSubview:_gestureView];
    
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height)];
    UIImage * img = self.centerImg ?: [NSBundle playerBundleWithImgName:@"ZFPlayer_slider"];
    imgV.image = img;
    [self addSubview:imgV];
    _imgV = imgV;
    
    _leftLab = [self configLab];
    _rightLab = [self configLab];
}

- (CALayer *)configLayerWithColor:(UIColor *)color {
    CALayer * layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 100, 4);
    layer.backgroundColor = color.CGColor;
    layer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    [self.layer addSublayer:layer];
    return layer;
}

- (UILabel *)configLab {
    UILabel * lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 0, 100, self.bounds.size.height);
    lab.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    lab.textColor = [UIColor whiteColor];
    [self addSubview:lab];
    return lab;
}

- (void)adjustFrame {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (!_showValueInfo) {
        _bgLayer.frame = self.bounds;
    } else {
        [self configLabInfo];
        _bgLayer.left = _leftLab.right + 10;
        _bgLayer.sizeW = _rightLab.left - _leftLab.right - 20;
    }
    _bgLayer.position = CGPointMake(_bgLayer.position.x, self.sizeH * 0.5);
    _bufferLayer.frame = _bgLayer.frame;
    _sliderLayer.frame = _bgLayer.frame;
    _sliderLayer.sizeW = _sliderValue / _maxValue * _bgLayer.bounds.size.width;
    _bufferLayer.sizeW = _bufferValue / self.maxValue * self.bgLayer.bounds.size.width;
    [CATransaction commit];
    
    _gestureView.frame = CGRectMake(_bgLayer.left, 0, _bgLayer.sizeW, self.sizeH);
    _imgV.center = CGPointMake(_sliderLayer.right, self.bounds.size.height * 0.5);
}

#pragma mark - Get & Set

- (void)setSliderValue:(CGFloat)sliderValue {
    if (_maxValue > 0.5) {
        _sliderValue = sliderValue;
        [self adjustFrame];
    }
}

- (void)setBufferValue:(CGFloat)bufferValue {
    if (_maxValue > 0.5) {
        _bufferValue = bufferValue;
        [self adjustFrame];
    }
}

- (void)setMaxValue:(CGFloat)maxValue {
    _maxValue = maxValue;
    if (maxValue > 0.5) {
        self.userInteractionEnabled = YES;
        [self adjustFrame];
    }
}

- (void)setShowValueInfo:(BOOL)showValueInfo {
    _showValueInfo = showValueInfo;
    _leftLab.hidden = !showValueInfo;
    _rightLab.hidden = !showValueInfo;
    [self adjustFrame];
}

@end
