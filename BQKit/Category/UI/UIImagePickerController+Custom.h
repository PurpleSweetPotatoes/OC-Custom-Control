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
+ (void)showImgPickFrom:(UIViewController *)vc
                   type:(UIImagePickerControllerSourceType)type
                 handle:(void(^)(UIImage * img))handle;
@end

NS_ASSUME_NONNULL_END
