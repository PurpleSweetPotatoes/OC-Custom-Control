// *******************************************
//  File Name:      ImgCropTool.m       
//  Author:         MrBai
//  Created Date:   2020/3/5 10:53 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "ImgCropTool.h"
#import "PureCamera.h"
#import "TOCropViewController.h"


@interface ImgCropTool ()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
TOCropViewControllerDelegate
>
@property (nonatomic, strong) UIViewController * fromVc;
@property (nonatomic, copy) void(^block)(UIImage * img);
@end

@implementation ImgCropTool

+ (instancetype)shareTool {
    static ImgCropTool * tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[ImgCropTool alloc] init];
    });
    return tool;
}
#pragma mark - Public Method

+ (void)getImgWithType:(ImgFromType)type
                fromVc:(UIViewController *)fromVc
            editHandle:(void(^)(UIImage * img))handle {
    
    if (type == ImgFromType_Camera) {
        PureCamera *homec = [[PureCamera alloc] init];
        homec.modalPresentationStyle = UIModalPresentationFullScreen;
        homec.fininshcapture = ^(UIImage *ss) {
            if (ss) {
                handle(ss);
            }
        };
        [fromVc presentViewController:homec animated:YES completion:nil];
    } else {
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        PickerImage.modalPresentationStyle = UIModalPresentationFullScreen;
        ImgCropTool * tool = [self shareTool];
        tool.fromVc = fromVc;
        tool.block = handle;
        //自代理
        PickerImage.delegate = tool;
        //页面跳转
        [fromVc presentViewController:PickerImage animated:YES completion:nil];
    }
}

+ (void)showCropViewWithImg:(UIImage *)img fromVc:(UIViewController *)fromVc editHandle:(void(^)(UIImage * img))handle {
    TOCropViewController * cropVc = [[TOCropViewController alloc] initWithImage:img aspectRatioStle:TOCropViewControllerAspectRatioOriginal];
    ImgCropTool * tool = [self shareTool];
    tool.fromVc = fromVc;
    tool.block = handle;
    cropVc.delegate = tool;
    [fromVc presentViewController:cropVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * newPhoto = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.fromVc = picker;
    [ImgCropTool showCropViewWithImg:newPhoto fromVc:self.fromVc editHandle:self.block];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    [cropViewController dismissViewControllerAnimated:NO completion:nil];
    if ([self.fromVc isKindOfClass:[UIImagePickerController class]]) {
        [self.fromVc dismissViewControllerAnimated:NO completion:nil];
    }
    self.block(image);
}
@end
