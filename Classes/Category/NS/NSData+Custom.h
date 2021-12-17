//
//  NSData+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Custom)

#pragma mark - 钥匙串

/**  利用钥匙串保存数据 */
- (BOOL)saveToKeychain;

/**  加载钥匙串数据 */
+ (NSData * _Nullable)loadKeyChainValue;

/**  删除钥匙串数据 */
+ (BOOL)deleteKeyChainValue;

#pragma mark - Data from int

- (int)kkl_intValue;
- (long)kkl_longValue;
- (float)kkl_floatValue;

+ (instancetype)dataWithInt:(int)i;
+ (instancetype)dataWithFloat:(float)f;
+ (instancetype)dataWithLong:(long)l;

@end
