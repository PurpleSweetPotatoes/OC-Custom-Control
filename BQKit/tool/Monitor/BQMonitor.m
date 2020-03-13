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

void UncaughtExceptionHandler(NSException *exception);

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

#pragma mark - 异常

+ (NSString *)errorLogPath {
    NSString * doucoment = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [doucoment stringByAppendingPathComponent:@"bqCrash.log"];
}

+ (void)loadCrashReport:(CrashBlock)handle {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    NSString * info = [NSString stringWithContentsOfFile:[self errorLogPath]  encoding:NSUTF8StringEncoding error:nil];
    if ([info isKindOfClass:[NSString class]] && info.length > 0) {
        handle(info);
    }
    
    [@"" writeToFile:[self errorLogPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end

void UncaughtExceptionHandler(NSException *exception) {
    
    NSString * disPlayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString * appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * sysVersion = [UIDevice currentDevice].systemVersion;
    
    NSString * deviceInfo = [NSString stringWithFormat:@"**********    %@    **********\ndisName:%@\t version:%@\t system:%@", currentTimeStr(),disPlayName, appVersion, sysVersion];
    
    /*  获取异常崩溃信息 */
    NSString * name = [exception name];
    NSString * reason = [exception reason];
    NSArray * callStack = [exception callStackSymbols];
    NSString * content = [NSString stringWithFormat:@"\n%@\n%@ %@\ncallStackSymbols:\n%@",deviceInfo, name, reason, [callStack componentsJoinedByString:@"\n"]];
    [content writeToFile:[BQMonitor errorLogPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
