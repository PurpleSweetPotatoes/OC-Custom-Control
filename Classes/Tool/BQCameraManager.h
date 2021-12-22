// *******************************************
//  File Name:      BQCameraManager.h       
//  Author:         MrBai
//  Created Date:   2020/4/15 11:26 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, BQCameraType) {
    BQCameraType_Photo = 1 << 0,        ///< 相机
    BQCameraType_Video = 1 << 1,        ///< 视频
    BQCameraType_Audio = 1 << 2,        ///< 音频
    BQCameraType_Scan  = 1 << 3,        ///< 扫描
};

@protocol BQCameraManagerDelegate <NSObject>
@optional

- (void)cameraLoadFail:(NSString *)fail;

- (void)cameraChangeStatusFail:(NSString *)fail;

- (void)cameraScanInfo:(NSString *)info bounds:(CGRect)bounds;

/// when use takePhoto finish will call this method
- (void)cameraPhotoImage:(UIImage *)image error:(NSError *)error;

@end



@interface BQCameraManager : NSObject

@property (nonatomic, weak  ) id<BQCameraManagerDelegate> delegate;
@property (nonatomic, strong) AVCaptureDevice         * device;
@property (nonatomic, strong) AVCaptureSession        * session;
@property (nonatomic, assign) BQCameraType            type;         ///< 呈现形式 默认BQCameraType_Photo
@property (nonatomic, assign) AVCaptureDevicePosition postion;      ///< 默认 AVCaptureDevicePositionBack
@property (nonatomic, assign) AVCaptureFlashMode      flashModel;   ///< 闪光灯状态
@property (nonatomic, assign) AVCaptureTorchMode      torchMode;    ///< 手电状态

+ (instancetype)manager;
+ (instancetype)managerWithDelegate:(_Nullable id<BQCameraManagerDelegate>)delegate;

/// set  show image  in supView
/// @param supView superView
- (void)configShowView:(UIView *)supView;
- (void)configShowView:(UIView *)supView model:(AVLayerVideoGravity)model;

#pragma mark - *** BQCameraType_Photo

/// 拍照, 拍照完成回调cameraPhotoImage:error:方法
- (void)takePhoto;

#pragma mark - *** BQCameraType_Video

#pragma mark - *** BQCameraType_Scan
- (void)configScanRect:(CGRect)rect superSize:(CGSize)size;


#pragma mark - *** config method
/// 设置分辨率
- (BOOL)setSeesionPreset:(AVCaptureSessionPreset)preset;

/// 开始运行捕捉画面
- (void)startRunning;

/// 停止捕捉画面
- (void)stopRunning;

/// 设置焦距
- (void)setVideoZoomFactor:(CGFloat)zoom;

/// 转换摄像头, BQCameraType_Scan 不支持
- (void)switchCamera;

/// 聚焦点
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
