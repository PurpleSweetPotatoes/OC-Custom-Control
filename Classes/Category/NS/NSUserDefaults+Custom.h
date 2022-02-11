// *******************************************
//  File Name:      NSUserDefaults+Custom.h       
//  Author:         MrBai
//  Created Date:   2022/1/19 11:07 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UserDefaultsBlock)(NSUserDefaults * user);

@interface NSUserDefaults (Custom)

+ (void)synchInfo:(UserDefaultsBlock)block;

+ (void)setObjc:(id)objc key:(NSString *)key;

+ (void)removeKey:(NSString *)key;

+ (void)removeKeys:(NSArray<NSString *> *)keys;

+ (void)setInfoWithDic:(NSDictionary *)dic;

+ (id)objectForKey:(NSString *)key;

+ (BOOL)hasKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
