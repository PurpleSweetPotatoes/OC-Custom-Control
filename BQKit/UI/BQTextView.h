//
//  BQTextView.h
//  Test
//
//  Created by MrBai on 17/2/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BQTextView;

@protocol BQTextViewDelegate<NSObject>

@optional

- (void)textViewDidHasMaxNum:(BQTextView *)textView;
- (void)textViewDidAdjustFrame:(BQTextView *)textView;

- (BOOL)textViewShouldBeginEditing:(BQTextView *)textView;
- (BOOL)textViewShouldEndEditing:(BQTextView *)textView;

- (void)textViewDidBeginEditing:(BQTextView *)textView;
- (void)textViewDidEndEditing:(BQTextView *)textView;

- (void)textViewDidChange:(UITextView *)textView;

@end

@interface BQTextView : UITextView

@property (nonatomic, weak) id<BQTextViewDelegate> ourDelegate;

@property (nonatomic, copy) NSString * placeholder;         ///< 占位字符
@property (nonatomic, strong) UIColor * placeholderColor;   ///< 占位符颜色
@property (nonatomic, assign) NSInteger maxCharNum;         ///< 最大字符数,默认1000

@property (nonatomic, assign) BOOL autoAdjustHeight;        ///< 自动适应高度,默认为NO
@property (nonatomic, assign) CGFloat maxHeight;            ///< 最大高度默认为初始化高度,开启自适应高度时有效

@end
