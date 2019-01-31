//
//  BQVideoPlayerView.m
//  Video
//
//  Created by MrBai on 2018/1/15.
//  Copyright © 2018年 gongwenkai. All rights reserved.
//

#import "BQVideoPlayerView.h"

@interface BQVideoPlayerView()
@property (nonatomic,copy) NSString *path;                  //播放地址 自动判断文件路径和网址路径
@property (nonatomic,strong) AVPlayer *player;              //播放类
@property (nonatomic,strong) AVPlayerLayer *playerlayer;    //显示区域
@property (nonatomic,strong) UIButton *playBtn;             //播放暂停
@property (nonatomic,strong) UIProgressView *progress;      //进度
@property (nonatomic,strong) UILabel *currentTimeLab;       //当前时间
@property (nonatomic,strong) UILabel *durationLab;          //总时间
@property (nonatomic,strong) UIView *toolView;              //工具栏view
@end

@implementation BQVideoPlayerView

//KVO检测状态
static  NSString*  const kItemStatus = @"status";
static  NSString*  const kItemLoadedTimeRanges = @"loadedTimeRanges";
static  CGFloat    const kLrMargin = 10;  //左右间隔

#pragma mark - 初始化
//初始化
- (instancetype)initWithFrame:(CGRect)frame andPath:(NSString*)path {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.path = path;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self.layer addSublayer:self.playerlayer];
    [self addSubview:self.toolView];
    [self addSubview:self.playBtn];
}
#pragma mark - 懒加载
//加载显示层
- (AVPlayerLayer*)playerlayer {
    if (!_playerlayer) {
        _playerlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerlayer.frame = self.bounds;
        _playerlayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return _playerlayer;
}

//加载播放类
- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithURL:[self getUrlPath:self.path]];
        //kvo注册
        [self addObservers];
    }
    return _player;
}

//播放暂停
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _playBtn.backgroundColor  =[UIColor greenColor];
        _playBtn.selected = NO;
        _playBtn.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        _playBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [_playBtn setTitle:@"暂停" forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

//进度
- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] init];
        _progress.progress = 0;
    }
    _progress.frame = CGRectMake(45, 11, self.bounds.size.width-90, 5);
    return _progress;
}

- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 20, self.bounds.size.width, 20)];
        _toolView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_toolView addSubview:self.currentTimeLab];
        [_toolView addSubview:self.progress];
        [_toolView addSubview:self.durationLab];
    }
    return _toolView;
}

//当前时长
- (UILabel *)currentTimeLab {
    if (!_currentTimeLab) {
        _currentTimeLab = [[UILabel alloc] initWithFrame:CGRectMake( kLrMargin, 0, 30, self.toolView.bounds.size.height)];
        _currentTimeLab.text = @"00:00";
        _currentTimeLab.textColor = [UIColor whiteColor];
        _currentTimeLab.backgroundColor = [UIColor clearColor];
        _currentTimeLab.adjustsFontSizeToFitWidth = YES;
    }
    return _currentTimeLab;
}

//总时长
- (UILabel *)durationLab {
    if (!_durationLab) {
        _durationLab = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 40, 0, 30, self.toolView.bounds.size.height)];
        _durationLab.text = @"00:00";
        _durationLab.textColor = [UIColor whiteColor];
        _durationLab.backgroundColor = [UIColor clearColor];
        _durationLab.adjustsFontSizeToFitWidth = YES;
    }
    return _durationLab;
}

#pragma mark - 添加KVO
//注册kvo
- (void)addObservers{
    [self.player.currentItem addObserver:self forKeyPath:kItemStatus options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:kItemLoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
}

//移除kvo
- (void)dealloc {
    [self.player.currentItem removeObserver:self forKeyPath:kItemStatus];
    [self.player.currentItem removeObserver:self forKeyPath:kItemLoadedTimeRanges];
}

//kvo回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kItemStatus]) {
        AVPlayerItem *item = object;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            //准备播放
            [self readyToplayWithItem:item];
            
        }else if (item.status == AVPlayerItemStatusUnknown) {
            //播放失败
            UIAlertController *alertConteroller = [UIAlertController alertControllerWithTitle:@"错误" message:@"AVPlayerItemStatusUnknown\n播放失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:UIAlertActionStyleDefault];
            [alertConteroller addAction:action];
            
        }else if (item.status == AVPlayerItemStatusFailed) {
            //播放失败
            UIAlertController *alertConteroller = [UIAlertController alertControllerWithTitle:@"错误" message:@"AVPlayerItemStatusFailed\n播放失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:UIAlertActionStyleDefault];
            [alertConteroller addAction:action];
        }
    } else if ([keyPath isEqualToString:kItemLoadedTimeRanges]) {
        AVPlayerItem *item = object;
        [self getLoadedTimeRanges:item];
    }
}

#pragma mark - 基础功能
//播放 暂停
- (void)play {
    if (self.playBtn.selected) {
        self.playBtn.selected = NO;
        
        [self.player pause];
    } else {
        self.playBtn.selected = YES;
        [self.player play];
        [UIView animateWithDuration:0.25 animations:^{
            self.playBtn.hidden = YES;
        }];
        [self timerStar];
    }
}

#pragma mark - 具体操作实现
//准备播放
- (void)readyToplayWithItem:(AVPlayerItem*)item {
    self.playBtn.enabled = YES;
    long long durationSecond = item.duration.value / item.duration.timescale;
    self.durationLab.text = [NSString stringWithFormat:@"%@",[self getFormatDate:durationSecond]];
}

//获得缓存
- (void)getLoadedTimeRanges:(AVPlayerItem*)item {
    NSValue *value = [item.loadedTimeRanges lastObject];
    CMTimeRange range = [value CMTimeRangeValue];
    long long cacheSecond = range.start.value/range.start.timescale + range.duration.value/range.duration.timescale;
    long long currentSecond = item.currentTime.value / item.currentTime.timescale;
    self.progress.progress = (currentSecond + cacheSecond) * 0.1;
    
}

//格式化时间
- (NSString*)getFormatDate:(NSTimeInterval)time {
    int seconds = (int)time % 60;
    int minutes = (int)(time / 60) % 60;
    //    int hours = (int)time / 3600;
    return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}

//格式化url路径
- (NSURL*)getUrlPath:(NSString*)path {
    NSURL *url;
    if ([self.path containsString:@"http"]) {
        url = [NSURL URLWithString:self.path];
    } else {
        url = [NSURL fileURLWithPath:self.path];
    }
    return url;
}

//开启定时
- (void)timerStar {
    //定时回调
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        long long current = weakSelf.player.currentItem.currentTime.value / weakSelf.player.currentItem.currentTime.timescale;
        NSString *currentFormat = [weakSelf getFormatDate:current];
        weakSelf.currentTimeLab.text = [NSString stringWithFormat:@"%@",currentFormat];
    }];
}

//触摸关闭全屏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.playBtn.hidden = !self.playBtn.isHidden;
    if (self.player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
        self.playBtn.hidden = NO;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGRectContainsPoint(self.playerlayer.frame, point);
}

@end
