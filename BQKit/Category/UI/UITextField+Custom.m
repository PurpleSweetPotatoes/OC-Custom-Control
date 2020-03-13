// *******************************************
//  File Name:      UITextField+Custom.m       
//  Author:         MrBai
//  Created Date:   2020/3/10 3:00 PM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "UITextField+Custom.h"
#import "UIImage+Custom.h"

#import <objc/runtime.h>

@interface UITextField()
@property (nonatomic, assign) NSInteger  precision;
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

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setMaxLength:(NSInteger)maxLength {
    [self addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    objc_setAssociatedObject(self, @selector(maxLength), @(maxLength), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - PriceTF

+ (instancetype)priceTfWithFrame:(CGRect)frame precision:(NSInteger)precision {
    UITextField * tf = [[UITextField alloc] initWithFrame:frame];
    tf.keyboardType = UIKeyboardTypeDecimalPad;
    tf.returnKeyType = UIReturnKeyDone;
    tf.precision = precision;
    [tf addTarget:tf action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    return tf;
}

- (NSInteger)precision {
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setPrecision:(NSInteger)precision {
    objc_setAssociatedObject(self, @selector(precision), @(precision), OBJC_ASSOCIATION_ASSIGN);
}

- (void)textDidChange:(UITextField *)tf {
    
    if (tf.maxLength > 0 && tf.text.length > tf.maxLength) { //最大长度检查
        tf.text = [tf.text substringToIndex:tf.maxLength];
    }
    
    if (tf.precision > 0 && tf.text.length > 0) { //小数点位数检查
        NSArray * arr = [tf.text componentsSeparatedByString:@"."];
        NSString * head  = arr[0];
        while ([head hasPrefix:@"0"]) {
            head = [head substringFromIndex:1];
        }
        if (head.length == 0) {
            head = @"0";
        }
        tf.text = head;
        
        if (arr.count >= 2) {
            NSString * preci = arr[1];
            if (preci.length > tf.precision) {
                preci = [preci substringToIndex:tf.precision];
            }
            tf.text = [NSString stringWithFormat:@"%@.%@",tf.text, preci];
        }
    }
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
