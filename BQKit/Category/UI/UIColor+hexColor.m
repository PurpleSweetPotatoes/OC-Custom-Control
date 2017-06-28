//
//  UIColor+hexColor.m
//  Test
//
//  Created by MrBai on 2017/6/28.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIColor+hexColor.h"

@implementation UIColor (hexColor)
+ (UIColor *)mainColor {
    return [self hexColor:0xeda62f];
}
+ (UIColor *)textColor {
    return [self colorWithWhite:0.3 alpha:1];
}
+ (UIColor *)lineColor {
    return [self hexColor:0xfbfbfb];
}
+ (UIColor *)hexColor:(NSInteger)hex {
    CGFloat red = ((hex & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((hex & 0xFF00) >> 8) / 255.0;
    CGFloat blue = (hex & 0xFF) / 255.0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        return [self colorWithDisplayP3Red:red green:green blue:blue alpha:1];
    }else {
        return [self colorWithRed:red green:green blue:blue alpha:1];
    }
}
@end
