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

#pragma mark - 检查配置规则

- (void)startCheckConfig {
    [self addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 输入文本类型

- (InputTextType)type {
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setType:(InputTextType)type {
    objc_setAssociatedObject(self, @selector(type), @(type), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 价格文本限制

- (NSInteger)precision {
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setPrecision:(NSInteger)precision {
    self.keyboardType = UIKeyboardTypeDecimalPad;
    objc_setAssociatedObject(self, @selector(precision), @(precision), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 大小写限制

- (BOOL)upText {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setUpText:(BOOL)upText {
    objc_setAssociatedObject(self, @selector(upText), @(upText), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)lowText {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLowText:(BOOL)lowText {
    objc_setAssociatedObject(self, @selector(lowText), @(lowText), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - 最大长度

- (NSInteger)maxLength {
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setMaxLength:(NSInteger)maxLength {
    objc_setAssociatedObject(self, @selector(maxLength), @(maxLength), OBJC_ASSOCIATION_ASSIGN);
}

- (void)textDidChange:(UITextField *)tf {
    
    if (self.text.length == 0) {
        return;
    }
    
    switch (self.type) {
        case InputTextType_Num:
            [self reserveNum];
            break;
        case InputTextType_Char:
            [self reserveChar];
            break;
        case InputTextType_NumChar:
            [self reserveNumChar];
            break;
        case InputTextType_Chinese:
            [self reserveChinese];
            break;
        default:
            [self checkPrecision];
            break;
    }
    
    
    if (tf.maxLength > 0 && tf.text.length > tf.maxLength) { //最大长度检查
        tf.text = [tf.text substringToIndex:tf.maxLength];
    }
    
    if (self.lowText) {
        self.text = [self.text lowercaseString];
    }
    
    if (self.upText) {
        self.text = [self.text uppercaseString];
    }
}


/// 价格检查
- (void)checkPrecision {
    if (self.precision > 0 && self.text.length > 0) { //小数点位数检查
        NSArray * arr = [self.text componentsSeparatedByString:@"."];
        NSString * head  = arr[0];
        while ([head hasPrefix:@"0"]) {
            head = [head substringFromIndex:1];
        }
        if (head.length == 0) {
            head = @"0";
        }
        self.text = head;
        
        if (arr.count >= 2) {
            NSString * preci = arr[1];
            if (preci.length > self.precision) {
                preci = [preci substringToIndex:self.precision];
            }
            self.text = [NSString stringWithFormat:@"%@.%@",self.text, preci];
        }
    }
}

- (void)reserveNum {
    self.text = [self.text deleteCharset:@"[^0-9]"];
}

- (void)reserveNumChar {
    self.text = [self.text deleteCharset:@"[^a-zA-Z0-9]"];
}

- (void)reserveChinese {
    self.text = [self.text deleteCharset:@"[^\u4e00-\u9fa5]"];
}

- (void)reserveChar {
    self.text = [self.text deleteCharset:@"[^a-zA-Z]"];
}

@end
