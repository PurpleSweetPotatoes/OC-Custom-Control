//
//  UIFont+adjust.m
//  Test
//
//  Created by MrBai on 2017/6/28.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIFont+adjust.h"
#import "BQScreenAdaptation.h"

@implementation UIFont (adjust)
+ (UIFont *)navTitleFont {
    return [self adjustFont:36];
}
+ (UIFont *)normalTextFont {
    return [self adjustFont:32];
}
+ (UIFont *)midTextFont {
    return [self adjustFont:28];
}
+ (UIFont *)smallTextFont {
    return [self adjustFont:26];
}
+ (UIFont *)adjustFont:(CGFloat)size {
    return [self systemFontOfSize:BQAdaptation(size)];
}
@end
