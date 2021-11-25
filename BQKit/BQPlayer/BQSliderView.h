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

@optional
- (void)sliderBeginChange:(BQSliderView *)slider;
- (void)sliderValueChange:(BQSliderView *)slider;
- (void)sliderChangeEnd:(BQSliderView *)slider;

@end

@interface BQSliderView : UIView
@property (nonatomic, weak            ) id<BQSliderViewDelegate> delegate;
/**  最大数值 */
@property (nonatomic, assign          ) NSInteger            maxValue;
/**  当前数值 */
@property (nonatomic, assign          ) NSInteger            value;
@property (nonatomic, strong          ) UIImage              * centerImg;
/** 缓冲条数值 */
@property (nonatomic, assign          ) NSInteger            bufferValue;
@property (nonatomic, assign          ) BOOL                 canSlide;
@property (nonatomic, readonly, assign) BOOL                 isDrag;

/**  设置滑条颜色 */
- (void)setSliderColor:(UIColor *)color;
/**  滑条背景颜色 */
- (void)setSliderBgColor:(UIColor *)color;
/** 缓冲条颜色 */
- (void)setBufferColor:(UIColor *)color;

- (void)resetStatus;
@end

NS_ASSUME_NONNULL_END
