//
//  UIColor+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Custom)

@property (nonatomic, readonly, assign) CGFloat red;
@property (nonatomic, readonly, assign) CGFloat green;
@property (nonatomic, readonly, assign) CGFloat blue;
@property (nonatomic, readonly, strong) NSString * hexString;

+ (UIColor *)randomColor;
+ (UIColor *)hexColor:(NSInteger)hex;
+ (UIColor *)hexStringColor:(NSString *)hexString;

- (NSString *)toRGB565;

@end
