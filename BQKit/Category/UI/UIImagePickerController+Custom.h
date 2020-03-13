// *******************************************
//  File Name:      UIImagePickerController+Custom.h       
//  Author:         MrBai
//  Created Date:   2020/3/11 4:49 PM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImagePickerController (Custom)

/// 弹出系统图片选择器,都会进行权限检测
/// @param vc 来源控制器
/// @param type 选择器类型
/// @param handle 选择结果回调
+ (void)showImgPickFrom:(UIViewController *)vc
                   type:(UIImagePickerControllerSourceType)type
                 handle:(void(^)(UIImage * img))handle;
@end

NS_ASSUME_NONNULL_END
