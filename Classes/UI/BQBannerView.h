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

- (NSInteger)numOfImgsInBannerView:(BQBannerView *)banner;

- (void)bannerView:(BQBannerView *)banner
        configImgV:(UIImageView *)imageView
             index:(NSInteger)index;

@optional

- (void)bannerView:(BQBannerView *)banner
        clickIndex:(NSInteger)index;

- (void)bannerView:(BQBannerView *)banner
     scorllToIndex:(NSInteger)index;

@end



/// 无限滚动广告视图
@interface BQBannerView : UIView

@property (nonatomic, weak) id<BQBannerViewDelegate> delegate;      ///< 响应代理
@property (nonatomic, assign) NSTimeInterval  times;                ///< 广告展示时间，默认2s
@property (nonatomic, readonly, assign) NSInteger  currentIndex;    ///< 当前广告下标
@property (nonatomic, strong) UIPageControl * pageControl;          ///< 标签控制器

/// 重载广告视图
- (void)reloadData;

@end


NS_ASSUME_NONNULL_END
