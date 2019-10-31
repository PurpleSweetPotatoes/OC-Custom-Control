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

void BQLogInfo(NSString * content, NSString * function, NSString * fileName, NSInteger line);

#define Log(FORMAT, ...) BQLogInfo([NSString stringWithFormat:FORMAT, ##__VA_ARGS__], [NSString stringWithUTF8String:__FUNCTION__],[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__)

typedef NS_OPTIONS(NSUInteger, LoggerType) {
    LoggerType_log          = 1 << 0,   ///<  本地输出
};

typedef void(^CrashBlock)(NSString * reason);
typedef void(^ClearBlock)(NSString * filePath);



@interface BQLogger : NSObject

@property (nonatomic, assign) NSInteger maxFileSize; ///<  文件默认大小2M
@property (nonatomic, assign) NSTimeInterval cleanSecond; ///< 文件默认清理周期3天

/// 开始后使用Log输出
+ (void)start:(LoggerType)options;

+ (instancetype)shareLog;

+ (NSString *)logFilePath;

+ (BOOL)clearLogFile;

/// 开启本地记录，文件大小或时间超限后调用回调
+ (void)clearLogFileHandle:(ClearBlock)handle;

/// 开启crash记录，并读取上次crash原因
+ (void)loadCrashReport:(CrashBlock)handle;

@end

NS_ASSUME_NONNULL_END
