//
//  UIFont+adjust.h
//  Test
//
//  Created by MrBai on 2017/6/28.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (adjust)
+ (UIFont *)navTitleFont;
+ (UIFont *)normalTextFont;
+ (UIFont *)midTextFont;
+ (UIFont *)smallTextFont;
+ (UIFont *)adjustFont:(CGFloat)size;
@end
