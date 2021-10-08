// *******************************************
//  File Name:      BQPlayer.h       
//  Author:         MrBai
//  Created Date:   2021/9/26 4:28 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <AVFoundation/AVFoundation.h>
#import "UIButton+Custom.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BQPlayerStatus) {
    BQPlayerStatusNone,         // 无状态
    BQPlayerStatusReady,        // 已准备
    BQPlayerStatusWait,         // 等待
    BQPlayerStatusPaused,       // 暂停
    BQPlayerStatusPlaying,      // 正在播放
    BQPlayerStatusStop,         // 停止
    BQPlayerStatusFail,         // 加载失败
    BQPlayerStatusUnkown        // 未知
};

@protocol BQPlayerDelegate <NSObject>

@optional
- (void)bqPlayerStatusChange:(BQPlayerStatus)status duration:(CGFloat)duration;
- (void)bqPlayerBufferChange:(CGFloat)value;
- (void)bqPlayerTimeChange:(CGFloat)currentTime;

@end


/// 基于AVPlayer封装
@interface BQPlayer : NSObject

@property (nonatomic, weak) id<BQPlayerDelegate>  delegate;

/// 时间改变回调间隔,默认1s一次
@property (nonatomic, assign) CMTime  hookTime;

@property (nonatomic, assign) BQPlayerStatus status;

+ (instancetype)playerWithURL:(NSURL *)URL;

- (instancetype)initWithURL:(NSURL *)URL;

- (instancetype)init NS_UNAVAILABLE;

- (void)reSetURL:(NSURL *)URL;

- (void)play;

- (void)pause;

- (void)replay;

- (void)stop;

- (void)seekToTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
