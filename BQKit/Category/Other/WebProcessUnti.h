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

/// JS交互单元处理器父类
/// 继承该类使用子类作为JS交互处理器
/// 切记在webView移除时手动调用clearJSHandler
@interface WebProcessUnti : NSObject <WKScriptMessageHandler>

/// JS交互对应webview
@property (nonatomic, readonly, weak) WKWebView * webView;

/// JS交互对应控制器
@property (nonatomic, readonly, weak) UIViewController * ctrlVc;

+ (instancetype)untiWithWebView:(WKWebView *)webV
                         ctrlVc:(UIViewController *)ctrlVc;

- (void)configWithWebView:(WKWebView *)webV
                   ctrlVc:(UIViewController *)ctrlVc;

/// 相当于虚函数
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message;

/// 清楚JS交互方法拦截
- (void)clearJSHandler;

/// JS交互拦截方法名列表
- (NSArray *)jsHandleNames;

@end

NS_ASSUME_NONNULL_END
