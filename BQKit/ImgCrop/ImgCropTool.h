// *******************************************
//  File Name:      ImgCropTool.h
//  Author:         MrBai
//  Created Date:   2020/3/5 10:53 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ImgFromType) {
    ImgFromType_Camera,         // 相机
    ImgFromType_Photo           // 相册
};

/// 单个图片获取并裁减工具
@interface ImgCropTool : NSObject

/// 获取图片
/// @param type 获取途径
/// @param fromVc 来源控制器
/// @param handle 处理后的图片
+ (void)getImgWithType:(ImgFromType)type
                fromVc:(UIViewController *)fromVc
            editHandle:(void(^)(UIImage * img))handle;

/// 展示一个图片并进行裁剪
/// @param img 源图片
/// @param fromVc 来源控制器
/// @param handle 处理后的图片
+ (void)showCropViewWithImg:(UIImage *)img
                     fromVc:(UIViewController *)fromVc
                 editHandle:(void(^)(UIImage * img))handle;

@end

NS_ASSUME_NONNULL_END
