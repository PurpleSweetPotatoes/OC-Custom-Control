// *******************************************
//  File Name:      ImgCropTool.h
//  Author:         MrBai
//  Created Date:   2020/3/5 10:53 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ImgFromType) {
    ImgFromType_Camera,
    ImgFromType_Photo
};

@interface ImgCropTool : NSObject

+ (void)getImgWithType:(ImgFromType)type
                fromVc:(UIViewController *)fromVc
            editHandle:(void(^)(UIImage * img))handle;


+ (void)showCropViewWithImg:(UIImage *)img
                     fromVc:(UIViewController *)fromVc
                 editHandle:(void(^)(UIImage * img))handle;

@end

NS_ASSUME_NONNULL_END
