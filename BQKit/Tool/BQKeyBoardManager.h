// *******************************************
//  File Name:      BQKeyBoardManager.h       
//  Author:         MrBai
//  Created Date:   2020/5/13 12:28 PM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 键盘管理者
@interface BQKeyBoardManager : NSObject

/// 添加键盘管理视图,只能针对一个视图管理,添加一个自动移除上一个管理视图
/// @param reView 被管理的视图
+ (void)startResponseView:(UIView *)reView;

/// 移除键盘管理
+ (void)closeResponse;

@end

NS_ASSUME_NONNULL_END
