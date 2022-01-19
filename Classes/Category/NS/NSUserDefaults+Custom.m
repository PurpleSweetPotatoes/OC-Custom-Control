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
    [self synchInfo:^(NSUserDefaults * _Nonnull user) {
        [user setObject:objc forKey:key];
    }];
}

+ (void)setInfoWithDic:(NSDictionary *)dic {
    [self synchInfo:^(NSUserDefaults * _Nonnull user) {
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [user setObject:obj forKey:key];
        }];
    }];
}

+ (void)synchInfo:(UserDefaultsBlock)block {
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
