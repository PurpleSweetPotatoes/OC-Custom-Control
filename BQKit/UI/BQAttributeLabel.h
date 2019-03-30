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
 设置NSAttributeString时，添加点击事件则必须指定String的font
 */
@interface BQAttributeLabel : UILabel

@property (nonatomic, weak) id<BQAttributeLabelDelegate>  delegate;

- (void)addTapBlockWithText:(NSString *)text;

- (void)addTapBlockWithRange:(NSRange)range;

- (void)removeTapBlockWithText:(NSString *)text;

- (void)removeTapBlockWithRange:(NSRange)range;

- (void)removeTapBlocks;


@end

NS_ASSUME_NONNULL_END
