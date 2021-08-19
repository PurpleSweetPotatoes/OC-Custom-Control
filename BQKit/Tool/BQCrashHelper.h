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

/// debug模式下用于crash信息查看
@interface BQCrashHelper : NSObject

#ifdef DEBUG

///读取crash信息
+ (void)loadCrashReport:(CrashBlock)handle;

///展示crash信息
+ (void)showCrashInfo;

/// 清除日志
+ (void)clearCrashInfo;

#endif

@end

NS_ASSUME_NONNULL_END
