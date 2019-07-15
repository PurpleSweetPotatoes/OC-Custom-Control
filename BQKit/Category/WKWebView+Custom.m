//
//  WKWebView+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/7/15.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "WKWebView+Custom.h"

@implementation WKWebView (Custom)

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

@end
