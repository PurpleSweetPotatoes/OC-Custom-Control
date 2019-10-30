// *******************************************
//  File Name:      BQLogger.m       
//  Author:         MrBai
//  Created Date:   2019/10/29 2:20 PM
//    
//  Copyright © 2019 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQLogger.h"

void UncaughtExceptionHandler(NSException *exception);

@interface BQLogger ()
@property (nonatomic, strong) dispatch_queue_t logQueue;
@property (nonatomic, strong) NSFileHandle * fileHandle;
@property (nonatomic, copy) ClearBlock clearHandle;
@property (nonatomic, assign) BOOL  logInfo;
@property (nonatomic, assign) BOOL  saveLocal;
@end

@implementation BQLogger

static BQLogger * logger;

+ (instancetype)shareLog {
    if (logger == nil) {
        logger = [[BQLogger alloc] init];
    }
    return logger;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        logger = [super allocWithZone:zone];
        logger.logQueue = dispatch_queue_create("com.MrBai.LoggerQueue", DISPATCH_QUEUE_SERIAL);
    });
    return logger;
}

+ (void)start:(LoggerType)options {
    [BQLogger shareLog].logInfo = options & LoggerType_log;
}

#pragma mark - logInfo Method

+ (BOOL)clearLogFile {
    return [@"" writeToFile:[self logFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


+ (void)clearLogFileHandle:(ClearBlock)handle {
    [BQLogger shareLog].saveLocal = YES;
    [BQLogger shareLog].clearHandle = handle;
}

+ (void)saveInfoToLocal:(NSString *)content {
    BQLogger * log = [BQLogger shareLog];
    if (![BQLogger shareLog].saveLocal) return;
        
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * filePath = [self logFilePath];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSDictionary * fileDic = [fileManager attributesOfItemAtPath:filePath error:nil];
        NSInteger size = [fileDic fileSize];
        NSDate * createDate = [fileDic fileCreationDate];
        if (log.clearHandle && (size >= maxFileSize || cleanSecond + [createDate timeIntervalSinceNow] <= 0)) {
            log.clearHandle(filePath);
            if (log.fileHandle) {
                if (@available(iOS 13.0, *)) {
                    [log.fileHandle closeAndReturnError:nil];
                } else {
                    [log.fileHandle closeFile];
                }
                log.fileHandle = nil;
            }
            [BQLogger clearLogFile];
        }
        
        if (log.fileHandle == nil) {
            log.fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
        }
        
        [log.fileHandle seekToEndOfFile];
        [log.fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

#pragma mark - crash Method

+ (void)loadCrashReport:(CrashBlock)handle {

    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    NSString * info = [NSString stringWithContentsOfFile:[self errorLogPath]  encoding:NSUTF8StringEncoding error:nil];
    if ([info isKindOfClass:[NSString class]] && info.length > 0) {
        handle(info);
    }
    [self saveCrashInfo:@""];
}

+ (void)saveCrashInfo:(NSString *)crashInfo {
    [crashInfo writeToFile:[BQLogger errorLogPath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - 文件位置
+ (NSString *)logFilePath {
    NSString * doucoment = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [doucoment stringByAppendingPathComponent:@"logInfo.log"];
}

+ (NSString *)errorLogPath {
    NSString * doucoment = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [doucoment stringByAppendingPathComponent:@"bqCrash.log"];
}

@end

#pragma mark - C函数

static inline NSString* currentTimeStr() {
    static NSDateFormatter * dateForamt;
    if (dateForamt == nil) {
        dateForamt = [[NSDateFormatter alloc] init];
        [dateForamt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString * dateStr = [dateForamt stringFromDate:[NSDate date]];
    return dateStr;
}

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
    [BQLogger saveCrashInfo:content];
}

void BQLogInfo(NSString * content, NSString * fileName, NSInteger line) {
    
    if ([BQLogger shareLog].logInfo || [BQLogger shareLog].saveLocal) {
        
        NSString * logInfo = [NSString stringWithFormat:@"%@ %@ at %ld line:\n%@\n", currentTimeStr(), fileName, line, content];
        
        if ([BQLogger shareLog].logInfo) {
            printf("%s",[logInfo UTF8String]);
        }
        
        dispatch_async([BQLogger shareLog].logQueue, ^{
            [BQLogger saveInfoToLocal:logInfo];
        });
        
    }
}
