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

- (id)safeObjectForKey:(id)key {
    id result = [self objectForKey:key];
    
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return result;
}

- (id)safeValueForKey:(NSString *)key {
    id result = [self valueForKey:key];
    
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    return result;
}

@end
