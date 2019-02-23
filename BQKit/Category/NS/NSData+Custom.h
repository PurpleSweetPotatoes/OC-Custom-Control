//
//  NSData+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (KeyChain)

/**  利用钥匙串保存数据 */
- (BOOL)saveToKeychain;

/**  加载钥匙串数据 */
+ (NSData * _Nullable)loadKeyChainValue;

/**  删除钥匙串数据 */
+ (BOOL)deleteKeyChainValue;

@end

@interface NSData (Number)
- (int)kkl_intValue;
+ (instancetype)dataWithInt:(int)i;
@end
