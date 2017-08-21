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
+ (NSArray <UIImage *> *)animatedGifs
{
    NSString * name = @"earth_loading";
    CGFloat scale = [UIScreen mainScreen].scale;
    NSData *data = nil;
    if (scale > 1.0f)
    {
        NSString *retinaPath = [[self refreshBunlde] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:retinaPath];
        
        if (!data)
        {
            NSString *path = [[self refreshBunlde] pathForResource:name ofType:@"gif"];
            data = [NSData dataWithContentsOfFile:path];
        }
    }
    else
    {
        NSString *path = [[self refreshBunlde] pathForResource:name ofType:@"gif"];
        data = [NSData dataWithContentsOfFile:path];
    }
    
    if (!data)
    {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    NSMutableArray *images = [NSMutableArray array];
    if (count <= 1)
    {
        animatedImage = [UIImage imageWithData:data];
        [images addObject:animatedImage];
    }
    else
    {
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++)
        {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
    }
    CFRelease(source);
    
    return images;
}

+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}
@end
