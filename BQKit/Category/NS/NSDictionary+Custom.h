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

- (id)safeObjectForKey:(id)key;

- (id)safeValueForKey:(NSString *)key;

@end
