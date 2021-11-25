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
@end

@implementation WebProcessUnti

- (void)dealloc {
    NSLog(@"%@ 释放", self);
}

+ (instancetype)untiWithWebView:(WKWebView *)webV ctrlVc:(UIViewController *)ctrlVc {
    WebProcessUnti * unti = [[self alloc] init];
    [unti configWithWebView:webV ctrlVc:ctrlVc];
    return unti;
}

- (void)configWithWebView:(WKWebView *)webV ctrlVc:(UIViewController *)ctrlVc {
    
    self.webView = webV;
    self.ctrlVc = ctrlVc;
    
    [self addJsHandler:webV.configuration.userContentController];
    [self.webView.untiList addObject:self];
}

- (void)addJsHandler:(WKUserContentController *)userCtrl {
    for (NSString * name in [self jsHandleNames]) {
        [userCtrl addScriptMessageHandler:self name:name];
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {}

- (NSArray *)jsHandleNames { return nil; }

@end
