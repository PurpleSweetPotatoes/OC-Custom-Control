// *******************************************
//  File Name:      BQLogger.h       
//  Author:         MrBai
//  Created Date:   2019/10/29 2:20 PM
//    
//  Copyright © 2019 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


// 默认大小2M
static const NSInteger maxFileSize = 1024 * 1024 * 2;

// 文件清理周期
static const NSTimeInterval cleanSecond = 60 * 60 * 24 * 3;

void BQLogInfo(NSString * content, NSString * fileName, NSInteger line);

#define Log(FORMAT, ...) BQLogInfo([NSString stringWithFormat:FORMAT, ##__VA_ARGS__], [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__)

typedef NS_OPTIONS(NSUInteger, LoggerType) {
    LoggerType_log          = 1 << 0,   ///<  本地输出
};

typedef void(^CrashBlock)(NSString * reason);
typedef void(^ClearBlock)(NSString * filePath);

@interface BQLogger : NSObject

+ (void)start:(LoggerType)options;

+ (NSString *)logFilePath;

+ (BOOL)clearLogFile;

/// 开启本地记录，大小或时间超限后调用回调
+ (void)clearLogFileHandle:(ClearBlock)handle;

/// 开启crash记录，crash内容保存至本地，下次启动时回调函数
+ (void)loadCrashReport:(CrashBlock)handle;

@end

NS_ASSUME_NONNULL_END
