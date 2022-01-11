//
//  UIColor+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Custom)

/// rgb中red色值
@property (nonatomic, readonly, assign) CGFloat  red;
/// rgb中green色值
@property (nonatomic, readonly, assign) CGFloat  green;
/// rgb中blue色值
@property (nonatomic, readonly, assign) CGFloat  blue;
/// 对应hex色值字符串
@property (nonatomic, readonly, strong) NSString * hexString;

/// 随机颜色
+ (UIColor *)randomColor;

/// 根据hex数值生成颜色
/// @param hex 颜色数值
+ (UIColor *)hex:(NSInteger)hex;

/// 根据hex数值字符串生成颜色
/// @param hexString 颜色数值字符串
+ (UIColor *)hexstr:(NSString *)hexString;

/// 转化为rgb565数据
- (NSString *)toRGB565;

@end
