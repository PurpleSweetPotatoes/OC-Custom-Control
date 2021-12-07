//// *******************************************
//  File Name:      WebProcessUnti.h
//  Author:         MrBai
//  Created Date:   2021/1/21
//
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
        
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

/// JS交互单元处理器基础类，使用其子类作为JS交互处理器
@interface WebProcessUnti : NSObject <WKScriptMessageHandler>

/// JS交互对应webview
@property (nonatomic, readonly, weak) WKWebView * webView;

/// JS交互对应控制器
@property (nonatomic, readonly, weak) UIViewController * ctrlVc;

/// JS拦截消息
@property (nonatomic, readonly, weak) WKScriptMessage * msg;

+ (instancetype)untiWithWebView:(WKWebView *)webV
                         ctrlVc:(UIViewController *)ctrlVc;

- (void)configWithWebView:(WKWebView *)webV
                   ctrlVc:(UIViewController *)ctrlVc;

/// JS交互拦截字典 key: 拦截方法名，value: 执行方法名
- (NSDictionary *)jsHandleInfos;

/// 移除前清理工作
- (void)clearnJSHandle NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
