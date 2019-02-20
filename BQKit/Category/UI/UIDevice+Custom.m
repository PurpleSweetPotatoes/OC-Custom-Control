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

//首先导入头文件信息
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_3G          @"pdp_ip0"
#define IOS_WIFI        @"en0"  //局域网
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation UIDevice (Authorization)

+ (CGFloat)currentVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)ip4Address {
    return [self getIPAddress:YES];
}

+ (NSString *)ip6Address {
    return [self getIPAddress:NO];
}

//获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_3G @"/" IP_ADDR_IPv4, IOS_3G @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_3G @"/" IP_ADDR_IPv6, IOS_3G @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if (!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface = interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
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
