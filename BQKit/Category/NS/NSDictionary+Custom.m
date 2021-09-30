//
//  NSDictionary+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "NSDictionary+Custom.h"

@implementation NSDictionary (Custom)

+ (instancetype)encodeFromStr:(NSString *)str {
    return [self encodeFromData:[str dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (instancetype)encodeFromData:(NSData *)data {
    return  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

+ (instancetype)parseUrlPath:(NSString *)urlStr {
    NSArray * urlArr = [urlStr componentsSeparatedByString:@"?"];
    if (urlArr.count > 1) {
        NSString * path = urlArr.lastObject;
        NSArray * params = [path componentsSeparatedByString:@"&"];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        for (NSString * info in params) {
            NSArray * keyVArr = [info componentsSeparatedByString:@"="];
            if (keyVArr.count == 2) {
                dic[keyVArr.firstObject] = keyVArr.lastObject;
            }
        }
        return [dic copy];
    }
    return @{};
}

- (NSInteger)intValueForKey:(NSString *)key {
    id result = [self safeObjectForKey:key];
    if ([result isKindOfClass:[NSNumber class]] || [result isKindOfClass:[NSString class]]) {
        return [result intValue];
    }
    return 0;
}

- (NSString *)stringValueForKey:(NSString *)key {
    id result = [self safeObjectForKey:key];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    } else if ([result isKindOfClass:[NSNumber class]]) {
        return [result stringValue];
    } else {
        return nil;
    }
}

- (NSDictionary *)dicValueForKey:(NSString *)key {
    id result = [self safeObjectForKey:key];
    if ([result isKindOfClass:[NSDictionary class]]) {
        return result;
    }
    return nil;
}

- (NSArray *)arrayValueForKey:(NSString *)key {
    id result = [self safeObjectForKey:key];
    if ([result isKindOfClass:[NSArray class]]) {
        return result;
    }
    return nil;
}

- (BOOL)boolValueForKey:(NSString *)key {
    id result = [self safeObjectForKey:key];
    if ([result isKindOfClass:[NSNumber class]] || [result isKindOfClass:[NSString class]]) {
        return [result boolValue];
    }
    return NO;
}

- (id)safeObjectForKey:(id)key {
    id result = [self objectForKey:key];
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return result;
}

- (NSString *)sortKeysToJson {

    NSArray * arr = [[self allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
        return NSOrderedDescending == [obj1 compare:obj2];
    }];
    
    if (arr.count == 0) {
        return @"";
    }
    
    NSMutableString * outStr = [NSMutableString stringWithFormat:@"%@=%@",arr.firstObject,self[arr.firstObject]];
    for (NSInteger i = 1; i < arr.count; i++) {
        id value = self[arr[i]];
        if ([value isKindOfClass:[NSNull class]] || ([value isKindOfClass: [NSString class]] && [value length] == 0)) {
            continue;
        }
        [outStr appendFormat:@"&%@=%@",arr[i], self[arr[i]]];
    }
    return [outStr copy];
}

@end
