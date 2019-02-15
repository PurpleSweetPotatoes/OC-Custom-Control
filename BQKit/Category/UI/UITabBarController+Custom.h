//
//  UITabBarController+Custom.h
//  tianyaTest
//
//  Created by baiqiang on 2019/2/15.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kVcName     = @"kVcName";
static NSString * const kVcTitle    = @"kVcTitle";
static NSString * const kSelectImg  = @"kSelectImg";
static NSString * const kNormalImg  = @"kNormalImg";

@interface UITabBarController (Custom)

/**
 创建tabbarVc,默认每个子vc为navvc
 
 @param infos [[kVcName:VcName, kVcTitle:vcTitle, kSelectImg:selectImg, kNormalImg:normalImg],...]
 */
+ (instancetype)createVcWithInfo:(NSArray *)infos;

/**
 创建tabbarVc
 
 @param infos [[kVcName:VcName, kVcTitle:vcTitle, kSelectImg:selectImg, kNormalImg:normalImg],...]
 @param needNaVc 是否需要导航栏
 */
+ (instancetype)createVcWithInfo:(NSArray *)infos needNaVc:(BOOL)needNaVc;

@end

NS_ASSUME_NONNULL_END
