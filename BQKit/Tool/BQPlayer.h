// *******************************************
//  File Name:      BQPlayer.h       
//  Author:         MrBai
//  Created Date:   2021/9/26 4:28 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BQPlayerStatus) {
    BQPlayerStatusNone,         // 无状态
    BQPlayerStatusReady,        // 已准备
    BQPlayerStatusPlaying,      // 正在播放
    BQPlayerStatusPuased,       // 暂停
    BQPlayerStatusWait,         // 等待
    BQPlayerStatusStop,         // 停止
    BQPlayerStatusFail,         // 加载失败
};

@protocol BQPlayerDelegate <NSObject>

@optional
- (void)bqPlayerStatusChange:(BQPlayerStatus)status duration:(CGFloat)duration;
- (void)bqPlayerBufferChange:(CGFloat)value;
- (void)bqPlayerBufferEmpty;
- (void)bqPlayerBufferReady;
- (void)bqPlayerTimeChange:(CGFloat)currentTime;

@end

@interface BQPlayer : AVPlayer

@property (nonatomic, weak) id<BQPlayerDelegate>  delegate;

/// 时间改变回调间隔,默认1s一次
@property (nonatomic, assign) CMTime  hookTime;

@property (nonatomic, assign) BQPlayerStatus bqStatus;

@end

NS_ASSUME_NONNULL_END
