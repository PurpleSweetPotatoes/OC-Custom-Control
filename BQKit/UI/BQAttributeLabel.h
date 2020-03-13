//
//  BQAttributeLabel.h
//  AttributeStringDemo
//
//  Created by baiqiang on 2019/3/27.
//  Copyright © 2019年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BQAttributeLabel;
@protocol BQAttributeLabelDelegate <NSObject>

- (void)attributeLabel:(BQAttributeLabel *)label tapText:(NSString *)tapText;

@end


/**
 自定义属性文字Lab,可添加对应文字点击事件
 设置NSAttributeString时，添加点击事件则必须指定String的font
 */
@interface BQAttributeLabel : UILabel

@property (nonatomic, weak) id<BQAttributeLabelDelegate>  delegate;

/// 对文字添加点击事件
/// @param text 响应的文字
- (void)addTapBlockWithText:(NSString *)text;

/// 对范围添加点击事件
/// @param text 响应的范围
- (void)addTapBlockWithRange:(NSRange)range;

/// 移除文字点击事件
/// @param text 响应的文字
- (void)removeTapBlockWithText:(NSString *)text;

/// 移除范围点击事件
/// @param text 响应的范围
- (void)removeTapBlockWithRange:(NSRange)range;

/// 移除所有点击事件
- (void)removeTapBlocks;

@end

NS_ASSUME_NONNULL_END
