//
//  UIColor+hexColor.h
//  Test
//
//  Created by MrBai on 2017/6/28.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexColor)
+ (UIColor *)mainColor;
+ (UIColor *)textColor;
+ (UIColor *)lineColor;
+ (UIColor *)hexColor:(NSInteger)hex;
@end
