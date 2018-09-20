//
//  NSObject+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Custom)

/**
 方法替换
 
 @param target 目标方法
 @param repalce 替换方法
 @return 替换结果
 */
+ (BOOL)exchangeMethod:(SEL)target with:(SEL)repalce;

/**  归档操作 */
- (void)encodeInfoWithCoder:(NSCoder *)aCoder;
/**  解档操作 */
- (void)unencodeWithCoder:(NSCoder *)aDecoder;

/**  将对象转化为字符串 */
- (NSString *)jsonString;

#pragma mark - Associate value to Instance

- (void)setAssociateValue:(nullable id)value withKey:(void *)key;
- (void)setAssociateWeakValue:(nullable id)value withKey:(void *)key;
- (nullable id)getAssociatedValueForKey:(void *)key;
- (void)removeAssociatedValues;

@end
