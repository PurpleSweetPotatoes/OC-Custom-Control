//
//  BQTextView.h
//  Test
//
//  Created by MrBai on 17/2/23.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQTextView : UITextView

@property (nonatomic, assign) BOOL autoAdjustHeight;    ///< 自动适应高度,默认为YES
@property (nonatomic, copy) NSString * placeholder;         ///< 占位字符
@property (nonatomic, strong) UIColor * placeholderColor;   ///< 占位符颜色
@property (nonatomic, assign) CGFloat minHeight;            ///< 最小高度 34
@property (nonatomic, assign) NSInteger maxCharNum;         ///< 最大字符数

/**
 设置达到最大字符数后回调方法
 */
- (void)didHasMaxNumHanlder:(void(^)())maxNumBlock;

/**
 设置自动调整高度后的方法
 */
- (void)didAdjustFrameHandler:(void(^)())adjustFrameBlock;

@end
