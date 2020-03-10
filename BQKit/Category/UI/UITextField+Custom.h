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

@property (nonatomic, assign) NSInteger  maxLength;         ///< 文本最大长度,默认无限制

/// 创建价格输入框
/// @param frame 位置
/// @param precision 小数位数
+ (instancetype)priceTfWithFrame:(CGRect)frame precision:(NSInteger)precision;

/// 检查是否有值
/// @param arr 输入框集合
+ (NSString *)checkContent:(NSArray <UITextField *> *)arr;

- (void)addLeftSpace:(CGFloat)space;
- (void)addRightSpace:(CGFloat)space;

- (void)addRightMoreImg;

@end

NS_ASSUME_NONNULL_END
