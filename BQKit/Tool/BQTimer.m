//
//  BQTimer.m
//  tianyaTest
//
//  Created by baiqiang on 2019/5/28.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BQTimer.h"

@interface BQTimer ()
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) dispatch_source_t gcdTimer;
@property (nonatomic, assign) NSTimeInterval  startTime;
@property (nonatomic, assign) NSTimeInterval  interval;
@property (nonatomic, assign) BOOL  isRun;
@property (nonatomic, copy) TimerBlock callBlock;
@property (nonatomic, strong) dispatch_queue_t currentQueue;
@end

@implementation BQTimer

- (void)dealloc {
    NSLog(@"销毁计时器");
    [self clear];
}

+ (instancetype)start:(NSTimeInterval)startTime interval:(NSTimeInterval)interval block:(TimerBlock)block {
    return [self start:startTime interval:interval async:NO block:block];
}

+ (instancetype)start:(NSTimeInterval)startTime interval:(NSTimeInterval)interval async:(BOOL)async block:(TimerBlock)block {
    BQTimer * objc = [[BQTimer alloc] init];
    objc.runTimes = 0;
    objc.callBlock = block;
    objc.isRun = NO;
    objc.startTime = startTime;
    objc.interval = interval;
    objc.currentQueue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    return objc;
}

- (void)creatTimer {
    _gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _currentQueue);
    dispatch_source_set_timer(_gcdTimer, dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(0*NSEC_PER_SEC)), (uint64_t)(_interval*NSEC_PER_SEC), 0);
    //设置回调
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(weakSelf.gcdTimer, ^{
        weakSelf.runTimes += 1;
        //定时器需要执行的操作
        weakSelf.callBlock(weakSelf.runTimes);
    });
    //启动定时器（默认是暂停）
    weakSelf.isRun = !weakSelf.isRun;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(_startTime*NSEC_PER_SEC)), _currentQueue, ^{
        if (@available(iOS 10.0, *)) {
            dispatch_activate(weakSelf.gcdTimer);
        } else {
            dispatch_resume(weakSelf.gcdTimer);
        }
    });
}

- (void)start {
    if (_gcdTimer == nil) {
        [self creatTimer];
    } else if (!_isRun){
        //启动定时器（默认是暂停）
        self.isRun = !self.isRun;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(_startTime*NSEC_PER_SEC)), _currentQueue, ^{
            dispatch_resume(self.gcdTimer);
        });
    }
}

- (void)pause {
    if (_gcdTimer && _isRun) {
        _isRun = !_isRun;
        //启动定时器（默认是暂停）
        dispatch_suspend(_gcdTimer);
    }
}

- (void)clear {
    if (_gcdTimer) {
        NSLog(@"清理计时器");
        _isRun = NO;
        dispatch_source_cancel(_gcdTimer);
    }
}


@end
