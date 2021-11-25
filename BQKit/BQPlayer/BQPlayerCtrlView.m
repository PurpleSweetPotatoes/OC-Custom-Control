//
//  BQPlayerCtrlView.m
//  tianyaTest
//
//  Created by baiqiang on 2019/6/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BQPlayerCtrlView.h"

#import "NSBundle+BQPlayer.h"
#import "UIView+Custom.h"

@interface BQPlayerCtrlView ()
<
BQSliderViewDelegate
>
@property (nonatomic, strong) UIView  * topToolView;
@property (nonatomic, strong) UIView  * bottomToolView;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, assign) BOOL    isDisplay;


@end

@implementation BQPlayerCtrlView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self resetStatus];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _topToolView.frame = CGRectMake(0, 0, self.width, 40);
    _bottomToolView.frame = CGRectMake(0, self.height - 40, self.width, 40);
    _sliederView.frame = CGRectMake(10, 10, self.width - 60, 20);
    _fullBtn.frame = CGRectMake(_sliederView.right + 5, 0, 40, 40);
    _titleLab.frame = _topToolView.bounds;
    _centerBtn.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

#pragma mark - Public method


- (void)disPlayStatusChange {
    if (!self.isDisplay) {
        [self show];
    } else {
        [self hide];
    }
}

- (void)resetStatus {
    self.sliederView.maxValue = 0.6;
    self.sliederView.bufferValue = 0;
    self.sliederView.value = 0;
    self.centerBtn.selected = NO;
}

#pragma mark - NetWork method

#pragma mark - Btn Action

- (void)fullBtnAction:(UIButton *)sender {
    NSLog(@"全屏");
    if ([self.delegate respondsToSelector:@selector(ctrlViewFullBtnAction:)]) {
        [self.delegate ctrlViewFullBtnAction:sender];
    }
    [self hideAtAfter];
}

- (void)centerBtnAction:(UIButton *)sender {
    NSLog(@"播放和暂停");
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(ctrlViewcentBtnAction:)]) {
        [self.delegate ctrlViewcentBtnAction:sender];
    }
    [self hideAtAfter];
}

#pragma mark - Instance method

- (void)show {
    self.isDisplay = YES;
    [self hideAtAfter];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    self.isDisplay = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    }];
}

- (void)hideAtAfter {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hide) withObject:nil afterDelay:3];
}

#pragma mark - Delegate
- (void)sliderBeignChange:(BQSliderView *)slider {
    if ([self.delegate respondsToSelector:@selector(ctrlViewSliderBeginChange:)]) {
        [self.delegate ctrlViewSliderBeginChange:slider];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)sliderEndChange:(BQSliderView *)slider {
    if ([self.delegate respondsToSelector:@selector(ctrlViewSliderEndChange:)]) {
        [self.delegate ctrlViewSliderEndChange:slider];
    }
    self.centerBtn.selected = YES;
    [self hideAtAfter];
}
#pragma mark - UI method
- (void)configUI {
    
    [self.topToolView addSubview:self.titleLab];
    [self addSubview:self.topToolView];
    
    [self addSubview:self.centerBtn];
    
    BQSliderView * sliderView = [[BQSliderView alloc] initWithFrame:CGRectMake(10, self.height - 20, self.width - 50, 12)];
    sliderView.delegate = self;
    sliderView.value = 0;
    [self.bottomToolView addSubview:sliderView];
    self.sliederView = sliderView;
    
    UIButton * fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fullBtn.frame = CGRectMake(sliderView.right + 10, 0, 40, 40);
    [fullBtn setImage:[NSBundle playerBundleWithImgName:@"ZFPlayer_fullscreen"] forState:UIControlStateNormal];
    [fullBtn setImage:[NSBundle playerBundleWithImgName:@"ZFPlayer_shrinkscreen"] forState:UIControlStateSelected];
    [fullBtn addTarget:self action:@selector(fullBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    fullBtn.center = CGPointMake(fullBtn.center.x, sliderView.center.y);
    self.fullBtn = fullBtn;
    [self.bottomToolView addSubview:fullBtn];
    [self addSubview:self.bottomToolView];
    
}

#pragma mark - Get & Set

- (UIView *)topToolView {
    if (_topToolView == nil) {
        UIView * topView = [[UIView alloc] init];
        UIImage * image = [NSBundle playerBundleWithImgName:@"ZFPlayer_top_shadow"];
        topView.layer.contents = (id)image.CGImage;
        _topToolView = topView;
    }
    return _topToolView;
}

- (UIButton *)centerBtn {
    if (_centerBtn == nil) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 44, 44);
        [btn setImage:[NSBundle playerBundleWithImgName:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [btn setImage:[NSBundle playerBundleWithImgName:@"new_allPause_44x44_"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(centerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _centerBtn = btn;
    }
    return _centerBtn;
}

- (UIView *)bottomToolView {
    if (_bottomToolView == nil) {
        UIView * bottomView = [[UIView alloc] init];
        UIImage * image = [NSBundle playerBundleWithImgName:@"ZFPlayer_bottom_shadow"];
        bottomView.layer.contents = (id)image.CGImage;
        _bottomToolView = bottomView;
    }
    return _bottomToolView;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        UILabel * lab = [[UILabel alloc] init];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor whiteColor];
        _titleLab = lab;
    }
    return _titleLab;
}

- (void)setDisTitle:(NSString *)disTitle {
    self.titleLab.text = disTitle;
}

@end
