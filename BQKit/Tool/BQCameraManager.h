// *******************************************
//  File Name:      BQCameraManager.h       
//  Author:         MrBai
//  Created Date:   2020/4/15 11:26 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BQCameraManagerDelegate <NSObject>
@optional

- (void)cameraLoadFail:(NSString *)fail;

- (void)cameraChangeStatusFail:(NSString *)fail;

/// 使用默认output有效
- (void)cameraFrameImage:(UIImage *)image;

@end


@interface BQCameraManager : NSObject

@property (nonatomic, readonly, weak) id<BQCameraManagerDelegate> delegate;
@property (nonatomic, strong        ) AVCaptureDevice             * device;
@property (nonatomic, strong        ) AVCaptureSession            * session;
@property (nonatomic, strong        ) AVCaptureInput              * videoInput;
/// 默认 AVCaptureDevicePositionBack
@property (nonatomic, assign        ) AVCaptureDevicePosition     postion;
/// 默认使用32RGB类型的videoDataOutput
@property (nonatomic, strong        ) AVCaptureOutput             * output;
/// 是否开启麦克风
@property (nonatomic, assign        ) BOOL                        startMic;


+ (instancetype)configManager;

+ (instancetype)configManagerWithDelegate:(_Nullable id<BQCameraManagerDelegate>)delegate;

/// 设置分辨率
- (BOOL)setSeesionPreset:(AVCaptureSessionPreset)preset;

/// 开始运行捕捉画面
- (void)startRunning;

/// 停止捕捉画面
- (void)stopRunning;

/// 设置焦距
- (void)setVideoZoomFactor:(CGFloat)zoom;

/// 转换摄像头
- (void)switchCamera;

/// 闪光灯操作
- (void)setFlashMode:(AVCaptureFlashMode)flashMode;

/// 手电筒操作
- (void)setTorchMode:(AVCaptureTorchMode)flashMode;

/// 聚焦点(同时修改曝光点)
/// @param point 视图所呈现点位
/// @param size 视图大小
- (void)focusAtPoint:(CGPoint)point vSize:(CGSize)size;

/// 曝光点
/// @param point 视图所呈现点位
/// @param size 视图大小
- (void)exposeAtPoint:(CGPoint)point vSize:(CGSize)size;

/// 重置曝光
- (void)resetFocusAndExposureModes;

@end

NS_ASSUME_NONNULL_END
