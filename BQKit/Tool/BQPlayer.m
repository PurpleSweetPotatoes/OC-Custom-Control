// *******************************************
//  File Name:      BQPlayer.m       
//  Author:         MrBai
//  Created Date:   2021/9/26 4:28 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQPlayer.h"

static NSString * const kControlRate     = @"rate";
static NSString * const kItemPlayStatus  = @"status";
static NSString * const kItemBufferLoad  = @"loadedTimeRanges";
static NSString * const kItemNoBuffer    = @"playbackBufferEmpty";
static NSString * const kItemBufferReady = @"playbackLikelyToKeepUp";

@interface BQPlayer ()
@property (nonatomic, strong) NSMutableArray * kvoList;
@property (nonatomic, strong) id timeObserve;
@property (nonatomic, strong) AVPlayer * player;
@end

@implementation BQPlayer

#pragma mark - *** life
- (void)dealloc {
    [self cleanBaseObserver];
}

+ (instancetype)playerWithURL:(NSURL *)URL {
    return [[self alloc] initWithURL:URL];
}

- (instancetype)initWithURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        _status = BQPlayerStatusNone;
        self.player = [AVPlayer playerWithURL:URL];
        [self.player addObserver:self forKeyPath:kControlRate options:0 context:nil];
        self.hookTime = CMTimeMake(1, 1);
        [self addObserverInfo];
    }
    return self;
}

- (void)reSetURL:(NSURL *)URL {
    [self cleanItemObserver];
    AVPlayerItem * item = [AVPlayerItem playerItemWithURL:URL];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self addObserverInfo];
}

- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    [self.player pause];
    [self.player seekToTime:CMTimeMake(0, 1)];
    self.status = BQPlayerStatusStop;
}

- (void)replay {
    if (self.player.currentItem && self.status < BQPlayerStatusFail) {
        [self.player seekToTime:CMTimeMake(0, 1)];
        [self play];
    }
}

- (void)seekToTime:(NSTimeInterval)time {
    [self.player seekToTime:CMTimeMake(time, 1)];
}

#pragma mark - *** private method

- (void)addObserverInfo {
    if (self.player.currentItem) {
        [self.player.currentItem addObserver:self forKeyPath:kItemPlayStatus options:0 context:nil];
        [self.player.currentItem addObserver:self forKeyPath:kItemBufferLoad options:0 context:nil];
        [self.player.currentItem addObserver:self forKeyPath:kItemNoBuffer options:0 context:nil];
        [self.player.currentItem addObserver:self forKeyPath:kItemBufferReady options:0 context:nil];
    }
}

- (void)cleanItemObserver {
    [self.player.currentItem removeObserver:self forKeyPath:kItemPlayStatus];
    [self.player.currentItem removeObserver:self forKeyPath:kItemBufferLoad];
    [self.player.currentItem removeObserver:self forKeyPath:kItemNoBuffer];
    [self.player.currentItem removeObserver:self forKeyPath:kItemBufferReady];
}

- (void)cleanBaseObserver {
    if (_timeObserve) {
        [self.player removeTimeObserver:_timeObserve];
    }
    [self.player removeObserver:self forKeyPath:kControlRate];
}

#pragma mark - *** observer handler

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([kControlRate isEqualToString:keyPath]) {
        if (self.player.rate > 0) {
            self.status = BQPlayerStatusPlaying;
        } else if (self.status != BQPlayerStatusStop) {
            self.status = BQPlayerStatusPaused;
        }
    } else if ([kItemPlayStatus isEqualToString:keyPath]) {
        [self itemStatusChange];
    } else if ([kItemBufferLoad isEqualToString:keyPath]) {
        [self bufferChange];
    } else if ([kItemNoBuffer isEqualToString:keyPath]) {
        self.status = BQPlayerStatusWait;
    } else if ([kItemBufferReady isEqualToString:keyPath]) {
        self.status = self.player.rate > 0 ? BQPlayerStatusPlaying : BQPlayerStatusPaused;
    }
}

- (void)itemStatusChange {
    if (self.player.currentItem) {
        AVPlayerItemStatus status = self.player.currentItem.status;
        if (status == AVPlayerItemStatusReadyToPlay) {
            self.status = BQPlayerStatusReady;
            if (self.player.rate > 0) {
                self.status = BQPlayerStatusPlaying;
            }
        } else if (status == AVPlayerItemStatusFailed) {
            self.status = BQPlayerStatusFail;
        } else if (status == AVPlayerItemStatusUnknown) {
            self.status = BQPlayerStatusUnkown;
        }
    }
}

- (void)bufferChange {
    NSArray<NSValue *> * ranges = self.player.currentItem.loadedTimeRanges;
    if (ranges.count > 0) {
        CMTimeRange time = [ranges.firstObject CMTimeRangeValue];
        CGFloat total = CMTimeGetSeconds(time.start) + CMTimeGetSeconds(time.duration);
        if ([self.delegate respondsToSelector:@selector(bqPlayerBufferChange:)]) {
            [self.delegate bqPlayerBufferChange:total];
        }
    }
}

#pragma mark - *** set & get

- (void)setHookTime:(CMTime)hookTime {
    if (_timeObserve) {
        [self.player removeTimeObserver:_timeObserve];
    }
    _hookTime = hookTime;
    __weak typeof(self) weakSelf = self;
    _timeObserve = [self.player addPeriodicTimeObserverForInterval:hookTime queue:nil usingBlock:^(CMTime time) {
        CGFloat currentTime = CMTimeGetSeconds(time);
        if ([weakSelf.delegate respondsToSelector:@selector(bqPlayerTimeChange:)]) {
            [weakSelf.delegate bqPlayerTimeChange:currentTime];
        }
        CGFloat duration = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        if (!isnan(duration) && currentTime == duration) {
            weakSelf.status =  BQPlayerStatusStop;
        }
    }];
}

- (void)setStatus:(BQPlayerStatus)status {
    if (status != _status) {
        _status = status;
        CGFloat duration = CMTimeGetSeconds(self.player.currentItem.duration);
        if (isnan(duration)) {
            duration = 0;
        }
        if ([self.delegate respondsToSelector:@selector(bqPlayerStatusChange:duration:)]) {
            [self.delegate bqPlayerStatusChange:status duration:duration];
        }
    }
}
@end
