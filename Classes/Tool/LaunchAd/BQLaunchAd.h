// *******************************************
//  File Name:      BQLaunchAd.h       
//  Author:         MrBai
//  Created Date:   2021/12/16 9:41 AM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>
#import "BQLaunchConfig.h"

NS_ASSUME_NONNULL_BEGIN

/// 添加启动视图，需在application:didFinishLaunchingWithOptions:中添加视图
@interface BQLaunchAd : NSObject

/// 配置启动参数
+ (void)setConfig:(BQLaunchConfig *)config;

/// 调用关闭广告视图
+ (void)close;

@end

NS_ASSUME_NONNULL_END
