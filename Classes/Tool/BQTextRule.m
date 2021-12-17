// *******************************************
//  File Name:      BQTextRule.m       
//  Author:         MrBai
//  Created Date:   2020/3/21 9:47 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQTextRule.h"

#import "NSString+Custom.h"
#import <objc/runtime.h>

@interface BQTextRule ()
@end

@implementation BQTextRule

+ (instancetype)textRuleType:(BQTextRuleType)type {
    BQTextRule * rule = [[BQTextRule alloc] init];
    rule.maxLength = 0;
    rule.type = type;
    if (type == BQTextRuleType_Price) {
        rule.precision = 2;
    }
    return rule;
}

- (void)textFieldTextDidChange:(UITextField *)tf {
    if (!tf.rule ||
        tf.text.length == 0 ||
        tf.markedTextRange != nil)
        return;
    
    switch (self.type) {
        case BQTextRuleType_Num:
            [self reserveNum:tf];
            break;
        case BQTextRuleType_Char:
            [self reserveChar:tf];
            break;
        case BQTextRuleType_NumChar:
            [self reserveNumChar:tf];
            break;
        case BQTextRuleType_Chinese:
            [self reserveChinese:tf];
            break;
        case BQTextRuleType_Price:
            [self reservePrice:tf];
            break;
        default:
            break;
    }
    
    if (self.clearSpace) {
        tf.text = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if (self.maxLength > 0 && tf.text.length > self.maxLength) {
        tf.text = [tf.text substringToIndex:self.maxLength];
    }
    
    if (self.lowText) {
        tf.text = [tf.text lowercaseString];
    }
    
    if (self.upText) {
        tf.text = [tf.text uppercaseString];
    }
    
}

- (void)reserveNum:(UITextField *)tf {
    tf.text = [tf.text deleteCharset:@"[^0-9]"];
}

- (void)reserveChar:(UITextField *)tf {
    tf.text = [tf.text deleteCharset:@"[^a-zA-Z]"];
}

- (void)reserveNumChar:(UITextField *)tf {
    tf.text = [tf.text deleteCharset:@"[^a-zA-Z0-9]"];
}

- (void)reserveChinese:(UITextField *)tf {
    tf.text = [tf.text deleteCharset:@"[^\u4e00-\u9fa5]"];
}

- (void)reservePrice:(UITextField *)tf {
    if (self.precision > 0 && tf.text.length > 0) { //小数点位数检查
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
            if (preci.length > self.precision) {
                preci = [preci substringToIndex:self.precision];
            }
            tf.text = [NSString stringWithFormat:@"%@.%@",tf.text, preci];
        }
    }
}

@end


@implementation UITextField(BQTextRule)

- (BQTextRule *)rule {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRule:(BQTextRule *)rule {
    
    BQTextRule * pre = objc_getAssociatedObject(self, _cmd);
    if (pre) {
        [self removeTarget:pre action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    [self addTarget:rule action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    objc_setAssociatedObject(self, @selector(rule), rule, OBJC_ASSOCIATION_RETAIN);
}

@end
