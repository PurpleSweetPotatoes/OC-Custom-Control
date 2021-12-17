//
//  BQTimer.m
//  tianyaTest
//
//  Created by baiqiang on 2019/5/28.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BQTimer.h"

#import "BQWeakProxy.h"

@interface BQTimer ()
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) BOOL    isRun;
@property (nonatomic, weak  ) id      target;
@property (nonatomic, assign) SEL     selector;
@property (nonatomic, assign) BOOL    isStart;
@end

@implementation BQTimer

- (void)dealloc {
    if (self.timer) {
        [self clear];
    }
}

+ (instancetype)configWithScheduleTime:(NSTimeInterval)time target:(id)target selector:(SEL)selector {
    BQTimer * objc = [[BQTimer alloc] init];
    objc.runTimes = 0;
    objc.target = target;
    objc.selector = selector;
    objc.isRun = YES;
    objc.timer = [NSTimer scheduledTimerWithTimeInterval:time target:[BQWeakProxy proxyWithTarget:objc] selector:@selector(timeScheduleAction:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:objc.timer forMode:NSRunLoopCommonModes];
    [objc pause];
    return objc;
}


- (void)timeScheduleAction:(NSTimer *)timer {
    if ([self.target respondsToSelector:self.selector]) {
        if (self.isStart) {
            self.isStart = NO;
            return;
        }
        self.runTimes += 1;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
    } else {
        [self clear];
    }
}

- (void)start {
    if (self.timer && !self.isRun) {
        self.isStart = YES;
        self.isRun = YES;
        self.timer.fireDate = [NSDate date];
    }
}

- (void)pause {
    if (self.timer && self.isRun) {
        self.isRun = NO;
        self.timer.fireDate = [NSDate distantFuture];
    }
}

- (void)clear {
    self.isRun = NO;
    [self.timer invalidate];
    self.timer = nil;
    self.runTimes = 0;
}


@end
