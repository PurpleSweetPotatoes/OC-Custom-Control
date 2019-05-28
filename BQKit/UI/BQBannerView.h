//
//  BQBannerView.h
//  Test
//
//  Created by MAC on 16/12/19.
//  Copyright © 2016年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BQBannerView;

@protocol BQBannerViewDelegate <NSObject>

@optional

- (void)bannerView:(BQBannerView *)view clickIndex:(NSInteger)index;

- (void)bannerView:(BQBannerView *)view scorllToIndex:(NSInteger)index;

@end

/** 需要依赖SDWebImage框架 */
@interface BQBannerView : UIView

@property (nonatomic, weak) id<BQBannerViewDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval  times;                ///< 默认2s
@property (nonatomic, strong) NSArray<NSString *> * imgUrlArr;      ///< 数据源
@property (nonatomic, readonly, assign) NSInteger  currentIndex;

@property (nonatomic, strong) UIPageControl * pageControl;

@end


NS_ASSUME_NONNULL_END
