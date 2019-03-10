//
//  UILabel+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Custom)

/** auto fit width with LabelFont and height */
- (CGFloat)heightToFit;

- (CGFloat)heightToFitWithSpace:(CGFloat)space;

/** auto fit height with LabelFont and width */
- (CGFloat)widthToFit;

- (CGFloat)widthToFitWithSpace:(CGFloat)space;

/** longGestureCanCopy */
- (void)addLongGestureCopy;

@end
