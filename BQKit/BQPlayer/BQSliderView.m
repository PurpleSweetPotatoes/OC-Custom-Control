//
//  BQSliderView.m
//  tianyaTest
//
//  Created by baiqiang on 2019/6/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BQSliderView.h"

#import "CALayer+Custom.h"
#import "NSBundle+BQPlayer.h"
#import "UILabel+Custom.h"
#import "UIView+Custom.h"

@interface BQSliderView ()
@property (nonatomic, assign) BOOL        isDrag;
@property (nonatomic, strong) CALayer     * bgLayer;
@property (nonatomic, strong) CALayer     * bufferLayer;
@property (nonatomic, strong) CALayer     * sliderLayer;
@property (nonatomic, strong) UIView      * gestureView;
@property (nonatomic, strong) UIImageView * imgV;
@property (nonatomic, strong) UILabel     * leftLab;
@property (nonatomic, strong) UILabel     * rightLab;
@end

@implementation BQSliderView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _canSlide = YES;
        [self configData];
        [self configUI];
        [self configGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgLayer.width = self.width;
    _leftLab.width = self.width;
    _rightLab.width = self.width;
    _gestureView.width = self.width;
    [self adjustFrame];
}

#pragma mark - Public method

- (void)setSliderColor:(UIColor *)color {
    _sliderLayer.backgroundColor = color.CGColor;
}

- (void)setSliderBgColor:(UIColor *)color {
    _bgLayer.backgroundColor = color.CGColor;
}

- (void)setBufferColor:(UIColor *)color {
    _bufferLayer.backgroundColor = color.CGColor;
}

- (void)resetStatus {
    _bufferLayer.width = 0;
    _sliderLayer.width = 0;
    _leftLab.text = @"00:00";
    _rightLab.text = @"00:00";
    _imgV.center = CGPointMake(0, _imgV.center.y);
    self.userInteractionEnabled = NO;
}
#pragma mark - NetWork method

#pragma mark - Btn Action
- (void)gestureAction:(UIGestureRecognizer *)sender {
    if (!self.canSlide) return;
    
    CGPoint point = [sender locationInView:sender.view];
    if (point.x >= 0 && point.x <= _gestureView.width) {
        _value = point.x / _gestureView.width * _maxValue;
        [self adjustFrame];
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.isDrag = YES;
        if ([self.delegate respondsToSelector:@selector(sliderBeginChange:)]) {
            [self.delegate sliderBeginChange:self];
        }
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if ([self.delegate respondsToSelector:@selector(sliderValueChange:)]) {
            [self.delegate sliderValueChange:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(sliderChangeEnd:)]) {
            [self.delegate sliderChangeEnd:self];
        }
        self.isDrag = NO;
    }
}
#pragma mark - Delegate

#pragma mark - Instance method
- (void)configData {
    _value = 0;
    _maxValue = 0;
    self.userInteractionEnabled = NO;
}

- (void)configLabInfo {
    _leftLab.text = [self stringFromWithTime:_value];
    _rightLab.text = [self stringFromWithTime:_maxValue];
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
        return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hour, min, second];
    } else {
        NSInteger min = time / 60;
        NSInteger second = time % 60;
        return [NSString stringWithFormat:@"%02zd:%02zd",min, second];
    }
}

#pragma mark - UI method

- (void)configUI {
    self.backgroundColor = [UIColor clearColor];
    
    _bgLayer = [self configLayerWithColor:[UIColor colorWithWhite:1 alpha:0.5]];
    _bufferLayer = [self configLayerWithColor:[UIColor colorWithWhite:1 alpha:0.7]];
    _bufferLayer.width = 0;
    _sliderLayer = [self configLayerWithColor:[UIColor clearColor]];
    _sliderLayer.width = 0;
    
    _gestureView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_gestureView];
    
    UIImageView * imgV = [[UIImageView alloc] initWithFrame:CGRectMake(-6, 10, 12, 12)];
    UIImage * img = self.centerImg ?: [NSBundle playerBundleWithImgName:@"ZFPlayer_slider"];
    imgV.image = img;
    [self addSubview:imgV];
    _imgV = imgV;
    
    _leftLab = [self configLab];
    _rightLab = [self configLab];
    _rightLab.textAlignment = NSTextAlignmentRight;
}

- (CALayer *)configLayerWithColor:(UIColor *)color {
    CALayer * layer = [CALayer layer];
    layer.frame = CGRectMake(0, 14, self.bounds.size.width, 4);
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
    return layer;
}

- (UILabel *)configLab {
    UILabel * lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(0, 20, self.bounds.size.width, 20);
    lab.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    lab.textColor = [UIColor whiteColor];
    lab.text = @"00:00";
    [self addSubview:lab];
    return lab;
}

- (void)adjustFrame {
    
    if (_maxValue < 1) {
        return;
    }
    
    self.userInteractionEnabled = YES;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self configLabInfo];
    _sliderLayer.width = _value / (CGFloat)_maxValue * _bgLayer.bounds.size.width;
    _bufferLayer.width = _bufferValue / (CGFloat)_maxValue * _bgLayer.bounds.size.width;
    [CATransaction commit];
    _imgV.center = CGPointMake(_sliderLayer.right, _imgV.center.y);
}

#pragma mark - Get & Set

- (void)setValue:(NSInteger)value {
    if (_value != value && !self.isDrag) {
        _value = value;
        [self adjustFrame];
    }
}

- (void)setBufferValue:(NSInteger)bufferValue {
    if (_bufferValue != bufferValue) {
        _bufferValue = bufferValue;
        [self adjustFrame];
    }
}

- (void)setMaxValue:(NSInteger)maxValue {
    if (_maxValue != maxValue) {
        _maxValue = maxValue;
        [self adjustFrame];
    }
}

@end
