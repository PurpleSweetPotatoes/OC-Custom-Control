//
//  BQTextView.m
//  Test
//
//  Created by MrBai on 17/2/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQTextView.h"
#import "UIView+Custom.h"

@interface BQTextView ()<UITextViewDelegate>
{
    CGFloat _lastHeight;
    UILabel * placeHolderLabel;
}

@property (nonatomic, assign) CGFloat  minHeight;

@end

@implementation BQTextView

@synthesize placeholder = _placeholder;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configTextView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configTextView];
}

- (void)configTextView {
    self.maxHeight = [UIScreen mainScreen].bounds.size.height;
    self.maxCharNum = 1000;
    self.minHeight = -1;
    self.delegate = self;
    self.font = [UIFont systemFontOfSize:15];
    self.autoAdjustHeight = NO;
    _lastHeight = self.bounds.size.height;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.autoAdjustHeight) {
        
        if (self.contentSize.height <= self.maxHeight && self.contentSize.height > self.minHeight) {
            [self lastHeightCompareWithHeight:self.contentSize.height];
        } else if (self.contentSize.height <= self.minHeight) {
            [self lastHeightCompareWithHeight:self.minHeight];
        }
        
        if (self.height < self.minHeight) {
            self.height = self.minHeight;
        }
    }
    
    if (placeHolderLabel.alpha != 0) {
        CGFloat offsetLeft = self.textContainerInset.left + self.textContainer.lineFragmentPadding;
        CGFloat offsetRight = self.textContainerInset.right + self.textContainer.lineFragmentPadding;
        placeHolderLabel.frame = CGRectMake(offsetLeft, 0, self.width - offsetLeft - offsetRight, self.minHeight < self.height ? self.minHeight : self.height);
    }
}


- (void)lastHeightCompareWithHeight:(CGFloat)height {
    self.height = height;
    if (_lastHeight != height) {
        _lastHeight = height;
        if ([self.ourDelegate respondsToSelector:@selector(textViewDidAdjustFrame:)]    ) {
            [self.ourDelegate textViewDidAdjustFrame:self];
        }
    }
}

#pragma mark Set Method

-(void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    if ( placeHolderLabel == nil ) {
        placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.font = self.font;
        placeHolderLabel.textAlignment = self.textAlignment;
        placeHolderLabel.backgroundColor = [UIColor clearColor];
        placeHolderLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        placeHolderLabel.alpha = 0;
        [self addSubview:placeHolderLabel];
    }
    
    placeHolderLabel.text = self.placeholder;
    [self refreshPlaceholder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    placeHolderLabel.textColor = placeholderColor;
    [self refreshPlaceholder];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self refreshPlaceholder];
}

-(void)setFont:(UIFont *)font {
    [super setFont:font];
    placeHolderLabel.font = self.font;
    CGRect rect = [@"行" boundingRectWithSize:CGSizeMake(100, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    self.minHeight = ceil(self.textContainerInset.top + self.textContainerInset.bottom + rect.size.height);
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    placeHolderLabel.textAlignment = textAlignment;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(id<UITextViewDelegate>)delegate {
    [self refreshPlaceholder];
    return [super delegate];
}

#pragma mark 刷新占位符

- (void)refreshPlaceholder {
    if([[self text] length]){
        [placeHolderLabel setAlpha:0];
    } else {
        [placeHolderLabel setAlpha:1];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ((self.returnKeyType == UIReturnKeySend || self.returnKeyType == UIReturnKeyDone) && [text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
        if ([self.ourDelegate respondsToSelector:@selector(textViewShouldSend)]) {
            [self.ourDelegate textViewShouldSend];
        }
        return NO;
    }
    
    if (text.length == 0 || [textView.text length] < self.maxCharNum) {
        return YES;
    }
    
    if ([self.ourDelegate respondsToSelector:@selector(textViewDidHasMaxNum:)]) {
        [self.ourDelegate textViewDidHasMaxNum:self];
    }
    
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > self.maxCharNum) {
        textView.text = [textView.text substringToIndex:self.maxCharNum];
    }
    [self refreshPlaceholder];
    if ([self.ourDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.ourDelegate textViewDidChange:self];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.ourDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.ourDelegate textViewShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(BQTextView *)textView {
    if ([self.ourDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.ourDelegate textViewShouldEndEditing:self];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(BQTextView *)textView {
    if ([self.ourDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.ourDelegate textViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(BQTextView *)textView {
    if ([self.ourDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.ourDelegate textViewDidEndEditing:self];
    }
}

@end
