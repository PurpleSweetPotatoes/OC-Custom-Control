// *******************************************
//  File Name:      BQMenuView.h       
//  Author:         MrBai
//  Created Date:   2020/6/30 2:24 PM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MenuBlock)(NSInteger index);

@interface BQMenuView : UIView

/// 展示菜单视图
/// @param frame 目标视图位置
/// @param imgs 图片数组(可为空,不为空数量须与标题数量匹配)
/// @param titles 标题数组
+ (void)showWithTargetFrame:(CGRect)frame
                       imgs:(NSArray <NSString *> *)imgs
                     titles:(NSArray <NSString *> *)titles
                handleblock:(MenuBlock)block;
@end


@interface UIBarButtonItem(BQMenu)

/// 展示菜单选项
- (void)showBQMenuViewWithTitles:(NSArray <NSString *> *)titles
                      handleblock:(MenuBlock)block;;

/// 图片数量须等于标题数量
- (void)showBQMenuViewWithImgs:(NSArray <NSString *> *)imgs
                        titles:(NSArray <NSString *> *)titles
                   handleblock:(MenuBlock)block;;
@end

@interface UIView(BQMenu)

/// 展示菜单选项
- (void)showBQMenuViewWithTitles:(NSArray <NSString *> *)titles
                      handleblock:(MenuBlock)block;;

/// 图片数量须等于标题数量
- (void)showBQMenuViewWithImgs:(NSArray <NSString *> *)imgs
                        titles:(NSArray <NSString *> *)titles
                   handleblock:(MenuBlock)block;;

@end

NS_ASSUME_NONNULL_END
