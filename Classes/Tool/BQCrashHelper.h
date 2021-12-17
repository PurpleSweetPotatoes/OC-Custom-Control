// *******************************************
//  File Name:      BQCrashHelper.h       
//  Author:         MrBai
//  Created Date:   2021/7/22 8:23 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>
#import "BQDefineInfo.h"

NS_ASSUME_NONNULL_BEGIN

/// crash信息捕获查看
@interface BQCrashHelper : NSObject

/// 开启crash日志记录
+ (void)startCrashRecord;

///读取crash信息
+ (void)loadCrashReport:(StringBlock)handle;

///展示crash信息
+ (void)showCrashInfo;

/// 清除日志
+ (void)clearCrashInfo;

@end

NS_ASSUME_NONNULL_END
