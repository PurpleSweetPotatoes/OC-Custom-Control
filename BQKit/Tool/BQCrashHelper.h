// *******************************************
//  File Name:      BQCrashHelper.h       
//  Author:         MrBai
//  Created Date:   2021/7/22 8:23 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CrashBlock)(NSString * reason);

@interface BQCrashHelper : NSObject

///读取crash信息
+ (void)loadCrashReport:(CrashBlock)handle;

///展示crash信息
+ (void)showCrashInfo;

/// 清除日志
+ (void)clearCrashInfo;

@end

NS_ASSUME_NONNULL_END
