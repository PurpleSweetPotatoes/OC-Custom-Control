//
//  BQSliderImgV.h
//  tianyaTest
//
//  Created by baiqiang on 2019/6/28.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQSliderImgV.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SliderImgType) {
    SliderImgTypeNone,
    SliderImgTypeBrightness,            ///< 灯光
    SliderImgTypeVolume,                ///< 音量
    SliderImgTypeSpeed,               ///< 快进/快退
};

@interface BQSliderImgV : UIView
@property (nonatomic, assign) SliderImgType type;
@property (nonatomic, assign) CGFloat       timeValue;///< 快进快退秒数

- (void)show;
- (void)hide;

/** 设置值范围为0~1 */
- (void)setCurrentValue:(float)value;

- (void)setCurrentContent:(NSString *)content isForWard:(BOOL)isForWard;

@end

NS_ASSUME_NONNULL_END
