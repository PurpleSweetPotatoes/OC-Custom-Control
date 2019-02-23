//
//  NSData+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "NSData+Custom.h"

@implementation NSData (KeyChain)

- (BOOL)saveToKeychain {
    NSMutableDictionary * keychainQuery = [self.class getKeychain];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:self forKey:(id)kSecValueData];
    OSStatus statu = SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    return statu == noErr;
}

+ (NSData *)loadKeyChainValue {
    NSMutableDictionary * keychainQuery = [self getKeychain];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef result = nil;
    SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&result);
    id data = nil;
    
    if (result != nil) {
        data = [NSData dataWithData:(__bridge NSData *)result];
        CFRelease(result);
    }
    
    return data;
}

+ (NSMutableDictionary *)getKeychain {
    NSString * serveice = [NSBundle mainBundle].bundleIdentifier;
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword,(id)kSecClass,serveice,(id)kSecAttrService,serveice,(id)kSecAttrAccount,(id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible, nil];
}

+ (BOOL)deleteKeyChainValue {
    NSMutableDictionary * keychainQuery = [self getKeychain];
    OSStatus statu =  SecItemDelete((CFDictionaryRef)keychainQuery);
    return statu == noErr;
}

@end

// 大端转小端
#define KKL_NTOH(z) sizeof(z) > 4 ? ntohll(z) : ntohl(z)
// 转换为小端 data
#define KKL_CONVERT_DATA(type, targetType) type length = (type)self.length; \
type difference = sizeof(type) - length; \
if (difference > sizeof(type)) { \
difference = 0; \
} \
if (length > sizeof(type)) { \
length = sizeof(type); \
} \
type zero = 0; \
NSMutableData *data = [NSMutableData dataWithBytes:&zero length:sizeof(type)]; \
[data replaceBytesInRange:NSMakeRange(difference, length) withBytes:self.bytes]; \
\
type z; \
[data getBytes:&z length:sizeof(type)]; \
type i = KKL_NTOH(z); \
data = [NSMutableData dataWithBytes:&i length:sizeof(type)]; \
targetType value; \
[data getBytes:&value length:sizeof(targetType)]; \
return value;


@implementation NSData (Number)

- (int)kkl_intValue {
    KKL_CONVERT_DATA(uint32_t, int);
}

- (long)kkl_longValue {
    KKL_CONVERT_DATA(uint64_t, long);
}

- (float)kkl_floatValue {
    KKL_CONVERT_DATA(uint32_t, float);
}

+ (instancetype)dataWithInt:(int)i {
    uint32_t z = KKL_NTOH(i);
    NSData *data = [NSData dataWithBytes:&z length:sizeof(i)];
    return data;
}

+ (instancetype)dataWithFloat:(float)f {
    NSData *data = [NSData dataWithBytes:&f length:sizeof(f)];
    int i = [data kkl_intValue];
    uint32_t z = KKL_NTOH(i);
    return [self dataWithInt:z];
}

- (instancetype)dataWithLong:(long)l {
    uint64_t z = KKL_NTOH(l);
    NSData *data = [NSData dataWithBytes:&z length:sizeof(l)];
    return data;
}
@end
