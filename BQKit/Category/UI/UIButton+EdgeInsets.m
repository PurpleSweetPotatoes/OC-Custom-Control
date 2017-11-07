//
//  UIButton+EdgeInsets.m
//  MyCocoPods
//
//  Created by baiqiang on 17/2/17.
//  Copyright © 2017年 baiqiang. All rights reserved.
//

#import "UIButton+EdgeInsets.h"
#import "UIView+Frame.h"

static const CGFloat spacing = 5;

@implementation UIButton (EdgeInsets)
- (void)adjustLabAndImageLocation:(BtnEdgeType)type {
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    
    if (type == EdgeTypeCenter) {
        return;
    }
    
    UIImageView * imgView = self.imageView;
    UILabel * titleLab = self.titleLabel;
    CGFloat width = self.frame.size.width;
    CGFloat imageLeft = 0;
    CGFloat imageTop = 0;
    CGFloat titleLeft = 0;
    CGFloat titleTop = 0;
    CGFloat titleRift = 0;
    
    if (type == EdgeTypeImageTopLabBottom) {
        imageLeft = (width - imgView.frame.size.width) * 0.5 - imgView.frame.origin.x;
        imageTop = spacing - imgView.frame.origin.y;
        titleLeft = (width - titleLab.frame.size.width) * 0.5 - titleLab.frame.origin.x - titleLab.frame.origin.x;
        titleTop = spacing * 2 + imgView.frame.size.height - titleLab.frame.origin.y;
        titleRift = -titleLeft - titleLab.frame.origin.x * 2;
    } else if (type == EdgeTypeLeft) {
        imageLeft = spacing - imgView.frame.origin.x;
        titleLeft = spacing * 2 + imgView.frame.size.width - titleLab.frame.origin.x;
        titleRift = -titleLeft;
    } else {
        titleLeft = width - CGRectGetMaxX(titleLab.frame) - spacing;
        titleRift = -titleLeft;
        imageLeft = width - imgView.right - spacing * 2 - titleLab.frame.size.width;
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageTop, imageLeft, -imageTop, -imageLeft);
    self.titleEdgeInsets = UIEdgeInsetsMake(titleTop, titleLeft, -titleTop, titleRift);
}
@end
