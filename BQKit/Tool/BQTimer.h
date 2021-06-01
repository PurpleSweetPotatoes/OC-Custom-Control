//
//  BQTimer.h
//  tianyaTest
//
//  Created by baiqiang on 2019/5/28.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^TimerBlock)(NSInteger count);

/// 自定义定时器
@interface BQTimer : NSObject

/// 运行次数
@property (nonatomic, assign) NSInteger runTimes;

/// 是否正在执行
@property (nonatomic, readonly, assign) BOOL isRun;


+ (instancetype)start:(NSTimeInterval)startTime interval:(NSTimeInterval)interval block:(TimerBlock)block;
+ (instancetype)start:(NSTimeInterval)startTime interval:(NSTimeInterval)interval async:(BOOL)async block:(TimerBlock)block;

- (void)start;
- (void)pause;
- (void)clear;

@end

NS_ASSUME_NONNULL_END
