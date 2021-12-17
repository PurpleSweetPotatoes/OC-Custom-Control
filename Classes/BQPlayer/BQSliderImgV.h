//
//  BQSliderImgV.h
//  tianyaTest
//
//  Created by baiqiang on 2019/6/28.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "BQSliderImgV.h"

#import "BQPlayerEnum.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
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
