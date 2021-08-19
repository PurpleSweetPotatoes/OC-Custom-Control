// *******************************************
//  File Name:      BQCrashHelper.m       
//  Author:         MrBai
//  Created Date:   2021/7/22 8:23 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQCrashHelper.h"

void BQ_UncaughtExceptionHandler(NSException *exception);

static NSUncaughtExceptionHandler *_bqPreviousHandler;


@interface CrashTipView : UIView
+ (void)showWithTip:(NSString *)reason;
@end


@implementation BQCrashHelper

#ifdef DEBUG

+ (void)load {
    __block id observer = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        _bqPreviousHandler = NSGetUncaughtExceptionHandler();
        NSSetUncaughtExceptionHandler(&BQ_UncaughtExceptionHandler);
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
}

+ (NSString *)errorLogPath {
    NSString * doucoment = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [doucoment stringByAppendingPathComponent:@"bqCrash.log"];
}

+ (void)loadCrashReport:(CrashBlock)handle {
    NSString * info = [NSString stringWithContentsOfFile:[self errorLogPath]  encoding:NSUTF8StringEncoding error:nil];
    if ([info isKindOfClass:[NSString class]] && info.length > 0) {
        handle(info);
    }
}

+ (void)clearCrashInfo {
    [@"" writeToFile:[self errorLogPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (void)showCrashInfo {
    [self loadCrashReport:^(NSString * _Nonnull reason) {
        [CrashTipView showWithTip:reason];
    }];
}
#endif
@end

void BQ_UncaughtExceptionHandler(NSException *exception) {
    
    NSString * disPlayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString * appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * sysVersion = [UIDevice currentDevice].systemVersion;
    
    NSString * deviceInfo = [NSString stringWithFormat:@"**********\nDisName:%@\nVersion:%@\nSystem:%@\nTime:%@",disPlayName, appVersion, sysVersion, [NSDate locaDate]];
    
    /*  获取异常崩溃信息 */
    NSString * name = [exception name];
    NSString * reason = [exception reason];
    NSArray * callStack = [exception callStackSymbols];
    NSString * content = [NSString stringWithFormat:@"\n%@\n%@ %@\nCallStackSymbols:\n%@",deviceInfo, name, reason, [callStack componentsJoinedByString:@"\n"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * filePath = [BQCrashHelper errorLogPath];
    if(![fileManager fileExistsAtPath:filePath]){ //如果不存在
        // 直接写入
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    } else {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        [fileHandle seekToEndOfFile];
        NSData * stringData  = [content dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:stringData]; //追加写入数据
        [fileHandle closeFile];
    }
    
    if (_bqPreviousHandler) {
        _bqPreviousHandler(exception);
    }
}

@implementation CrashTipView

+ (void)showWithTip:(NSString *)reason {
    CrashTipView * bgView = [[CrashTipView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    CGFloat top = [UIApplication sharedApplication].statusBarFrame.size.height;
    UIScrollView * scrV = [[UIScrollView alloc] initWithFrame:CGRectMake(10, top, bgView.bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - top - 60)];
    [bgView addSubview:scrV];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:scrV.bounds];
    lab.font = [UIFont systemFontOfSize:14];
    lab.textColor = [UIColor whiteColor];
    lab.numberOfLines = 0;
    lab.text = reason;
    [lab sizeToFit];
    
    [scrV addSubview:lab];
    scrV.contentSize = CGSizeMake(scrV.bounds.size.width, lab.bounds.size.height);
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((bgView.width - 100) * 0.5, [UIScreen mainScreen].bounds.size.height - 45, 100, 30);
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn addTarget:bgView action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
}

- (void)btnAction {
    [self removeFromSuperview];
}

@end

