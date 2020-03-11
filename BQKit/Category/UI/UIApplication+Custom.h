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

+ (NSString *)appName;

+ (NSString *)appBundleName;

+ (NSString *)appBundleID;

+ (NSString *)appVersion;

+ (NSString *)appBuildVersion;

@end

NS_ASSUME_NONNULL_END
