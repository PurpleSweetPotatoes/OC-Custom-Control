//
//  UILabel+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)

/// 快速创建文本视图
/// @param frame 位置
/// @param title 文本
/// @param font 字体
/// @param textColor 颜色
+ (instancetype)labWithFrame:(CGRect)frame
                       title:(NSString *)title
                        font:(UIFont *)font
                   textColor:(UIColor *)textColor;

/// 快速创建文本视图
/// @param frame 位置
/// @param title 文本
/// @param fontSize 字体大小
/// @param textColor 颜色
+ (instancetype)labWithFrame:(CGRect)frame
                       title:(NSString *)title
                    fontSize:(CGFloat)fontSize
                   textColor:(UIColor *)textColor;

/// 根据文本自动调节高度
- (CGFloat)heightToFit;

/// 根据文本自动调节高度
/// @param space 追加高度
- (CGFloat)heightToFitWithSpace:(CGFloat)space;

/// 根据属性文本自动调节高度
- (CGFloat)heightToFitIsAttr;

/// 根据属性文本自动调节高度
/// @param space 追加高度
- (CGFloat)heightToFitIsAttrWithSpace:(CGFloat)space;

/// 根据文本自动调节宽度
- (CGFloat)widthToFit;

/// 根据文本自动调节宽度
/// @param space 追加宽度
- (CGFloat)widthToFitWithSpace:(CGFloat)space;

/// 根据属性文本自动调节宽度
- (CGFloat)widthToFitIsAttr;

/// 根据属性文本自动调节宽度
/// @param space 追加宽度
- (CGFloat)widthToFitIsAttrWithSpace:(CGFloat)space;

/// 配置文本并设置行高
/// @param text 文本
/// @param space 行高
- (void)configText:(NSString *)text lineSpace:(CGFloat)space;

/// 添加长按复制弹框
- (void)addLongGestureCopy;

@end
