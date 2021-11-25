// *******************************************
//  File Name:      BQTextRule.h
//  Author:         MrBai
//  Created Date:   2020/3/21 9:47 AM
//
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BQTextRuleType) {
    BQTextRuleType_Normal,      ///< 无规则
    BQTextRuleType_Num,         ///< 数字类型
    BQTextRuleType_Char,        ///< 字符类型
    BQTextRuleType_NumChar,     ///< 数字+字符
    BQTextRuleType_Chinese,     ///< 中文
    BQTextRuleType_Price        ///< 价格(数字+小数点)
};

@class BQTextRule;

@interface UITextField (BQTextRule)
@property (nonatomic, strong) BQTextRule * rule;
@end

/// 文字规则类
@interface BQTextRule : NSObject

/// 规则类型
@property (nonatomic, assign) BQTextRuleType type;

/// 小数点位数(数字加小数点文本)type:为InputTextType_Price时有效(默认2位)
@property (nonatomic, assign) NSInteger  precision;

+ (instancetype)textRuleType:(BQTextRuleType)type;

#pragma mark - 其他规则配置

/// 全大写,默认false
@property (nonatomic, assign) BOOL      upText;
/// 全小写,默认false
@property (nonatomic, assign) BOOL      lowText;
/// 消除空格
@property (nonatomic, assign) BOOL      clearSpace;
/// 文本最大长度,默认无限制
@property (nonatomic, assign) NSInteger maxLength;
@end

NS_ASSUME_NONNULL_END
