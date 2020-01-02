//
//  UILabel+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)

+ (instancetype)labWithFrame:(CGRect)frame
                       title:(NSString *)title
                        font:(UIFont *)font
                   textColor:(UIColor *)textColor;

+ (instancetype)labWithFrame:(CGRect)frame
                       title:(NSString *)title
                    fontSize:(CGFloat)fontSize
                   textColor:(UIColor *)textColor;

/** auto fit width with LabelFont and height */

- (CGFloat)heightToFit;

- (CGFloat)heightToFitIsAttr;

- (CGFloat)heightToFitWithSpace:(CGFloat)space;

- (CGFloat)heightToFitIsAttrWithSpace:(CGFloat)space;

/** auto fit height with LabelFont and width */
- (CGFloat)widthToFit;

- (CGFloat)widthToFitWithSpace:(CGFloat)space;

/** longGestureCanCopy */
- (void)addLongGestureCopy;

@end
