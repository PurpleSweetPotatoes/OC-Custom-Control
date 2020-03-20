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

typedef NS_ENUM(NSUInteger, InputTextType) {
    InputTextType_Every,      ///> 任意类型
    InputTextType_Num,        ///> 数字类型
    InputTextType_Char,       ///> 字符类型
    InputTextType_NumChar,    ///> 数字+字符
    InputTextType_Chinese     ///> 中文
};

@interface UITextField (Custom)

/*
 配置检查规则，需要调用startCheckConfig方法
 */

@property (nonatomic, assign) BOOL  upText;                 ///< 全大写
@property (nonatomic, assign) BOOL  lowText;                ///< 全小写
@property (nonatomic, assign) InputTextType  type;          ///< 限制输入文本类型
@property (nonatomic, assign) NSInteger  maxLength;         ///< 文本最大长度,默认无限制
@property (nonatomic, assign) NSInteger  precision;         ///< 小数点位数(数字加小数点文本)

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

/// 配置规则限制需要开启检查
- (void)startCheckConfig;

@end

NS_ASSUME_NONNULL_END
