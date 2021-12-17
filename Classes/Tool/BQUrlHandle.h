// *******************************************
//  File Name:      BQUrlHandle.h       
//  Author:         MrBai
//  Created Date:   2020/4/17 8:54 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BQUrlReqBlock)(NSInteger code);

@class BQwxReq;

@interface BQUrlHandle : NSObject

+ (void)aliReqStr:(NSString *)orderStr fromScheme:(NSString *)schemeStr completed:(BQUrlReqBlock)completedBlock;

+ (void)wxReq:(BQwxReq *)req completed:(BQUrlReqBlock)completedBlock;

+ (BOOL)handleOpenURL:(NSURL *)url options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

@end

@interface BQwxReq : NSObject

/// 微信开放平台审核通过的应用APPID
@property (nonatomic, copy) NSString* openID;

/// 微信分配的商户号
@property (nonatomic, copy) NSString *partnerId;

/// 微信返回的交易会话ID
@property (nonatomic, copy) NSString *prepyId;

/// 随机串，防重发
@property (nonatomic, copy) NSString *nonceStr;

/// 时间戳，防重发
@property (nonatomic, assign) UInt32 timeStamp;

/// 扩展字段,暂填写固定值Sign=WXPay
@property (nonatomic, copy) NSString *package;

/// 签名
@property (nonatomic, copy) NSString *sign;
@end

NS_ASSUME_NONNULL_END
