//
//  UIDevice+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQDefineHead.h"

@interface UIDevice (Custom)

/// 系统版本号
+ (NSString *)currentVersion;

/// 是否支持版本号
/// @param vesion 版本号
+ (BOOL)supportVesion:(CGFloat)vesion;

/// ip4地址
+ (NSString *)ip4Address;

/// ip6地址
+ (NSString *)ip6Address;

/// 获取ip相关信息
+ (NSDictionary *)getIPAddresses;

#pragma mark - 摄像头是否可用
/// 判断设备是否有摄像头
+ (BOOL)isCameraAvailable;

/// 前面的摄像头是否可用
+ (BOOL)isFrontCameraAvailable;

/// 后面的摄像头是否可用
+ (BOOL)isRearCameraAvailable;

/// 判断设备相册是否可用
+ (BOOL)isPhotoLibraryAvailable;

#pragma mark - 权限检查
/// 判断摄像头是否已经授权可以使用
+ (BOOL)isCameraAuthorization;

/// 判断麦克风是否已经授权可以使用
+ (BOOL)isAudioAuthorization;

/// 判断通讯录是否已经授权可以使用
+ (BOOL)isAddressBookAuthorization;

/// 调用设置通讯录授权
+ (BOOL)authorAddressBook;

#pragma mark - 权限获取
/// 准备相机权限
+ (void)prepareCamera:(VoidBlock)finishCallback;

// 准备麦克风权限
+ (void)prepareMicrophone:(VoidBlock)finishCallback;

// 准备相册权限
+ (void)prepareImagePicker:(VoidBlock)finishCallback;
@end
