//
//  BQSliderImgV.m
//  tianyaTest
//
//  Created by baiqiang on 2019/6/28.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BQSliderImgV.h"

#import "NSBundle+BQPlayer.h"
#import "UIView+Custom.h"

@interface BQSliderImgV ()
@property (nonatomic, strong) UIImageView    * imgV;
@property (nonatomic, strong) UIProgressView * progressView;
@property (nonatomic, strong) UILabel        * lab;
@end

@implementation BQSliderImgV

#pragma mark - Life cycle

- (void)dealloc {
    NSLog(@"%@释放了",self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

#pragma mark - Public method

- (void)show {
    [self adjustSubViews];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }];
}

#pragma mark - NetWork method

#pragma mark - Instance method

- (void)adjustSubViews {
    
    if (self.type == SliderImgTypeSpeed) {
        self.progressView.hidden = YES;
        self.lab.hidden = NO;
    } else {
        self.lab.hidden = YES;
        self.progressView.hidden = NO;
    }
    
    self.imgV.frame = CGRectMake((self.width - 30) * 0.5, 10, 30, 30);
    self.progressView.frame = CGRectMake(5, 46, 100, 8);
    self.lab.frame = CGRectMake(0, 40, self.width, 20);
}

- (void)setCurrentValue:(float)value {
    self.progressView.progress = value;
    if (self.type == SliderImgTypeVolume) {
        UIImage * img = [NSBundle playerBundleWithImgName:value == 0 ? @"ZFPlayer_muted":@"ZFPlayer_volume"];
        self.imgV.image = img;
    }
}

- (void)setCurrentContent:(NSString *)content isForWard:(BOOL)isForWard {
    UIImage * img = [NSBundle playerBundleWithImgName:isForWard ? @"ZFPlayer_fast_forward":@"ZFPlayer_fast_backward"];
    self.imgV.image = img;
    self.lab.text = content;
}

#pragma mark - Delegate

#pragma mark - Btn Action

#pragma mark - UI method
- (void)configUI {
    self.frame = CGRectMake(0, 0, 110, 60);
    self.alpha = 0;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.layer.cornerRadius = 4;
    
    UIImageView * imgV = [[UIImageView alloc] init];
    [self addSubview:imgV];
    self.imgV = imgV;
    
    UIProgressView * progressView = [[UIProgressView alloc] init];
    progressView.progressTintColor = [UIColor whiteColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self addSubview:progressView];
    self.progressView = progressView;
    
    UILabel * lab = [[UILabel alloc] init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont fontWithName:@"Helvetica Neue" size:13];
    [self addSubview:lab];
    self.lab = lab;
}

#pragma mark - Get & Set
- (void)setType:(SliderImgType)type {
    _type = type;
    NSString * imgName = @"";
    if (type == SliderImgTypeBrightness) {
        imgName = @"ZFPlayer_brightness";
    }
    UIImage * img = [NSBundle playerBundleWithImgName:imgName];
    self.imgV.image = img;
}


@end
