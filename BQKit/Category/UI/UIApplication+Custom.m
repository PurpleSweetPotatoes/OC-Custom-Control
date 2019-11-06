//
//  UIApplication+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/18.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "UIApplication+Custom.h"
#import "NSObject+Custom.h"

@implementation UIApplication (Custom)

+ (void)load {
    [self exchangeMethod:@selector(sendEvent:) with:@selector(bq_sendEvent:)];
}

- (void)bq_sendEvent:(UIEvent *)event {
    [self bq_sendEvent:event];
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
