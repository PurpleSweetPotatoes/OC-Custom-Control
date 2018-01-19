//
//  BQTextView.m
//  Test
//
//  Created by MrBai on 17/2/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQTextView.h"

@interface BQTextView ()<UITextViewDelegate>

@property (nonatomic, copy) void (^maxNumBlock)();
@property (nonatomic, copy) void (^adjustFrameBlock)();
@property (nonatomic, assign) CGFloat lastHeight;
@end

@implementation BQTextView
{
    UILabel * placeHolderLabel;
}
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
    self.minHeight = 34;
    self.maxCharNum = 1000000;
    self.lastHeight = self.bounds.size.height;
    self.delegate = self;
    self.font = [UIFont systemFontOfSize:15];
    self.autoAdjustHeight = YES;
    [self resigstNotifi];
}

- (void)resigstNotifi {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidChangeNotification object:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.autoAdjustHeight) {
        CGRect frame = self.frame;
        frame.size = self.contentSize;
        if (self.minHeight >= 0 && frame.size.height < self.minHeight) {
            frame.size.height = self.minHeight;
        }
        self.frame = frame;
        
        if (self.lastHeight != frame.size.height) {
            self.lastHeight = frame.size.height;
            if (self.adjustFrameBlock) {
                self.adjustFrameBlock();
            }
        }
    }
    
    CGFloat offsetLeft = self.textContainerInset.left + self.textContainer.lineFragmentPadding;
    CGFloat offsetRight = self.textContainerInset.right + self.textContainer.lineFragmentPadding;
    CGFloat offsetTop = self.textContainerInset.top;
    CGFloat offsetBottom = self.textContainerInset.bottom;
    
    CGSize expectedSize = [placeHolderLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame)-offsetLeft-offsetRight, CGRectGetHeight(self.frame)-offsetTop-offsetBottom)];
    placeHolderLabel.frame = CGRectMake(offsetLeft, offsetTop, expectedSize.width, expectedSize.height);
}


#pragma mark 回调函数

- (void)didHasMaxNumHanlder:(void (^)())maxNumBlock {
    self.maxNumBlock = maxNumBlock;
}

- (void)didAdjustFrameHandler:(void (^)())adjustFrameBlock {
    self.adjustFrameBlock = adjustFrameBlock;
}

#pragma mark Set Method

-(void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    
    if ( placeHolderLabel == nil ) {
        placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
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

- (void)setText:(NSString *)text {
    [super setText:text];
    [self refreshPlaceholder];
}

-(void)setFont:(UIFont *)font {
    [super setFont:font];
    placeHolderLabel.font = self.font;
    
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

- (void)setMinHeight:(CGFloat)minHeight {
    if (minHeight >= 34) {
        _minHeight = minHeight;
    }
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
    
    if (text.length == 0 || [textView.text length] < self.maxCharNum) {
        return YES;
    }
    
    if (self.maxNumBlock) {
        self.maxNumBlock();
    }
    return NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
