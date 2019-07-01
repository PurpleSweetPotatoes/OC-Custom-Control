//
//  BQSliderView.h
//  tianyaTest
//
//  Created by baiqiang on 2019/6/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BQSliderView;

@protocol BQSliderViewDelegate <NSObject>

- (void)sliderBeignChange:(BQSliderView *)slider;
- (void)sliderEndChange:(BQSliderView *)slider;

@end

@interface BQSliderView : UIView

@property (nonatomic, weak) id<BQSliderViewDelegate>  delegate;
/**  滑条背景颜色 */
@property (nonatomic, strong) UIColor * sliderBgColor;
/**  滑条颜色 */
@property (nonatomic, strong) UIColor * sliderColor;
/**  最大数值 */
@property (nonatomic, assign) CGFloat  maxValue;
/**  当前数值 */
@property (nonatomic, assign) CGFloat sliderValue;

@property (nonatomic, strong) UIImage * centerImg;

/** 缓冲条颜色 */
@property (nonatomic, strong) UIColor * bufferColor;
/** 缓冲条数值 */
@property (nonatomic, assign) CGFloat  bufferValue;

/** 是否展示数值信息,默认YES */
@property (nonatomic, assign) BOOL  showValueInfo;

@property (nonatomic, assign) BOOL  canSlide;
@end

NS_ASSUME_NONNULL_END
