//
//  NSDictionary+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Custom)

+ (instancetype)encodeFromStr:(NSString *)str;

+ (instancetype)encodeFromData:(NSData *)data;

+ (instancetype)parseUrlPath:(NSString *)urlStr;

- (NSString *)stringValueForKey:(NSString *)key;

- (NSDictionary *)dicValueForKey:(NSString *)key;

- (NSArray *)arrayValueForKey:(NSString *)key;

- (NSInteger)intValueForKey:(NSString *)key;

- (BOOL)boolValueForKey:(NSString *)key;

- (NSString *)sortKeysToJson;

@end
