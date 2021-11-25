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
                           fontSize:(CGFloat)fontSize
                              color:(UIColor *)color {
    return [[NSAttributedString alloc] initWithString:text  attributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}];
}

+ (instancetype)imgStrWithImg:(UIImage *)img fontSize:(CGFloat)fontSize {
    return [self imgStrWithImg:img fontSize:(CGFloat)fontSize spac:0];
}

+ (instancetype)imgStrWithImg:(UIImage *)img fontSize:(CGFloat)fontSize spac:(CGFloat)spac {
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = img;
    //计算文字padding-top ，使图片垂直居中
    UIFont * font = [UIFont systemFontOfSize:fontSize];
    CGFloat textPaddingTop = (font.lineHeight - img.size.height) / 2;
    attach.bounds = CGRectMake(0, -textPaddingTop - spac, img.size.width, img.size.height);
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    return imgStr;
}

@end


@implementation NSMutableAttributedString (Custom)

/** 初始化attributeStr */
+ (instancetype)attributStrWithText:(NSString *)text
                           fontSize:(CGFloat)fontSize
                              color:(UIColor *)color {
    return [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributStrWithText:text fontSize:fontSize color:color]];
}

/** 图片Attribute */
+ (instancetype)imgStrWithImg:(UIImage *)img
                     fontSize:(CGFloat)fontSize {
    return [self imgStrWithImg:img fontSize:fontSize spac:0];
}

/** 图片Attribute, spac: 图片向上偏移量 */
+ (instancetype)imgStrWithImg:(UIImage *)img
                     fontSize:(CGFloat)fontSize
                         spac:(CGFloat)spac {
    return [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString imgStrWithImg:img fontSize:fontSize spac:spac]];
}

@end
