// *******************************************
//  File Name:      BQUrlHandle.m       
//  Author:         MrBai
//  Created Date:   2020/4/17 8:54 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQUrlHandle.h"

#import "NSDictionary+Custom.h"
#import "NSObject+Custom.h"
#import "NSString+Custom.h"

static BQUrlReqBlock _completedBlock;
static NSString * _wxId;
@implementation BQUrlHandle

+ (void)aliReqStr:(NSString *)orderStr fromScheme:(NSString *)schemeStr completed:(BQUrlReqBlock)completedBlock {
    
    if (orderStr == nil) {
        NSLog(@"缺少orderStr参数");
        return;
    }
    
    if (schemeStr == nil) {
        NSLog(@"缺少schemeStr参数");
        return;
    }
    
    NSDictionary * dic = @{@"fromAppUrlScheme":schemeStr,@"requestType":[NSString stringWithFormat:@"SafeP%@",@"ay"],@"dataString":orderStr};
    
    NSString * diccEncodeString = dic.jsonString.urlEncoded;
    NSString * openUrl = [NSString stringWithFormat:@"a%@ay://a%@yclient/?%@",@"lip",@"lipa",diccEncodeString];
    
    _completedBlock = [completedBlock copy];
    
    [self openUrlStr:openUrl];
}

+ (void)wxReq:(BQwxReq *)req completed:(BQUrlReqBlock)completedBlock {
    
    _wxId = req.openID;
    
    req.package = [req.package stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    NSString * parameter = [NSString stringWithFormat:@"nonceStr=%@&package=%@&partnerId=%@&pre%@yId=%@&timeStamp=%d&sign=%@&signType=%@",req.nonceStr,req.package,req.partnerId,@"pa",req.prepyId,(unsigned int)req.timeStamp,req.sign,@"SHA1"];
    NSString * openUrl = [NSString stringWithFormat:@"w%@pp/%@/p%@/?%@",@"eixin://a",req.openID,@"ay",parameter];
    _completedBlock = [completedBlock copy];
    [self openUrlStr:openUrl];
}

+ (void)openUrlStr:(NSString *)openUrl {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl] options:@{} completionHandler:^(BOOL success) {
            if (!success) {
                NSLog(@"打开应用失败!");
            }
        }];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url options:(nullable NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSString * urlStr = url.absoluteString.urlDecoded;
    NSString * lastStr = @"ay/";
    if ([urlStr containsString:[NSString stringWithFormat:@"//safep%@",lastStr]]) {
        urlStr = [[urlStr componentsSeparatedByString:@"?"] lastObject];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"ResultStatus" withString:@"resultStatus"];
        NSDictionary * dic = urlStr.jsonDic;
        NSDictionary * resultDic = [dic dicValueForKey:@"memo"];
        
        if(_completedBlock && resultDic[@"resultStatus"]) {
            _completedBlock([resultDic[@"resultStatus"] integerValue]);
        }
        
        return YES;
    } else if (_wxId && [urlStr containsString:_wxId] && [urlStr containsString:[NSString stringWithFormat:@"//p%@",lastStr]]) {
        NSArray *retArray =  [urlStr componentsSeparatedByString:@"&"];
        NSInteger errCode = -1;
        for (NSString *retStr in retArray) {
            if([retStr containsString:@"ret="]){
                errCode = [[retStr stringByReplacingOccurrencesOfString:@"ret=" withString:@""] integerValue];
            }
        }
        
        if(_completedBlock) {
            _completedBlock(errCode);
        }
        
        return YES;
    }
    
    return NO;
}

@end
