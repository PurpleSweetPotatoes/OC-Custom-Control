// *******************************************
//  File Name:      BQLiveThread.h
//  Author:         MrBai
//  Created Date:   2021/5/27 4:28 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ThreadBlock)(void);

@interface BQLiveThread : NSObject

/// 开启一个线程
+ (instancetype)run;

/// 线程中执行任务
/// @param block 任务
- (void)executeTask:(ThreadBlock)block;

/// 关闭线程
- (void)stop;

@end

NS_ASSUME_NONNULL_END
