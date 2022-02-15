// *******************************************
//  File Name:      BQUserDefault.m       
//  Author:         MrBai
//  Created Date:   2022/2/11 10:11 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQUserDefault.h"

#import "NSObject+Custom.h"
#import "NSUserDefaults+Custom.h"
#import <objc/runtime.h>

@interface BQUserDefault ()
{
    NSMutableArray * _propertyNames;
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
    [NSUserDefaults batchProcess:^(NSUserDefaults * _Nonnull user) {
        for (NSString * name in self->_propertyNames) {
            [user removeObjectForKey:[self spaceKey:name]];
            [self setProperty:nil key:name];
        }
    }];
}

- (void)changeGetterAndSetter {
    _propertyNames = [NSMutableArray array];
    
    unsigned int count = 0;
    objc_property_t * propertys = class_copyPropertyList([self class], &count);
    
    SEL customGetter = @selector(customGetValue);
    SEL customSetter = @selector(customSetValue:);
    
    const char * getTypes = method_getTypeEncoding(class_getInstanceMethod([self class], customGetter));
    const char * setTypes = method_getTypeEncoding(class_getInstanceMethod([self class], customSetter));
    
    IMP getImp = class_getMethodImplementation([self class], customGetter);
    IMP setImp = class_getMethodImplementation([self class], customSetter);
    
    for (NSInteger i = 0; i < count; i++) {
        
        objc_property_t property = propertys[i];
        
        // get IMP修改
        NSString * name = [NSString stringWithUTF8String:property_getName(property)];
        SEL orginGet = NSSelectorFromString(name);
        class_replaceMethod([self class], orginGet, getImp, getTypes);
        
        // set IMP修改
        NSString * first = [[name substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        NSString * last = [name substringWithRange:NSMakeRange(1, name.length - 1)];
        NSString * setName = [NSString stringWithFormat:@"set%@%@:", first, last];
        SEL orginSet = NSSelectorFromString(setName);
        class_replaceMethod([self class], orginSet, setImp, setTypes);
        
        [_propertyNames addObject:name];
    }
    
    free(propertys);
}

- (void)customSetValue:(id)value {
    
    // 方法名"setxxx:"处理
    NSString * key = NSStringFromSelector(_cmd);
    NSString * pre = [[key substringWithRange:NSMakeRange(3, 1)] lowercaseString];
    NSString * last = [key substringWithRange:NSMakeRange(4, key.length - 5)];
    NSString * name = [NSString stringWithFormat:@"%@%@",pre, last];
    
    // 属性赋值
    [self setProperty:value key:name];
    
    key = [self spaceKey:name];
    if (value) {
        [NSUserDefaults setObjc:value key:key];
    } else {
        [NSUserDefaults removeKey:key];
    }
}

- (id)customGetValue {
    NSString * key = NSStringFromSelector(_cmd);
    id value = [self getPropertyWithKey:key];
    
    if (!value) { // 无值 本地获取
        NSString * name = [self spaceKey:key];
        value = [NSUserDefaults objectForKey:name];
        
        if (value) [self setProperty:value key:key];
    }
    return value;
}

- (NSString *)spaceKey:(NSString *)key {
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), key];
}

@end
