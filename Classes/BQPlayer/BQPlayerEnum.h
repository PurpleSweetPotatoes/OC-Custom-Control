// *******************************************
//  File Name:      BQPlayerEnum.h
//  Author:         MrBai
//  Created Date:   2021/12/17 3:45 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#ifndef BQPlayerEnum_h
#define BQPlayerEnum_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BQPlayerStatus) {
    BQPlayerStatusNone,         // 无状态
    BQPlayerStatusReady,        // 已准备
    BQPlayerStatusWait,         // 等待
    BQPlayerStatusPaused,       // 暂停
    BQPlayerStatusPlaying,      // 正在播放
    BQPlayerStatusStop,         // 停止
    BQPlayerStatusEnd,          // 完成
    BQPlayerStatusFail,         // 加载失败
    BQPlayerStatusUnkown        // 未知
};

typedef NS_ENUM(NSUInteger, SliderImgType) {
    SliderImgTypeNone,
    SliderImgTypeBrightness,            ///< 灯光
    SliderImgTypeVolume,                ///< 音量
    SliderImgTypeSpeed,               ///< 快进/快退
};


#endif /* BQPlayerEnum_h */
