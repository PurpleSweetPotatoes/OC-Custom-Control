//
//  UIColor+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (hexColor)

+ (UIColor *)randomColor {
    CGFloat red = arc4random() % 256 / 255.0;
    CGFloat green = arc4random() % 256 / 255.0;
    CGFloat blue = arc4random() % 256 / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)colorFromHex:(NSInteger)hex {
    CGFloat red = ((hex & 0xFF0000) >> 16) / 255.0;
    CGFloat green = ((hex & 0xFF00) >> 8) / 255.0;
    CGFloat blue = (hex & 0xFF) / 255.0;
    return [self colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return  [self colorFromHex:rgbValue];
}

- (CGFloat)red {
    return [[self rgbaArray][0] floatValue];
}

- (CGFloat)green {
    return [[self rgbaArray][1] floatValue];
}

- (CGFloat)blue {
    return [[self rgbaArray][2] floatValue];
}

- (NSString *)hexString {
    
    NSArray *colorArray    = [self rgbaArray];
    int r = [colorArray[0] floatValue] * 255;
    int g = [colorArray[1] floatValue] * 255;
    int b = [colorArray[2] floatValue] * 255;
    
    NSString *red = [NSString stringWithFormat:@"%02x", r];
    NSString *green = [NSString stringWithFormat:@"%02x", g];
    NSString *blue = [NSString stringWithFormat:@"%02x", b];
    
    return [NSString stringWithFormat:@"#%@%@%@", red, green, blue];
}

- (NSArray *)rgbaArray {
    CGFloat r = 0, g = 0, b = 0, a = 0;
    
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self getRed:&r green:&g blue:&b alpha:&a];
    }
    
    return @[@(r),@(g),@(b),@(a)];
}

@end
