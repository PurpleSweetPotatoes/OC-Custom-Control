//
//  UILabel+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (adjust)

/**
 auto fit width with LabelFont and height
 */
- (CGFloat)heightToFit;

/**
 auto fit height with LabelFont and width
 */
- (CGFloat)widthToFit;

@end

@interface UILabel (copy)

/**
 longGestureCanCopy
 */
- (void)addLongGestureCopy;

@end
