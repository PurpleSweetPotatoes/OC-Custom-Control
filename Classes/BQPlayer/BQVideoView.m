// *******************************************
//  File Name:      BQVideoView.m       
//  Author:         MrBai
//  Created Date:   2021/12/17 3:37 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQVideoView.h"

#import "BQPlayerCtrlView.h"
#import "BQPlayerView.h"
#import "BQSliderImgV.h"

@interface BQVideoView ()
<
BQPlayerDelegate
,BQPlayerCtrlViewDelegate
>
@property (nonatomic, strong) BQPlayerView     * player;
@property (nonatomic, strong) BQPlayerCtrlView * ctrlView;
@property (nonatomic, strong) BQSliderImgV     * imgSliderView;

@property (nonatomic, assign) BOOL             seekPlay;///< 拖拽后是否播放
@property (nonatomic, weak  ) UIView           * supView;///< 全屏前父视图
@property (nonatomic, assign) CGRect           orginFrame;///< 全屏前 视图位置
@end

@implementation BQVideoView


#pragma mark - *** Public method

+ (instancetype)playerWithFrame:(CGRect)frame url:(NSString *)url {
    BQVideoView * videoV = [[self alloc] initWithFrame:frame];
    videoV.videoUrl = url;
    return videoV;
}

- (void)play {
    [self.player play];
    self.ctrlView.centerBtn.selected = YES;
}

- (void)pause {
    [self.player pause];
    self.ctrlView.centerBtn.selected = NO;
}

- (void)replay {
    [self.player replay];
}

- (void)stop {
    [self.player stop];
}

- (void)seekToTime:(NSTimeInterval)time {
    [self.player seekToTime:time];
}
#pragma mark - *** Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self configGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.player.frame = self.bounds;
    self.ctrlView.frame = self.bounds;
    self.imgSliderView.frame = self.bounds;
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
//    if (!self.tipLab.hidden) {
//        if (self.assetUrl) {
//            self.assetUrl = self.assetUrl;
//        } else if (self.asset) {
//            self.asset = self.asset;
//        }
//        self.tipLab.hidden = YES;
//        [self showActiviView];
//        return;
//    }
    
//    if (!self.activiView.hidden) return;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.ctrlView disPlayStatusChange];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)sender {
    NSLog(@"拖拽手势");
}

#pragma mark - *** Delegate

#pragma mark - *** player delegate
- (void)playerStatusChange:(BQPlayerStatus)status duration:(CGFloat)duration {
    if (status == BQPlayerStatusReady) {
        self.ctrlView.sliederView.maxValue = duration;
    } else if (status == BQPlayerStatusEnd) {
        if ([self.delegate respondsToSelector:@selector(videoPlayEnd)]) {
            [self.delegate videoPlayEnd];
        }
    }
}

- (void)playerBufferChange:(CGFloat)value {
    self.ctrlView.sliederView.bufferValue = value;
}

- (void)playerTimeChange:(CGFloat)currentTime {
    self.ctrlView.sliederView.value = currentTime;
    if ([self.delegate respondsToSelector:@selector(videoTimeChange:)]) {
        [self.delegate videoTimeChange:currentTime];
    }
}

#pragma mark - *** ctrlView delegate

- (void)ctrlViewSliderBeginChange:(BQSliderView *)slider {
    self.seekPlay = self.status == BQPlayerStatusPlaying;
    [self pause];
}

- (void)ctrlViewSliderDidChange:(BQSliderView *)slider {
    NSLog(@"正在改变");
}

- (void)ctrlViewSliderEndChange:(BQSliderView *)slider {
    [self.player seekToTime:slider.value];
    if (self.seekPlay) {
        [self play];
    }
}

- (void)ctrlViewCentBtnAction:(UIButton *)sender {
    if (sender.selected) {
        if ([self.delegate respondsToSelector:@selector(videoWillPlay)]) {
            if ([self.delegate videoWillPlay]) {
                [self play];
            }
        } else {
            [self play];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(videoWillPause)]) {
            if ([self.delegate videoWillPause]) {
                [self pause];
            }
        } else {
            [self pause];
        }
    }
}
- (void)ctrlViewFullBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _full = sender.selected;
    [self fullAdjustFrame];
}

#pragma mark - *** Instance method

- (void)configGesture {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tap];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self addGestureRecognizer:pan];
}

- (CGAffineTransform)getTransformRotationAngle:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

#pragma mark - *** UI method

- (void)configUI {
    [self addSubview:self.player];
    [self addSubview:self.ctrlView];
}

- (void)fullAdjustFrame {
    [UIApplication sharedApplication].statusBarOrientation = _full ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    if (_full) {
        self.orginFrame = self.frame;
        self.supView = self.superview;
        self.frame = [self.superview convertRect:self.frame toView:keyWindow];
        [keyWindow addSubview:self];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = [self getTransformRotationAngle:UIInterfaceOrientationLandscapeRight];
            self.frame = keyWindow.frame;
        } completion:^(BOOL finished) {
            [self layoutSubviews];
        }];
    } else {
        self.frame = [self.superview convertRect:self.frame toView:self.supView];
        [self.supView addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.frame = self.orginFrame;
        } completion:^(BOOL finished) {
            [self layoutSubviews];
        }];
    }
}

#pragma mark - *** Set

- (void)setVideoUrl:(NSString *)videoUrl {
    _videoUrl = [videoUrl copy];
    self.player.videoUrl = videoUrl;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.ctrlView.disTitle = title;
}

- (void)setFull:(BOOL)full {
    _full = full;
    self.ctrlView.fullBtn.selected = full;
    [self fullAdjustFrame];
}
#pragma mark - *** Get
    
- (BQPlayerStatus)status {
    return self.player.status;
}


- (BQPlayerView *)player {
    if (_player == nil) {
        BQPlayerView * player = [[BQPlayerView alloc] initWithFrame:self.bounds];
        player.delegate = self;
        _player = player;
    }
    return _player;
}

- (BQPlayerCtrlView *)ctrlView {
    if (_ctrlView == nil) {
        BQPlayerCtrlView * ctrlView = [[BQPlayerCtrlView alloc] initWithFrame:self.bounds];
        ctrlView.delegate = self;
        ctrlView.alpha = 0;
        _ctrlView = ctrlView;
    }
    return _ctrlView;
}

- (BQSliderImgV *)imgSliderView {
    if (_imgSliderView == nil) {
        BQSliderImgV * imgSliderView = [[BQSliderImgV alloc] init];
        _imgSliderView = imgSliderView;
    }
    return _imgSliderView;
}

@end
