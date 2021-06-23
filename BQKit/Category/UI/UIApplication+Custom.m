//
//  UIApplication+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/18.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "UIApplication+Custom.h"

@implementation UIApplication (Custom)

+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)appBundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

+ (NSString *)appBundleID {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appBuildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end
