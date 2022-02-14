// *******************************************
//  File Name:      BQUserDefault.m       
//  Author:         MrBai
//  Created Date:   2022/2/11 10:11 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQUserDefault.h"

#import "NSUserDefaults+Custom.h"
#import <objc/runtime.h>

@interface BQUserDefault ()
{
    NSMutableDictionary * _nameDic;
}
@end

@implementation BQUserDefault

+ (instancetype)share {
    static BQUserDefault * user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[BQUserDefault alloc] init];
        [user changeGetterAndSetter];
    });
    return user;
}

+ (void)clearInfos {
    [BQUserDefault.share clearInfos];
}

- (void)clearInfos {
    NSArray * array = [_nameDic allValues];
    NSSet *set = [NSSet setWithArray:array];
    NSArray *localKeys = [set allObjects];
    [NSUserDefaults batchProcess:^(NSUserDefaults * _Nonnull user) {
        for (NSString * key in localKeys) {
            [user removeObjectForKey:key];
        }
    }];
}

- (void)changeGetterAndSetter {
    unsigned int count = 0;
    objc_property_t * propertys = class_copyPropertyList([self class], &count);
    _nameDic = [NSMutableDictionary dictionaryWithCapacity:count * 2];
    
    SEL customGetter = @selector(customGetValue);
    const char * getTypes = method_getTypeEncoding(class_getInstanceMethod([self class], customGetter));
    IMP getImp = class_getMethodImplementation([self class], customGetter);
    
    SEL customSetter = @selector(customSetValue:);
    const char * setTypes = method_getTypeEncoding(class_getInstanceMethod([self class], customSetter));
    IMP setImp = class_getMethodImplementation([self class], customSetter);
    
    for (NSInteger i = 0; i < count; i++) {
        
        objc_property_t property = propertys[i];
        
        // get IMP修改
        NSString * name = [NSString stringWithUTF8String:property_getName(property)];
        SEL orginGet = NSSelectorFromString(name);
        _nameDic[name] = [self spaceKey:name];
        class_replaceMethod([self class], orginGet, getImp, getTypes);
        
        // set IMP修改
        NSString * setName = [NSString stringWithFormat:@"set%@:",[name stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[name substringToIndex:1] capitalizedString]]];
        SEL orginSet = NSSelectorFromString(setName);
        _nameDic[setName] = [self spaceKey:name];
        class_replaceMethod([self class], orginSet, setImp, setTypes);
    }
}

- (void)customSetValue:(id)value {
    NSString * key = NSStringFromSelector(_cmd);
    NSString * name = _nameDic[key];
    if (value) {
        [NSUserDefaults setObjc:value key:name];
    } else {
        [NSUserDefaults removeKey:name];
    }
}

- (id)customGetValue {
    NSString * key = NSStringFromSelector(_cmd);
    NSString * name = _nameDic[key];
    return [NSUserDefaults objectForKey:name];
}

- (NSString *)spaceKey:(NSString *)key {
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), key];
}

@end
