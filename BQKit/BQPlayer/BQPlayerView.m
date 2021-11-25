//
//  BQPlayerView.m
//  tianyaTest
//
//  Created by baiqiang on 2019/6/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BQPlayerView.h"

#import "BQPlayerCtrlView.h"
#import "BQSliderImgV.h"
#import "UIView+Custom.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

static NSString * const kNotifiPlayStatus = @"status";
static NSString * const kNotifiBufferLoad = @"loadedTimeRanges";
static NSString * const kNotifiNoBuffer   = @"playbackBufferEmpty";
static NSString * const kNotifiKeepUp     = @"playbackLikelyToKeepUp";

@interface BQPlayerView ()
<
BQPlayerCtrlViewDelegate
>
@property (nonatomic, strong) UIImageView      * placeHoderImgV;
@property (nonatomic, strong) AVPlayerLayer    * disPlayer;
@property (nonatomic, strong) AVPlayer         * player;
@property (nonatomic, strong) BQPlayerCtrlView * ctrlView;
@property (nonatomic, strong) BQSliderImgV     * imgSliderView;
@property (nonatomic, strong) UIView           * activiView;
@property (nonatomic, strong) CADisplayLink    * timeLink;
@property (nonatomic, strong) UISlider         * volumeViewSlider;
@property (nonatomic, strong) MPVolumeView     * volumeView;
@property (nonatomic, strong) UILabel          * tipLab;
@property (nonatomic, weak  ) UIView           * supView;
@property (nonatomic, assign) CGRect           orginFrame;
@end

@implementation BQPlayerView

#pragma mark - Life cycle

- (void)dealloc {
    NSLog(@"%@释放了",self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        [self configGesture];
        self.canSlide = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.disPlayer.frame = self.bounds;
    self.ctrlView.frame = self.bounds;
    self.tipLab.frame = self.bounds;
    self.placeHoderImgV.frame = self.bounds;
    
    self.activiView.center = self.thisCenter;
    self.imgSliderView.center = self.activiView.center;
    
}

- (void)removeFromSuperview {
    NSLog(@"从父视图移除");
    [self clear];
    [super removeFromSuperview];
}

#pragma mark - Public method

- (void)setTopTitle:(NSString *)title {
    self.ctrlView.disTitle = title;
}

- (void)play {
    [self.player play];
    self.timeLink.paused = NO;
    self.ctrlView.centerBtn.selected = YES;
}

- (void)pause {
    [self.player pause];
    self.ctrlView.centerBtn.selected = NO;
}

- (BOOL)isFullScreen {
    return self.ctrlView.fullBtn.selected;
}

- (void)clear {
    [self removeNofitCation];
    [self.timeLink invalidate];
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.disPlayer removeFromSuperlayer];
    [self.volumeView removeFromSuperview];
}

#pragma mark - NetWork method

#pragma mark - Btn Action

- (void)tapGestureAction:(UITapGestureRecognizer *)sender {
    if (!self.tipLab.hidden) {
        if (self.assetUrl) {
            self.assetUrl = self.assetUrl;
        } else if (self.asset) {
            self.asset = self.asset;
        }
        self.tipLab.hidden = YES;
        [self showActiviView];
        return;
    }
    
    if (!self.activiView.hidden) return;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.ctrlView disPlayStatusChange];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)sender {
    if (!self.tipLab.hidden) return;
    
    static CGPoint _startPoint;
    static CGFloat _startValue;
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.ctrlView hide];
        CGPoint translation = [sender translationInView:sender.view];
        BOOL isUpDown = fabs(translation.x) < fabs(translation.y);
        _startPoint = [sender locationInView:sender.view];
        BOOL isLeft = _startPoint.x <= sender.view.width * 0.5;
        BOOL showImgSlide = YES;
        if (isUpDown && isLeft) {
            self.imgSliderView.type = SliderImgTypeBrightness;
            _startValue = [UIScreen mainScreen].brightness;
            [self.imgSliderView setCurrentValue:_startValue];
        } else if (isUpDown) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.volumeView];
            self.imgSliderView.type = SliderImgTypeVolume;
            _startValue = self.volumeViewSlider.value;
            if (_startValue == 0) {
                _startValue = [[AVAudioSession sharedInstance] outputVolume];
            }
            [self.imgSliderView setCurrentValue:_startValue];
        } else if (!isUpDown) {
            _startValue = self.ctrlView.sliederView.value;
            self.imgSliderView.type = SliderImgTypeSpeed;
            showImgSlide = self.canSlide && self.ctrlView.sliederView.maxValue > 1;
        }
        if (showImgSlide) {
            [self.imgSliderView show];
        }
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint = [sender locationInView:sender.view];
        
        if (self.imgSliderView.type == SliderImgTypeSpeed && self.canSlide && self.ctrlView.sliederView.maxValue > 1) {
            float value = (currentPoint.x - _startPoint.x) + _startValue;
            
            if (value <= 0) {
                value = 0;
                _startPoint = currentPoint;
                _startValue = value;
            } else if (value >= self.ctrlView.sliederView.maxValue) {
                value = self.ctrlView.sliederView.maxValue;
                _startPoint = currentPoint;
                _startValue = value;
            }
            
            NSString * current = [self timeStrFormatWithTime:(NSInteger)value];
            NSString * maxValue = [self timeStrFormatWithTime:(NSInteger)self.ctrlView.sliederView.maxValue];
            NSString * content = [NSString stringWithFormat:@"%@/%@", current, maxValue];
            [self.imgSliderView setCurrentContent:content isForWard:value >= _startValue];
            self.imgSliderView.timeValue = value;
            
        } else {
            float value = (_startPoint.y - currentPoint.y) / self.height + _startValue;
            if (value >= 0 && value <= 1) {
                if (self.imgSliderView.type == SliderImgTypeVolume) {
                    self.volumeViewSlider.value = value;
                } else {
                    [UIScreen mainScreen].brightness = value;
                }
                [self.imgSliderView setCurrentValue:value];
            }
        }
    } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed) {
        if (self.imgSliderView.type == SliderImgTypeVolume) {
            [self.volumeView removeFromSuperview];
        } else if (self.imgSliderView.type == SliderImgTypeSpeed) {
            [self pause];
            [self.player seekToTime:CMTimeMake(self.imgSliderView.timeValue, 1) completionHandler:^(BOOL finished) {
                [self play];
            }];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.imgSliderView hide];
            _startValue = 0;
            _startPoint = CGPointZero;
        });
    }
}
- (NSString *)timeStrFormatWithTime:(NSInteger)time {
    NSInteger min = time / 60;
    NSInteger second = time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min, second];
}

#pragma mark - Delegate

- (void)ctrlViewSliderBeginChange:(BQSliderView *)slider {
    self.timeLink.paused = YES;
}

- (void)ctrlViewSliderEndChange:(BQSliderView *)slider {
    [self pause];
    [self.player seekToTime:CMTimeMake(slider.value, 1) completionHandler:^(BOOL finished) {
        [self play];
    }];
}

- (void)ctrlViewcentBtnAction:(UIButton *)sender {
    if (sender.selected) {
        [self play];
    } else {
        [self pause];
    }
}

- (void)ctrlViewFullBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    [UIApplication sharedApplication].statusBarOrientation = sender.selected ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    if (sender.selected) {
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

- (void)timeLinkUpdate:(CADisplayLink *)link {
    if (self.player.currentItem.duration.timescale > 0) {
        self.ctrlView.sliederView.maxValue = CMTimeGetSeconds(self.player.currentItem.duration);
        self.ctrlView.sliederView.value = CMTimeGetSeconds(self.player.currentTime);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kNotifiBufferLoad]) {
        // 处理缓冲进度条
        NSArray * loadedTimeRanges = [self.player.currentItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
        NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
        self.ctrlView.sliederView.bufferValue = result;
    } else if ([keyPath isEqualToString:kNotifiPlayStatus]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] integerValue];
        self.tipLab.hidden = NO;
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"准备完成，可以播放");
            if (self.ctrlView.sliederView.maxValue < 1) {
                self.ctrlView.sliederView.maxValue = CMTimeGetSeconds(self.player.currentItem.duration);
            }
            self.tipLab.hidden = YES;
        } else if (status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed == %@", self.player.currentItem.error);
        }
        [self hideActiviView];
    } else if ([keyPath isEqualToString:kNotifiNoBuffer]) {
        NSLog(@"没有缓存空间可用");
        if (self.ctrlView.centerBtn.selected) {
            [self showActiviView];
        }
    } else if ([keyPath isEqualToString:kNotifiKeepUp]) {
        [self hideActiviView];
    }
    
}

#pragma mark - UI method
- (void)configUI {
    self.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.placeHoderImgV];
    
    self.disPlayer = [[AVPlayerLayer alloc] init];
    self.disPlayer.frame = self.bounds;
    [self.layer addSublayer:self.disPlayer];
    
    self.ctrlView = [[BQPlayerCtrlView alloc] initWithFrame:self.bounds];
    self.ctrlView.delegate = self;
    self.ctrlView.alpha = 0;
    [self addSubview:self.ctrlView];
    
    [self configureVolume];
    
    self.imgSliderView = [[BQSliderImgV alloc] init];
    self.imgSliderView.hidden = NO;
    [self addSubview:self.imgSliderView];
    
    [self addSubview:self.activiView];
    [self addSubview:self.tipLab];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDeviceOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)configGesture {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self addGestureRecognizer:pan];
}

#pragma mark - Instance method

- (void)configAVPlayerWithItem:(AVPlayerItem *)item {
    
    [self removeNofitCation];
    
    if (self.player == nil) {
        self.player = [AVPlayer playerWithPlayerItem:item];
        self.disPlayer.player = self.player;
    } else {
        [self.player pause];
        [self.player replaceCurrentItemWithPlayerItem:item];
    }
    
    [self addNotifiCation];
    [self.ctrlView resetStatus];
}

- (void)addNotifiCation {
    if (self.player.currentItem) {
        [self.player.currentItem addObserver:self forKeyPath:kNotifiPlayStatus options:NSKeyValueObservingOptionNew context:nil];
        [self.player.currentItem addObserver:self forKeyPath:kNotifiBufferLoad options:NSKeyValueObservingOptionNew context:nil];
        [self.player.currentItem addObserver:self forKeyPath:kNotifiNoBuffer options:NSKeyValueObservingOptionNew context:nil];
        [self.player.currentItem addObserver:self forKeyPath:kNotifiKeepUp options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)removeNofitCation {
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:kNotifiPlayStatus];
        [self.player.currentItem removeObserver:self forKeyPath:kNotifiBufferLoad];
        [self.player.currentItem removeObserver:self forKeyPath:kNotifiNoBuffer];
        [self.player.currentItem removeObserver:self forKeyPath:kNotifiKeepUp];
        [self.player.currentItem cancelPendingSeeks];
    }
}

/// Get system volume
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.frame = CGRectMake(-1000, -1000, 100, 100);
    self.volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            self.volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    self.volumeView = volumeView;
}

- (void)handleDeviceOrientationChange:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight) {
        NSLog(@"横屏旋转");
    } else {
        NSLog(@"竖屏");
    }
}

- (void)showActiviView {
    self.activiView.hidden = NO;
}

- (void)hideActiviView {
    self.activiView.hidden = YES;
}
#pragma mark - Get & Set

- (void)setAssetUrl:(NSString *)assetUrl {
    _assetUrl = [assetUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_assetUrl]];
    
    [self configAVPlayerWithItem:item];
}

- (void)setAsset:(AVAsset *)asset {
    _asset = asset;
    AVPlayerItem * item = [AVPlayerItem playerItemWithAsset:asset];
    [self configAVPlayerWithItem:item];
}

- (void)setCanSlide:(BOOL)canSlide {
    _canSlide = canSlide;
    self.ctrlView.sliederView.canSlide = canSlide;
}

- (CADisplayLink *)timeLink {
    if (_timeLink == nil) {
        CADisplayLink * link = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeLinkUpdate:)];
        link.frameInterval = 30;
        link.paused = YES;
        [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _timeLink = link;
    }
    return _timeLink;
}

- (UIView *)activiView {
    if (_activiView == nil) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        view.userInteractionEnabled = NO;
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = CGRectMake(8, 8, 40, 40);
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeStart = 0.1;
        shapeLayer.strokeEnd = 1;
        shapeLayer.lineCap = @"round";
        
        CGFloat radius = 20;
        CGPoint center = CGPointMake(radius, radius);
        CGFloat startAngle = (CGFloat)(0);
        CGFloat endAngle = (CGFloat)(2*M_PI);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        shapeLayer.path = path.CGPath;
        
        CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnim.toValue = [NSNumber numberWithFloat:2 * M_PI];
        rotationAnim.duration = 1.0;
        rotationAnim.repeatCount = CGFLOAT_MAX;
        rotationAnim.removedOnCompletion = NO;
        [shapeLayer addAnimation:rotationAnim forKey:@"rotation"];
        
        [view.layer addSublayer:shapeLayer];
        view.hidden = YES;
        _activiView = view;
    }
    return _activiView;
}

- (UILabel *)tipLab {
    if (_tipLab == nil) {
        UILabel * lab = [[UILabel alloc] initWithFrame:self.bounds];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:14];
        lab.hidden = YES;
        lab.text = @"资源无法加载，请点击重试";
        _tipLab = lab;
    }
    return _tipLab;
}

- (UIImageView *)placeHoderImgV {
    if (_placeHoderImgV == nil) {
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:self.bounds];
        imgV.contentMode = UIViewContentModeScaleToFill;
        _placeHoderImgV = imgV;
    }
    return _placeHoderImgV;
}

- (void)setDisPlayImg:(UIImage *)disPlayImg {
    _disPlayImg = disPlayImg;
    self.placeHoderImgV.image = disPlayImg;
}
@end
