//
//  NSAttributedString+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/3/30.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "NSAttributedString+Custom.h"

@implementation NSAttributedString (Custom)

+ (instancetype)attributStrWithText:(NSString *)text
                               font:(UIFont *)font
                              color:(UIColor *)color {
    return [[NSAttributedString alloc] initWithString:text  attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font}];
}

+ (instancetype)imgStrWithImg:(UIImage *)img font:(UIFont *)font {
    return [self imgStrWithImg:img font:font spac:0];
}

+ (instancetype)imgStrWithImg:(UIImage *)img font:(UIFont *)font spac:(CGFloat)spac {
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = img;
    //计算图片大小，与文字同高，按比例设置宽度
    CGFloat imgH = font.pointSize;
    CGFloat imgW = (img.size.width / img.size.height) * imgH;
    //计算文字padding-top ，使图片垂直居中
    CGFloat textPaddingTop = (font.lineHeight - font.pointSize) / 2;
    attach.bounds = CGRectMake(0, -textPaddingTop - spac, imgW, imgH);
    
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    return imgStr;
}

@end
