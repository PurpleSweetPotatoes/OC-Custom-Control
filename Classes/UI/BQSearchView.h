//
//  BQSearchView.h
//  tianyaTest
//
//  Created by baiqiang on 2019/2/24.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 自定义搜索视图
@interface BQSearchView : UITextField

@property (nonatomic, strong) UIColor * placeHolderColor;       ///< 提示文案

/// 配置左视图
/// @param imgName 视图图像
- (void)configLeftImg:(NSString *)imgName;

/// 配置右视图
/// @param imgName 视图图像
- (void)configRightImg:(NSString *)imgName;

/// 是否含有点击操作，有点击操作无法编辑
- (BOOL)hasTapAction;

/// 添加点击操作，无法正常编辑
- (void)addTapAction:(nullable void(^)(BQSearchView * searchView))handler;

/// 移除点击操作，可正常编辑
- (void)removeTapAction;

@end

NS_ASSUME_NONNULL_END
