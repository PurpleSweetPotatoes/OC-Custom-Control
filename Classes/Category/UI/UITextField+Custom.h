// *******************************************
//  File Name:      UITextField+Custom.h       
//  Author:         MrBai
//  Created Date:   2020/3/10 3:00 PM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Custom)

/// 检查是否有值
/// @param arr 输入框集合
+ (NSString *)checkContent:(NSArray <UITextField *> *)arr;

/// 增加输入框左间距(插入左边空视图)
/// @param space 间距
- (void)addLeftSpace:(CGFloat)space;

/// 增加输入框右间距(插入右边空视图)
/// @param space 间距
- (void)addRightSpace:(CGFloat)space;

/// 添加更多视图
- (void)addRightMoreImg;

@end

NS_ASSUME_NONNULL_END
