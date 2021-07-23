// *******************************************
//  File Name:      BQMonitor.m       
//  Author:         MrBai
//  Created Date:   2020/3/12 11:50 AM
//    
//  Copyright © 2020 cs
//  All rights reserved
// *******************************************
    

#import "BQMonitor.h"
#import <CrashReporter/CrashReporter.h>

@implementation BQMonitor
{
    dispatch_semaphore_t semaphore;
    CFRunLoopActivity activity;
}

+ (void)registerRunLoopObserver {
    static BQMonitor *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    [instance registerRunLoopObserver];
}

#pragma mark - 卡顿

/// 注册RunLoop状态观察，并计算是否卡顿
- (void)registerRunLoopObserver {
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities,
                                                            YES,
                                                            0,
                                                            &runLoopObserverCallBack,
                                                            &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    
    // 创建信号
    semaphore = dispatch_semaphore_create(0);
    // 在子线程监控时长
    dispatch_queue_t queue = dispatch_queue_create("BQMoitorQueue", 0);
    dispatch_async(queue, ^{
        while (YES) {
            long st = dispatch_semaphore_wait(self->semaphore, dispatch_time(DISPATCH_TIME_NOW, 60*NSEC_PER_MSEC));
            if (st != 0) {
                if (self->activity==kCFRunLoopBeforeSources || self->activity==kCFRunLoopAfterWaiting) {
                    // 发现卡顿
                    [self handleStackInfo];
                }
            }
        }
    });
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    BQMonitor *object = (__bridge BQMonitor*)info;
    // 记录状态值
    object->activity = activity;
    // 发送信号
    dispatch_semaphore_t semaphore = object->semaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)handleStackInfo {
    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];
    
    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
    
    NSData *data = [crashReporter generateLiveReport];
    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
    NSString * report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter withTextFormat:PLCrashReportTextFormatiOS];
    NSRange range = [report rangeOfString:@"Binary" options:NSRegularExpressionSearch];
    NSString * logStr = report;
    if (range.location != NSNotFound) {
        logStr = [report substringWithRange:NSMakeRange(0, range.location)];
    }
    printf("**** 出现卡顿 ****\n%s",[logStr UTF8String]);
}

@end

