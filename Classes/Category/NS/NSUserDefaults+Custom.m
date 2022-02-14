// *******************************************
//  File Name:      NSUserDefaults+Custom.m       
//  Author:         MrBai
//  Created Date:   2022/1/19 11:07 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "NSUserDefaults+Custom.h"

@implementation NSUserDefaults (Custom)

+ (void)setObjc:(id)objc key:(NSString *)key {
    [self batchProcess:^(NSUserDefaults * _Nonnull user) {
        [user setObject:objc forKey:key];
    }];
}

+ (void)removeKey:(NSString *)key {
    [self batchProcess:^(NSUserDefaults * _Nonnull user) {
        [user removeObjectForKey:key];
        [user synchronize];
    }];
}

+ (void)removeKeys:(NSArray<NSString *> *)keys {
    [self batchProcess:^(NSUserDefaults * _Nonnull user) {
        for (NSString * key in keys) {
            [user removeObjectForKey:key];
        }
        [user synchronize];
    }];
}

+ (void)setInfoWithDic:(NSDictionary *)dic {
    [self batchProcess:^(NSUserDefaults * _Nonnull user) {
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [user setObject:obj forKey:key];
        }];
    }];
}

+ (void)batchProcess:(UserDefaultsBlock)block {
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    block(user);
    [user synchronize];
}

+ (id)objectForKey:(NSString *)key {
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:key];
}

+ (BOOL)hasKey:(NSString *)key {
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    return [user objectForKey:key] != nil;
}

@end
