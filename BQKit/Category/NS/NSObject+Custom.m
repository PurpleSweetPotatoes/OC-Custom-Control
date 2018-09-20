//
//  NSObject+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "NSObject+Custom.h"
#import <objc/runtime.h>

@implementation NSObject (Custom)

- (void)encodeInfoWithCoder:(NSCoder *)aCoder {
    //获取传入类
    Class cla = [self class];
    while (cla != [NSObject class]) {
        //判断是否为传入类
        BOOL isSubClass = (cla == [self class]);
        unsigned int ivarCount = 0;
        unsigned int proCount = 0;
        //获取传入类成员变量列表
        Ivar *ivarArray = isSubClass ? class_copyIvarList(cla, &ivarCount) : NULL;
        //获取传入类父类的属性列表
        objc_property_t *proArray = isSubClass ? NULL : class_copyPropertyList(cla, &proCount);
        //设置数组次数
        unsigned int count = isSubClass ? ivarCount : proCount;
        //循环遍历数组
        for (int i = 0; i < count; i ++) {
            //得到变量名字
            const char *name = isSubClass ? ivar_getName(ivarArray[i]) : property_getName(proArray[i]);
            //char* 转化为 NSString 类型
            NSString *ivarKey = [NSString stringWithUTF8String:name];
            //通过kvc得到值
            id value = [self valueForKey:ivarKey];
            //归档设置
            [aCoder encodeObject:value forKey:ivarKey];
        }
        //释放数组
        free(ivarArray);
        free(proArray);
        //将类别指向其父类
        cla = class_getSuperclass(cla);
    }
}

- (void)unencodeWithCoder:(NSCoder *)aDecoder {
    //获取传入类
    Class cla = [self class];
    while (cla != [NSObject class]) {
        //判断是否为传入类
        BOOL isSubClass = (cla == [self class]);
        unsigned int ivarCount = 0;
        unsigned int proCount = 0;
        //获取传入类成员变量列表
        Ivar *ivarArray = isSubClass ? class_copyIvarList(cla, &ivarCount) : NULL;
        //获取传入类父类的属性列表
        objc_property_t *proArray = isSubClass ? NULL : class_copyPropertyList(cla, &proCount);
        //设置遍历数组次数
        unsigned int count = isSubClass ? ivarCount : proCount;
        //循环遍历数组
        for (int i = 0; i < count; i ++) {
            //得到变量名字
            const char *name = isSubClass ? ivar_getName(ivarArray[i]) : property_getName(proArray[i]);
            //char* 转化为 NSString 类型
            NSString *ivarKey = [NSString stringWithUTF8String:name];
            //通过kvc得到值
            id value = [aDecoder decodeObjectForKey:ivarKey];
            //解档设置
            [self setValue:value forKey:ivarKey];
        }
        free(ivarArray);
        free(proArray);
        //将类别指向其父类
        cla = class_getSuperclass(cla);
    }
}

- (NSString *)jsonString {
    
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (!error) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"jsonString format error:%@",error.localizedDescription);
        return @"";
    }
}

+ (BOOL)exchangeMethod:(SEL)target with:(SEL)repalce {
    Method tragetMethod = class_getInstanceMethod(self, target);
    Method replaceMethod = class_getInstanceMethod(self, repalce);
    
    if (tragetMethod == nil || replaceMethod == nil) {
        return NO;
    }
    
    method_exchangeImplementations(tragetMethod, replaceMethod);
    return YES;
}

- (void)setAssociateValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAssociateWeakValue:(id)value withKey:(void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)removeAssociatedValues {
    objc_removeAssociatedObjects(self);
}

- (id)getAssociatedValueForKey:(void *)key {
    return objc_getAssociatedObject(self, key);
}

@end


@implementation NSDictionary (Log)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@"{\n"];
    // 遍历字典的所有键值对
    __block BOOL hasValue = NO;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]) {
            [str appendFormat:@"\t\"%@\":%@,\n", key, obj];
        } else {
            [str appendFormat:@"\t\"%@\":\"%@\",\n", key, obj];
        }
        
        if (hasValue == NO) {
            hasValue = YES;
        }
    }];
    
    [str appendString:@"}"];
    
    if (hasValue == YES) {
        // 查出最后一个,的范围
        NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}
@end

@implementation NSArray (Log)
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"[\n"];
    // 遍历数组的所有元素
    __block BOOL hasValue = NO;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (hasValue == NO) {
            hasValue = YES;
        }
        [str appendFormat:@"\t%@,\n", obj];
    }];
    [str appendString:@"]"];
    if (hasValue == YES) {
        // 查出最后一个,的范围
        NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    return str;
}

@end
