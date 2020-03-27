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

@end
