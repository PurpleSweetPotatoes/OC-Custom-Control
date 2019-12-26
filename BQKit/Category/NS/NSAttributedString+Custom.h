//
//  NSAttributedString+Custom.h
//  tianyaTest
//
//  Created by baiqiang on 2019/3/30.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Custom)

/** 初始化attributeStr */
+ (instancetype)attributStrWithText:(NSString *)text
                               font:(UIFont *)font
                              color:(UIColor *)color;

/** 图片Attribute */
+ (instancetype)imgStrWithImg:(UIImage *)img
                         imgH:(CGFloat)imgH;

/** 图片Attribute, spac: 图片向上偏移量 */
+ (instancetype)imgStrWithImg:(UIImage *)img
                         imgH:(CGFloat)imgH
                         spac:(CGFloat)spac;
@end

@interface NSMutableAttributedString (Custom)

/** 初始化attributeStr */
+ (instancetype)attributStrWithText:(NSString *)text
                               font:(UIFont *)font
                              color:(UIColor *)color;

/** 图片Attribute */
+ (instancetype)imgStrWithImg:(UIImage *)img
                         imgH:(CGFloat)imgH;

/** 图片Attribute, spac: 图片向上偏移量 */
+ (instancetype)imgStrWithImg:(UIImage *)img
                         imgH:(CGFloat)imgH
                         spac:(CGFloat)spac;

@end


NS_ASSUME_NONNULL_END
