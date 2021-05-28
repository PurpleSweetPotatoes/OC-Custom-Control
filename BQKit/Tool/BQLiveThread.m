// *******************************************
//  File Name:      BQLiveThread.m       
//  Author:         MrBai
//  Created Date:   2021/5/27 4:28 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    
#import "BQLiveThread.h"

@interface BQLiveThread ()
@property (nonatomic, assign) BOOL  canDone;
@property (nonatomic, strong) NSThread * thread;
@end

@implementation BQLiveThread

- (void)dealloc {
    NSLog(@"%s",__func__);
    [self stop];
}


+ (instancetype)run {
    BQLiveThread * manager = [[BQLiveThread alloc] init];
    manager.canDone = YES;
    __weak typeof(manager) weakSelf = manager;
    manager.thread = [[NSThread alloc] initWithBlock:^{
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        while (weakSelf && weakSelf.canDone) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }];
    [manager.thread start];
    return manager;
}

- (void)executeTask:(ThreadBlock)block {
    [self performSelector:@selector(_taskProcess:) onThread:self.thread withObject:block waitUntilDone:NO];
}

- (void)stopThread {
    if (!self.thread || !self.canDone) return;
    self.canDone = NO;
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)_taskProcess:(ThreadBlock)block {
    if (self.thread && block) {
        block();
    }
}

- (void)stop {
    // 需要等待线程直线完成，否则线程提前释放，执行停止会抛异常
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}


@end
