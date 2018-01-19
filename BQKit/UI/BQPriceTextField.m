//
//  BQPriceTextField.m
//  Test-demo
//
//  Created by baiqiang on 2018/1/10.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "BQPriceTextField.h"

@interface BQPriceTextField() <UITextFieldDelegate>

@property (nonatomic, assign) BOOL isHaveDian;

@end

@implementation BQPriceTextField



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configTextFieldInfo];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configTextFieldInfo];
}

- (void)configTextFieldInfo {
    self.precision = 2;
    self.delegate = self;
    self.keyboardType = UIKeyboardTypeDecimalPad;
    self.textAlignment = NSTextAlignmentCenter;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        // 不能输入.0-9以外的字符,存在2个小数点
        if (!((single >= '0' && single <= '9') || single == '.') || (self.isHaveDian && single == '.')) {
            return NO;
        }
        
        if (textField.text.length == 0) {
            if (single == '0') {
                textField.text = @"0.";
                return NO;
            }else if (single == '.') {
                textField.text = @"0";
            }
        }
        
        if (!self.isHaveDian && [textField.text hasPrefix:@"0"] && single != '.') {
            textField.text = @"0.";
        }
        
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSArray * strArr = [textField.text componentsSeparatedByString:@"."];
            if ([strArr.lastObject length] >= self.precision) {
                return NO;
            }
        }
        
    }
    
    return YES;
}

// 限制修改
- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    [super setKeyboardType:UIKeyboardTypeDecimalPad];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    [super setDelegate:self];
}

@end
