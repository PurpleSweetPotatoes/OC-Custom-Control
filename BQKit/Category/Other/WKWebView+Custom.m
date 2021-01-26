//
//  WKWebView+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/7/15.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "WKWebView+Custom.h"
#import <objc/runtime.h>

@implementation WKWebView (Custom)

- (void)removeFromSuperview {
    [super removeFromSuperview];
    NSLog(@"准备移除webView，开始清理JS交互拦截");
    if (self.isLoading) {
        [self stopLoading];
    }

    WKUserContentController * userCtrl = self.configuration.userContentController;
    // 清除UserScript
    [userCtrl removeAllUserScripts];
    
    // 释放对应JS交互处理器
    for (WebProcessUnti * unti in self.untiList) {
        [unti clearnJSHandle];
    }
    [self.untiList removeAllObjects];
}

- (void)textAutoFit {
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    [self addJs:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd];
}

- (void)imgAutoFit {
    [self imgAutoFitWithSpace:10];
}

- (void)imgAutoFitWithSpace:(CGFloat)space {
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, self.bounds.size.width - space * 2];
    [self addJs:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd];
}

- (void)addJs:(NSString *)js injectionTime:(WKUserScriptInjectionTime)time {
    
    if (!self.configuration.userContentController) {
        self.configuration.userContentController = [[WKUserContentController alloc] init];
    }
    
    WKUserScript * textScript = [[WKUserScript alloc] initWithSource:js injectionTime:time forMainFrameOnly:YES];
    [self.configuration.userContentController addUserScript:textScript];
}

- (NSMutableArray *)untiList {
    NSMutableArray * arr = objc_getAssociatedObject(self, _cmd);
    if (arr == nil) {
        arr = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, arr, OBJC_ASSOCIATION_RETAIN);
    }
    return arr;
}

- (void)configCookie:(NSDictionary *)dic {
    NSMutableString * cookie = [NSMutableString string];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [cookie appendFormat:@"document.cookie='%@=%@';",key, obj];
    }];
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [self.configuration.userContentController addUserScript:cookieScript];
}

+ (WKWebViewConfiguration *)configWkWebOptions {
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.processPool = [WKWebView sharedProcessPool];
    
    // JS配置
    WKPreferences *preference = [[WKPreferences alloc]init];
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    if (@available(iOS 14.0, *)) {
        config.defaultWebpagePreferences.allowsContentJavaScript = YES;
    } else {
        preference.javaScriptEnabled = YES;
    }
    
    config.userContentController = [[WKUserContentController alloc] init];
    config.preferences = preference;
    
    if (@available(iOS 10.0, *)) {
        config.dataDetectorTypes = WKDataDetectorTypePhoneNumber;
    }
    
    return config;
}


+ (WKProcessPool*)sharedProcessPool {
    static WKProcessPool *processPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!processPool) {
            processPool = [[WKProcessPool alloc] init];
        }
    });
    return processPool;
}

@end
