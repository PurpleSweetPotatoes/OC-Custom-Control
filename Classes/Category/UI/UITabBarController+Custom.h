//
//  UITabBarController+Custom.h
//  tianyaTest
//
//  Created by baiqiang on 2019/2/15.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabBarInfo : NSObject

@property (nonatomic, copy) NSString * clsName;
@property (nonatomic, copy) NSString * barTitle;
@property (nonatomic, copy) NSString * selectImgName;
@property (nonatomic, copy) NSString * normalImgName;

+ (instancetype)infoWithName:(NSString *)clsName
                    barTitle:(NSString *)barTitle;

+ (instancetype)infoWithName:(NSString *)clsName
                    barTitle:(NSString *)barTitle
               normalImgName:(NSString *)normalImgName
               selectImgName:(NSString *)selectImgName;
@end

@interface UITabBarController (Custom)

/// 创建tabbarVc,默认每个子vc为navvc
+ (instancetype)createVcWithInfo:(NSArray<TabBarInfo *> *)infos;

/// 创建tabbarVc,默认每个子vc为navvc
/// @param needNaVc 是否需要导航栏
+ (instancetype)createVcWithInfo:(NSArray<TabBarInfo *> *)infos needNaVc:(BOOL)needNaVc;

/// 配置子控制器
- (void)configVcWithInfo:(NSArray<TabBarInfo *> *)infos;

/// 配置子控制器
/// @param needNaVc 是否需要导航栏
- (void)configVcWithInfo:(NSArray<TabBarInfo *> *)infos needNaVc:(BOOL)needNaVc;
@end

NS_ASSUME_NONNULL_END
