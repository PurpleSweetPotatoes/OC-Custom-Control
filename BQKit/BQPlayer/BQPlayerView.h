//
//  BQPlayerView.h
//  tianyaTest
//
//  Created by baiqiang on 2019/6/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVAsset;
NS_ASSUME_NONNULL_BEGIN

@interface BQPlayerView : UIView

@property (nonatomic, copy  ) NSString * assetUrl;
@property (nonatomic, strong) AVAsset  * asset;
@property (nonatomic, assign) BOOL     canSlide;        ///< 是否可拖动,默认YES
@property (nonatomic, strong) UIImage  * disPlayImg;    ///< 占位图

- (void)setTopTitle:(NSString *)title;



- (void)play;
- (void)pause;

@end

NS_ASSUME_NONNULL_END
