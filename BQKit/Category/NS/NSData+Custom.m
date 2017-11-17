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
