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

@interface BQBannerView : UIView

@property (nonatomic, weak) id<BQBannerViewDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval  times;                ///< 默认2s
@property (nonatomic, readonly, assign) NSInteger  currentIndex;

@property (nonatomic, strong) UIPageControl * pageControl;

- (void)reloadData;

@end


NS_ASSUME_NONNULL_END
