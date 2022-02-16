// *******************************************
//  File Name:      BQProgressView.h       
//  Author:         MrBai
//  Created Date:   2022/2/16 9:39 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, BQProgressType) {
    BQProgressTypeCircle, // 圆环
    BQProgressTypeCircleText, // 圆环带文字
};

@interface BQProgressView : UIView

/// 初始化类型
- (instancetype)initWithFrame:(CGRect)frame
                         type:(BQProgressType)type NS_DESIGNATED_INITIALIZER;

/// 设置进度
- (void)setPercent:(CGFloat)percent;

/// 设置线高
- (void)setColorHeight:(CGFloat)height;

/// 圆环进度颜色 默认白色
- (void)setShowColor:(UIColor *)showColor;

/// 圆环背景色 默认深灰
- (void)setBgColor:(UIColor *)bgColor;

@end

NS_ASSUME_NONNULL_END
