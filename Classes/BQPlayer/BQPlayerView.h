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
#import "BQPlayerEnum.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BQPlayerDelegate <NSObject>

@optional
- (void)playerStatusChange:(BQPlayerStatus)status duration:(CGFloat)duration;
- (void)playerBufferChange:(CGFloat)value;
- (void)playerTimeChange:(CGFloat)currentTime;
@end


/// 基于AVPlayer封装播放视图
@interface BQPlayerView : UIView

@property (nonatomic, weak) id<BQPlayerDelegate>  delegate;

/// 时间改变回调间隔,默认1s一次
@property (nonatomic, assign) CMTime  hookTime;

@property (nonatomic, assign) BQPlayerStatus status;

@property (nonatomic, copy) NSString * videoUrl;

+ (instancetype)playerWithFrame:(CGRect)frame url:(NSString *)url;

- (void)play;

- (void)pause;

- (void)replay;

- (void)stop;

- (void)seekToTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
