//
//  UIApplication+Custom.h
//  tianyaTest
//
//  Created by baiqiang on 2019/1/18.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Custom)

/// 应用展示名称
+ (NSString *)appName;

/// 应用标示名称
+ (NSString *)appBundleName;

/// 应用标识
+ (NSString *)appBundleID;

/// 应用版本号
+ (NSString *)appVersion;

/// 应用构建号
+ (NSString *)appBuildVersion;

@end

NS_ASSUME_NONNULL_END
