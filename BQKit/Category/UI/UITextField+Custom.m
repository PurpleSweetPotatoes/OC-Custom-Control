// *******************************************
//  File Name:      UITextField+Custom.m       
//  Author:         MrBai
//  Created Date:   2020/3/10 3:00 PM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    
#import "UITextField+Custom.h"

#import "UIColor+Custom.h"
#import "UIImage+Custom.h"
#import <objc/runtime.h>

@interface UITextField()
@end

@implementation UITextField (Custom)

+ (NSString *)checkContent:(NSArray <UITextField *> *)arr {
    for (UITextField * tf in arr) {
        if (tf.text.length == 0) {
            return tf.placeholder;
        }
    }
    return @"";
}

#pragma mark - left or right view

- (void)addLeftSpace:(CGFloat)space {
    UIView * leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, space, self.bounds.size.height)];
    self.leftView = leftV;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addRightSpace:(CGFloat)space {
    UIView * rightV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, space, self.bounds.size.height)];
    self.rightView = rightV;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)addRightMoreImg {
    UIImage * img = [UIImage arrowImgWithFrame:CGRectMake(0, 0, 10, 15) color:[UIColor hexstr:@"c7c7cc"] lineWidth:2 direction:BQArrowDirection_Right];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, img.size.height, self.bounds.size.height)];
    CALayer * layer = [CALayer layer];
    layer.frame = CGRectMake(img.size.height - img.size.width, (self.bounds.size.height - img.size.height) * 0.5, img.size.width, img.size.height);
    layer.contents = (__bridge id)img.CGImage;
    [view.layer addSublayer:layer];
    self.rightView = view;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
