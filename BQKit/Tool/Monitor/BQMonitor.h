// *******************************************
//  File Name:      BQMonitor.h       
//  Author:         MrBai
//  Created Date:   2020/3/12 11:50 AM
//    
//  Copyright © 2020 cs
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 监控工具
@interface BQMonitor : NSObject

/// 卡顿监控工具类
+ (void)registerRunLoopObserver;



@end

NS_ASSUME_NONNULL_END
