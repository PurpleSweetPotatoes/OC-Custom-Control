//
//  NSBundle+Refresh.m
//  TianyaTest
//
//  Created by MrBai on 2017/8/14.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "NSBundle+Refresh.h"
#import <ImageIO/ImageIO.h>

static UIImage * img = nil;
static NSBundle * refresh = nil;
static NSBundle * localBundle = nil;


@implementation NSBundle (Refresh)

+ (NSBundle *)refreshBunlde {
    if (refresh == nil) {
        refresh = [self bundleWithPath:[[NSBundle mainBundle] pathForResource:@"BQRefresh" ofType:@"bundle"]];
    }
    return refresh;
}

+ (UIImage *)arrowImage {
    if (img == nil) {
        img = [UIImage imageWithContentsOfFile:[[self refreshBunlde] pathForResource:@"arrow@2x" ofType:@"png"]];
    }
    return img;
}

+ (NSString *)refreshStringKey:(NSString *)key {
    if (localBundle == nil) {
        NSString * language = [NSLocale preferredLanguages].firstObject;
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else if ([language hasPrefix:@"zh"]) {
            if ([language rangeOfString:@"Hans"].location != NSNotFound) {
                language = @"zh-Hans"; // 简体中文
            } else { // zh-Hant\zh-HK\zh-TW
                language = @"zh-Hant"; // 繁體中文
            }
        } else {
            language = @"en";
        }
        
        // 从MJRefresh.bundle中查找资源
        localBundle = [NSBundle bundleWithPath:[[NSBundle refreshBunlde] pathForResource:language ofType:@"lproj"]];
    }
    NSString * value = [localBundle localizedStringForKey:key value:@"" table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}

+ (UIImage *)animatedFirstImg {
    if (img == nil) {
        CGFloat scale = [UIScreen mainScreen].scale;
        NSString * resource = scale > 1.0f ? @"refresh_pull@3x" : @"refresh_pull@2x";
        NSString * path = [[self refreshBunlde] pathForResource:resource ofType:@"png"];
        img = [UIImage imageWithContentsOfFile:path];
    }
    return img;
}
@end
