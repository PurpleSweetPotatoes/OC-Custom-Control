//// *******************************************
//  File Name:      WebProcessUnti.m
//  Author:         MrBai
//  Created Date:   2021/1/21
//
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
        

#import "WebProcessUnti.h"
#import "WKWebView+Custom.h"

@interface WebProcessUnti ()
@property (nonatomic, weak) WKWebView * webView;
@property (nonatomic, weak) UIViewController * ctrlVc;
@property (nonatomic, weak) UIViewController * weakVc;
@property (nonatomic, weak) WKScriptMessage * msg;
@end

@implementation WebProcessUnti

+ (instancetype)untiWithWebView:(WKWebView *)webV ctrlVc:(UIViewController *)ctrlVc {
    WebProcessUnti * unti = [[self alloc] init];
    [unti configWithWebView:webV ctrlVc:ctrlVc];
    return unti;
}

- (void)configWithWebView:(WKWebView *)webV ctrlVc:(UIViewController *)ctrlVc {
    
    self.webView = webV;
    self.ctrlVc = ctrlVc;
    
    if (webV.configuration.userContentController == nil) {
        webV.configuration.userContentController = [[WKUserContentController alloc] init];
    }
    
    [self addJsHandler:webV.configuration.userContentController];
    [self.webView.untiList addObject:self];
}

- (void)addJsHandler:(WKUserContentController *)userCtrl {
    for (NSString * name in [self jsHandleNames]) {
        [userCtrl addScriptMessageHandler:self name:name];
    }
}

- (void)clearnJSHandle {
    for (NSString * name in [self jsHandleNames]) {
        [self.webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    self.msg = message;
    NSString * selName = [[self jsHandleInfos] stringValueForKey:message.name];
    NSLog(@"准备调用方法: %@", selName);
    SEL sel = NSSelectorFromString(selName);
    if ([self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:sel];
#pragma clang diagnostic pop
    } else {
        NSAssert(0, @"未实现方法: %@", selName);
    }

}

- (NSDictionary *)jsHandleInfos { return nil; }

- (NSArray *)jsHandleNames {
    return [[self jsHandleInfos] allKeys];
}

@end
