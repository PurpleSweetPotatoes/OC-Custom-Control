// *******************************************
//  File Name:      BQPlayer.m       
//  Author:         MrBai
//  Created Date:   2021/9/26 4:28 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQPlayer.h"

static NSString * const kControlStatus = @"timeControlStatus";
static NSString * const kItemPlayStatus = @"status";
static NSString * const kItemBufferLoad = @"loadedTimeRanges";
static NSString * const kItemNoBuffer = @"playbackBufferEmpty";
static NSString * const kItemBufferReady = @"isPlaybackLikelyToKeepUp";


@interface BQPlayer ()
@property (nonatomic, strong) NSMutableArray * kvoList;
@property (nonatomic, strong) id timeObserve;
@end

@implementation BQPlayer

- (void)dealloc {
    NSLog(@"播放器释放%@", self);
    [self cleanBaseObserver];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _bqStatus = BQPlayerStatusNone;
        [self addObserver:self forKeyPath:kControlStatus options:0 context:nil];
        self.hookTime = CMTimeMake(1, 1);
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL {
    self = [super initWithURL:URL];
    if (self) {
        [self addObserverInfo];
    }
    return self;
}

- (void)replaceCurrentItemWithPlayerItem:(AVPlayerItem *)item {
    [self cleanItemObserver];
    [super replaceCurrentItemWithPlayerItem:item];
    [self addObserverInfo];
}

#pragma mark - *** private method

- (void)addObserverInfo {
    if (self.currentItem) {
        [self.currentItem addObserver:self forKeyPath:kItemPlayStatus options:0 context:nil];
        [self.currentItem addObserver:self forKeyPath:kItemBufferLoad options:0 context:nil];
        [self.currentItem addObserver:self forKeyPath:kItemNoBuffer options:0 context:nil];
        [self.currentItem addObserver:self forKeyPath:kItemBufferReady options:0 context:nil];
    }
}

- (void)cleanItemObserver {
    [self.currentItem removeObserver:self forKeyPath:kItemPlayStatus];
    [self.currentItem removeObserver:self forKeyPath:kItemBufferLoad];
    [self.currentItem removeObserver:self forKeyPath:kItemNoBuffer];
    [self.currentItem removeObserver:self forKeyPath:kItemBufferReady];
}

- (void)cleanBaseObserver {
    if (_timeObserve) {
        [self removeTimeObserver:_timeObserve];
    }
    [self removeObserver:self forKeyPath:kControlStatus];
}

#pragma mark - *** observer handler

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([kControlStatus isEqualToString:keyPath]) {
        [self bqPlayStatusChange];
    } else if ([kItemPlayStatus isEqualToString:keyPath]) {
        [self itemStatusChange];
    } else if ([kItemBufferLoad isEqualToString:keyPath]) {
        [self bufferChange];
    } else if ([kItemNoBuffer isEqualToString:keyPath]) {
        if ([self.delegate respondsToSelector:@selector(bqPlayerBufferEmpty)]) {
            [self.delegate bqPlayerBufferEmpty];
        }
    } else if ([kItemBufferReady isEqualToString:keyPath]) {
        if ([self.delegate respondsToSelector:@selector(bqPlayerBufferReady)]) {
            [self.delegate bqPlayerBufferReady];
        }
    }
}

- (void)bqPlayStatusChange {
    if (@available(iOS 10.0, *)) {
        AVPlayerTimeControlStatus status = self.timeControlStatus;
        if (AVPlayerTimeControlStatusPlaying == status) {
            self.bqStatus = BQPlayerStatusPlaying;
        } else if (AVPlayerTimeControlStatusPaused == status) {
            if (CMTimeGetSeconds([self currentTime]) == CMTimeGetSeconds(self.currentItem.duration)) {
                self.bqStatus = BQPlayerStatusStop;
            } else {
                self.bqStatus = BQPlayerStatusPuased;
            }
        } else {
            self.bqStatus = BQPlayerStatusWait;
        }
    }
}

- (void)itemStatusChange {
    if (self.currentItem) {
        AVPlayerItemStatus status = self.currentItem.status;
        if (status == AVPlayerItemStatusReadyToPlay) {
            self.bqStatus = BQPlayerStatusReady;
        } else if (status == AVPlayerItemStatusFailed) {
            self.bqStatus = BQPlayerStatusFail;
        }
    }
}

- (void)bufferChange {
    
    NSArray<NSValue *> * ranges = self.currentItem.loadedTimeRanges;
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
        [self removeTimeObserver:_timeObserve];
    }
    _hookTime = hookTime;
    WeakSelf;
    _timeObserve = [self addPeriodicTimeObserverForInterval:hookTime queue:nil usingBlock:^(CMTime time) {
        if ([weakSelf.delegate respondsToSelector:@selector(bqPlayerTimeChange:)]) {
            [weakSelf.delegate bqPlayerTimeChange:CMTimeGetSeconds(time)];
        }
    }];
}

- (void)setBqStatus:(BQPlayerStatus)bqStatus {
    _bqStatus = bqStatus;
    if ([self.delegate respondsToSelector:@selector(bqPlayerStatusChange:duration:)]) {
        CGFloat duration = CMTimeGetSeconds(self.currentItem.duration);
        [self.delegate bqPlayerStatusChange:self.bqStatus duration:duration];
    }
}
@end
