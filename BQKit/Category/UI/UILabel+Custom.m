//
//  UILabel+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UILabel+Custom.h"
#import "UIView+Custom.h"

@implementation UILabel (Custom)

+ (instancetype)createWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel * lab = [[UILabel alloc] initWithFrame:frame];
    lab.text = title;
    lab.font = font;
    lab.textColor = textColor;
    return lab;
}

- (CGFloat)heightToFit {
    return [self heightToFitWithSpace:0];
}

- (CGFloat)heightToFitWithSpace:(CGFloat)space {
    
    CGRect rect = CGRectZero;
    
    if (self.attributedText.length > 0) {
        rect = [self.attributedText boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    } else if (self.text.length > 0) {
        rect = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
    }
    
    self.sizeH = ceil(rect.size.height + space);
    return  self.sizeH;
}

- (CGFloat)widthToFit {
    return [self widthToFitWithSpace:0];
}

- (CGFloat)widthToFitWithSpace:(CGFloat)space {
    
    CGRect rect = CGRectZero;
    
    if (self.attributedText.length > 0) {
        rect = [self.attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    } else if (self.text.length > 0) {
        rect = [self.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
    }
    
    self.sizeW = ceil(rect.size.width + space);
    return  self.sizeW;
}

- (void)addLongGestureCopy {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer * gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:gester];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:));
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)handleTap:(UIGestureRecognizer*) recognizer {
    
    [self becomeFirstResponder];
    if ( [UIMenuController sharedMenuController].menuVisible == YES) {
        return;
    }
    
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    
}

- (void)copy:(id)sender {
    
    [self resignFirstResponder];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.text;
}

@end
