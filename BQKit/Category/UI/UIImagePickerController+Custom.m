// *******************************************
//  File Name:      UIImagePickerController+Custom.m       
//  Author:         MrBai
//  Created Date:   2020/3/11 4:49 PM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "UIDevice+Custom.h"
#import "UIImagePickerController+Custom.h"

@interface UIImagePickerController()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
@end

static void(^staticHandle)(UIImage * img);

@implementation UIImagePickerController (Custom)

+ (void)showImgPickFrom:(UIViewController *)vc
                   type:(UIImagePickerControllerSourceType)type
                 handle:(void(^)(UIImage * img))handle {
    
    if (type == UIImagePickerControllerSourceTypeCamera) {
        [UIDevice prepareCamera:^{
            [self creaatePickFrom:vc type:type handle:handle];
        }];
    } else {
        [UIDevice prepareImagePicker:^{
            [self creaatePickFrom:vc type:type handle:handle];
        }];
    }
}

+ (void)creaatePickFrom:(UIViewController *)vc
                   type:(UIImagePickerControllerSourceType)type
                 handle:(void(^)(UIImage * img))handle {
    UIImagePickerController * pickVc = [[UIImagePickerController alloc] init];
    pickVc.sourceType = type;
    //自代理
    pickVc.delegate = pickVc;
    staticHandle = handle;
    //页面跳转
    [vc presentViewController:pickVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    NSLog(@"%@",info);
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage * newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!newPhoto) {
        newPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    if (staticHandle) {
        staticHandle(newPhoto);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    staticHandle = nil;
}
@end
