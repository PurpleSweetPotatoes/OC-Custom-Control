//
//  UIDevice+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIDevice+Custom.h"
#import <AVFoundation/AVFoundation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation UIDevice (Authorization)

+ (CGFloat)currentVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

#pragma mark - 摄像头是否可用
// 判断设备是否有摄像头
+ (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

// 前面的摄像头是否可用
+ (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
+ (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

// 判断设备相册是否可用
+ (BOOL)isPhotoLibraryAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark - 权限检查
+ (BOOL)isCameraAuthorization {
    __block BOOL isValid = YES;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        isValid = granted;
    }];
    return isValid;
}

+ (BOOL)isAudioAuthorization {
    __block BOOL isValid = YES;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        isValid = granted;
    }];
    return isValid;
}

+ (BOOL)isAddressBookAuthorization {
    BOOL isValid = YES;
    CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (authStatus != CNAuthorizationStatusAuthorized) {
        isValid = NO;
    }
    
    return isValid;
}

+ (BOOL)authorAddressBook {
    __block BOOL ret = YES;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    CNContactStore * store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        ret = granted;
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return ret;
}

#pragma mark - 权限获取
+ (void)prepareCamera:(void(^)(void))finishCallback {
    // 检测是否已获取摄像头权限
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [self prepareMicrophone:finishCallback];
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [self alertNoCameraPermission];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self prepareMicrophone:finishCallback];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertNoCameraPermission];
                });
            }
        }];
    } else {
        NSLog(@"%@", @"请求摄像头权限发生其他未知错误");
    }
}

+ (void)prepareMicrophone:(void(^)(void))finishCallback {
    // 请求使用麦克风权限
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self alertNoMicrophonePermission];
            });
        } else if (finishCallback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                finishCallback();
            });
        }
    }];
}

+ (void)prepareImagePicker:(void (^)(void))finishCallback {
    if ([self isPhotoLibraryAvailable]) {
        
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        switch (authStatus) {
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
            {
                [self alertNoImagePickerPermission];
                break;
            }
            case PHAuthorizationStatusNotDetermined:
            {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        !finishCallback ? : finishCallback();
                    } else {
                        [self alertNoImagePickerPermission];
                    }
                }];
                break;
            }
            default:
            {
                !finishCallback ? : finishCallback();
                break;
            }
        }
    } else {
        // 手机不支持相册？
        [self alertNoImagePickerPermission];
    }
}

#pragma mark - Alerts
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)alertNoCameraPermission {
    [self alertWithTitle:@"应用没有使用手机摄像头的权限" message:@"请在“[设置]-[隐私]-[相机]”里允许应用使用"];
}

+ (void)alertNoMicrophonePermission {
    [self alertWithTitle:@"应用没有使用手机麦克风的权限" message:@"请在“[设置]-[隐私]-[麦克风]”里允许应用使用"];
}

+ (void)alertNoImagePickerPermission {
    [self alertWithTitle:@"应用没有使用手机相册的权限" message:@"请在“[设置]-[隐私]-[照片]”里允许应用使用"];
}
@end
