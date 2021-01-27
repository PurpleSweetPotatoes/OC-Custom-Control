//
//  WKWebView+Custom.h
//  tianyaTest
//
//  Created by baiqiang on 2019/7/15.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "WebProcessUnti.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (Custom)

@property (nonatomic, readonly, strong) NSMutableArray<WebProcessUnti *> * untiList;

/// 适用于添加了WebProcessUnti处理器
- (void)clearnJSHandle;

/** 文本大小自适应 */
- (void)textAutoFit;

/** 图片宽度自适应 */
- (void)imgAutoFit;

/**
 图片宽度自适应
 @param space 间距(左右各一个)
 */
- (void)imgAutoFitWithSpace:(CGFloat)space;

/**
 注入js代码
 @param js js代码
 @param time 执行时间
 */
- (void)addJs:(NSString *)js injectionTime:(WKUserScriptInjectionTime)time;

/// 新增cookie
/// @param dic cookie字典
- (void)configCookie:(NSDictionary *)dic;

/// 快捷配置configuration
+ (WKWebViewConfiguration *)configWkWebOptions;

+ (WKProcessPool*)sharedProcessPool;

@end

NS_ASSUME_NONNULL_END
