// *******************************************
//  File Name:      BQVideoView.h       
//  Author:         MrBai
//  Created Date:   2021/12/17 3:37 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQPlayerEnum.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BQVideoViewDelegate <NSObject>

- (BOOL)videoWillPlay;
- (BOOL)videoWillPause;
- (void)videoTimeChange:(NSInteger)time;
- (void)videoPlayEnd;
@end

@interface BQVideoView : UIView

@property (nonatomic, weak) id<BQVideoViewDelegate> delegate;

@property (nonatomic, copy) NSString  * title;
@property (nonatomic, copy) NSString  * videoUrl;

@property (nonatomic, readonly, assign) BQPlayerStatus status;///< 当前播放状态
@property (nonatomic, readonly, assign) NSInteger      currentTime;///< 当前播放进度
@property (nonatomic, readonly, assign) NSInteger      duration;///< 总时长
@property (nonatomic, getter = isFull ) BOOL           full;///< 是否全屏

+ (instancetype)playerWithFrame:(CGRect)frame url:(NSString *)url;

- (void)play;

- (void)pause;

- (void)replay;

- (void)stop;

- (void)seekToTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
