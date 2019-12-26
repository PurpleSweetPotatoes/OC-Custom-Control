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

+ (instancetype)imgStrWithImg:(UIImage *)img imgH:(CGFloat)imgH {
    return [self imgStrWithImg:img imgH:imgH spac:0];
}

+ (instancetype)imgStrWithImg:(UIImage *)img imgH:(CGFloat)imgH spac:(CGFloat)spac {
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = img;
    //计算图片大小，与文字同高，按比例设置宽度
    CGFloat imgW = (img.size.width / img.size.height) * imgH;
    //计算文字padding-top ，使图片垂直居中
    UIFont * font = [UIFont systemFontOfSize:imgH];
    CGFloat textPaddingTop = (font.lineHeight - imgH) / 2;
    attach.bounds = CGRectMake(0, -textPaddingTop - spac, imgW, imgH);
    
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    return imgStr;
}

@end


@implementation NSMutableAttributedString (Custom)

/** 初始化attributeStr */
+ (instancetype)attributStrWithText:(NSString *)text
                               font:(UIFont *)font
                              color:(UIColor *)color {
    return [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributStrWithText:text font:font color:color]];
}

/** 图片Attribute */
+ (instancetype)imgStrWithImg:(UIImage *)img
                         imgH:(CGFloat)imgH {
    return [self imgStrWithImg:img imgH:imgH spac:0];
}

/** 图片Attribute, spac: 图片向上偏移量 */
+ (instancetype)imgStrWithImg:(UIImage *)img
                         imgH:(CGFloat)imgH
                         spac:(CGFloat)spac {
    return [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString imgStrWithImg:img imgH:imgH spac:spac]];
}

@end
