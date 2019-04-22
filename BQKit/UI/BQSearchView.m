//
//  BQSearchView.m
//  tianyaTest
//
//  Created by baiqiang on 2019/2/24.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "BQSearchView.h"

@interface BQSearchView ()
<
UITextFieldDelegate
>
@property (nonatomic, strong) UIImageView * leftImgView;
@property (nonatomic, strong) UIImageView * rightImgView;
@property (nonatomic, copy) void (^tapAction)(BQSearchView * _Nonnull);
@end


@implementation BQSearchView

- (instancetype)initWithFrame:(CGRect)frame leftView:(UIView *)leftView {
    BQSearchView * backView = [self initWithFrame:frame];
    backView.leftView = leftView;
    return backView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.backgroundColor = [UIColor whiteColor];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.font = [UIFont systemFontOfSize:15];
    self.returnKeyType = UIReturnKeyDone;
    self.delegate = self;
    [self configLeftImg:@"search_normal_icon"];
    [self configRightImg:@""];
}

- (void)configLeftImg:(NSString *)imgName {
    self.leftImgView.image = [UIImage imageNamed:imgName];
    self.leftView = self.leftImgView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)configRightImg:(NSString *)imgName {
    self.rightImgView.image = [UIImage imageNamed:imgName];
    self.rightView = self.rightImgView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField endEditing:YES];
        return NO;
    }
    return YES;
}

#pragma mark - Action

- (void)addTapAction:(nullable void (^)(BQSearchView * _Nonnull))handler {
    self.tapAction = handler;
    
    [self addTarget:self action:@selector(tapUpInsideAction:) forControlEvents:UIControlEventEditingDidBegin];
    
}

- (void)removeTapAction {
    
    if (self.tapAction) {
        self.tapAction = nil;
        [self removeTarget:self action:@selector(tapUpInsideAction:) forControlEvents:UIControlEventEditingDidBegin];
    }
    
}

- (void)tapUpInsideAction:(id) sender {
    [self resignFirstResponder];
    if (self.tapAction) {
        self.tapAction(self);
    }
}

# pragma mark - PlaceHolder

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    [self configPlaceHolder];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    [self configPlaceHolder];
}

- (void)configPlaceHolder {
    if (self.placeHolderColor) {
        if (self.placeholder) {
            NSAttributedString * str = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:self.placeHolderColor}];
            self.attributedPlaceholder = str;
        }
    }
}

#pragma mark - Get & Set

- (UIImageView *)leftImgView {
    if (_leftImgView == nil) {
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        _leftImgView = imgView;
    }
    return _leftImgView;
}

- (UIImageView *)rightImgView {
    if (_rightImgView == nil) {
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImgView = imgView;
    }
    return _rightImgView;
}

- (BOOL)hasTapAction {
    return self.tapAction ? YES : NO;
}

@end
