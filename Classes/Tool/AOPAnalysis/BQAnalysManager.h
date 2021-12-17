// *******************************************
//  File Name:      BQAnalysManager.h       
//  Author:         MrBai
//  Created Date:   2021/2/4 3:49 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AnalysBlock)(NSDictionary * info);

@interface BQAnalysManager : NSObject

/// 开启埋点回调
/// @param block 回调方法, identifier:回调标示符 info:对应上报数据
+ (void)configAnalysBlock:(AnalysBlock)block;

/// 埋点数据传递
/// @param info 埋点信息
+ (void)analysModel:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
