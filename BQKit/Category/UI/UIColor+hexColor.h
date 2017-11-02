//
//  UIColor+hexColor.h
//  Test
//
//  Created by MrBai on 2017/6/28.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexColor)

@property (nonatomic, readonly, assign) CGFloat red;
@property (nonatomic, readonly, assign) CGFloat green;
@property (nonatomic, readonly, assign) CGFloat blue;
@property (nonatomic, readonly, strong) NSString * hexString;

+ (UIColor *)randomColor;
+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
