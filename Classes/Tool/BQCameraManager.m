// *******************************************
//  File Name:      BQCameraManager.m       
//  Author:         MrBai
//  Created Date:   2020/4/15 11:26 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQCameraManager.h"
#import "UIDevice+Custom.h"

@interface BQCameraManager()
<
AVCaptureVideoDataOutputSampleBufferDelegate
,AVCaptureAudioDataOutputSampleBufferDelegate
,AVCaptureMetadataOutputObjectsDelegate
>
@property (nonatomic, weak  ) id<BQCameraManagerDelegate> delegate;
@property (nonatomic, strong) AVCaptureConnection         * videoConnec;
@property (nonatomic, assign) CGColorSpaceRef             colorSpace;
@property (nonatomic, strong) AVCaptureMetadataOutput     * metaOutput;
@end

@implementation BQCameraManager

#pragma mark - 公共方法

+ (instancetype)configManager {
    return [self configManagerWithDelegate:nil];
}

+ (instancetype)configManagerWithDelegate:(_Nullable id<BQCameraManagerDelegate>)delegate {
    BQCameraManager * manager = [[BQCameraManager alloc] init];
    manager.postion = AVCaptureDevicePositionBack;
    manager.delegate = delegate;
    manager.session = [[AVCaptureSession alloc] init];
    manager.colorSpace = CGColorSpaceCreateDeviceRGB();
    [manager configDevice];

    return manager;
}

- (void)dealloc {
    NSLog(@"设备管理释放");
    CGColorSpaceRelease(self.colorSpace);
}

#pragma mark - 操作方法

- (void)startRunning {
    if (self.videoInput && ![self.session isRunning]) {
        AVCaptureConnection* connection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
        connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        // 调节摄像头翻转
        connection.videoMirrored = (self.postion == AVCaptureDevicePositionFront);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.session startRunning];
            [self resetFocusAndExposureModes];
        });
    }
}

- (void)stopRunning {
    if (self.videoInput && [self.session isRunning]) {
        [self.session stopRunning];
    }
}

- (void)setVideoZoomFactor:(CGFloat)zoom {
    if (zoom < 1) {
        zoom = 1;
    } else if (zoom > self.device.activeFormat.videoMaxZoomFactor) {
        zoom = self.device.activeFormat.videoMaxZoomFactor;
    }
    
    if (zoom != self.device.videoZoomFactor) {
        [self changeDeviceStatus:^{
            self.device.videoZoomFactor = zoom;
        }];
    }
    
}

- (void)switchCamera {
    if (self.postion == AVCaptureDevicePositionBack) {
        self.postion = AVCaptureDevicePositionFront;
    } else if (self.postion == AVCaptureDevicePositionFront) {
        self.postion = AVCaptureDevicePositionBack;
    }
        
    [self configDevice];
    
    if (self.videoInput) {
        [self startRunning];
    }
}

/// 闪光灯操作
- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
    AVCapturePhotoSettings * settings = [AVCapturePhotoSettings photoSettings];
    AVCapturePhotoOutput * photoOutput = [AVCapturePhotoOutput new];
    if (settings.flashMode != flashMode && [photoOutput.supportedFlashModes containsObject:@(flashMode)]) {
        [self changeDeviceStatus:^{
            settings.flashMode = flashMode;
        }];
    }
}

/// 手电筒操作
- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
    if (self.device.torchMode != torchMode && [self.device isTorchModeSupported:torchMode]) {
        [self changeDeviceStatus:^{
            self.device.torchMode = torchMode;
        }];
    }
}

- (void)focusAtPoint:(CGPoint)point vSize:(CGSize)size {
    CGPoint focusPoint = [self transtionPoint:point size:size];
    if (!CGPointEqualToPoint(focusPoint, CGPointZero)) {
        [self focusAtPoint:focusPoint];
    }
}

- (void)focusAtPoint:(CGPoint)point {
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    BOOL canResetFocus = [self.device isFocusPointOfInterestSupported] && [self.device isFocusModeSupported:focusMode];
    
    AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    BOOL canResetExposure = [self.device isExposurePointOfInterestSupported] && [self.device isExposureModeSupported:exposureMode];
    [self changeDeviceStatus:^{
        if (canResetFocus) {
            self.device.focusMode = focusMode;
            self.device.focusPointOfInterest = point;
        }
        if (canResetExposure) {
            self.device.exposureMode = exposureMode;
            self.device.exposurePointOfInterest = point;
        }
    }];
}

- (void)exposeAtPoint:(CGPoint)point vSize:(CGSize)size {
    CGPoint exposePoint = [self transtionPoint:point size:size];
    if (!CGPointEqualToPoint(exposePoint, CGPointZero)) {
        AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        if (self.device.isExposurePointOfInterestSupported &&
            [self.device isExposureModeSupported:exposureMode]) {
            [self changeDeviceStatus:^{
                self.device.exposurePointOfInterest = point;
                self.device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            }];
        }
    }
}

- (CGPoint)transtionPoint:(CGPoint)point size:(CGSize)size {
    if (point.x > size.width || point.y > size.height) {
        if ([self.delegate respondsToSelector:@selector(cameraChangeStatusFail:)]) {
            MainQueueSafe(^{
                [self.delegate cameraChangeStatusFail:@"调整点位不正确"];
            })
            return CGPointZero;
        }
    }
    
    return CGPointMake(point.x / size.width, point.y / size.height);
}

- (void)resetFocusAndExposureModes {
    [self focusAtPoint:CGPointMake(0.5, 0.5)];
}

- (void)changeDeviceStatus:(void(^)(void))block {
    NSError * err;
    if ([self.device lockForConfiguration:&err]) {
        block();
    } else if([self.delegate respondsToSelector:@selector(cameraChangeStatusFail:)]){
        MainQueueSafe(^{
            [self.delegate cameraChangeStatusFail:err.localizedDescription];
        });
    } else {
        NSLog(@"状态修改错误:%@",err.localizedDescription);
    }
}

#pragma mark - Delegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (connection == self.videoConnec) {
        //视频处理
        if ([self.delegate respondsToSelector:@selector(cameraFrameImage:)]) {
            UIImage * image = [self imageFromSampleBuffer:sampleBuffer];
            MainQueueSafe(^{
                [self.delegate cameraFrameImage:image];
            });
        }

    }
}

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, self.colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    // Free up the context and color space
    CGContextRelease(context);
    // Create an image object from the Quartz image
    UIImage * outImg = [UIImage imageWithCGImage:quartzImage];
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return outImg;
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    AVMetadataMachineReadableCodeObject *code = metadataObjects.firstObject;
    if (code.stringValue) {
        NSLog(@"扫描到%@: %@", code.type == AVMetadataObjectTypeQRCode?@"二维码":@"条形码", code.stringValue);
        NSLog(@"位置:%@", NSStringFromCGRect(code.bounds));
        if ([self.delegate respondsToSelector:@selector(cameraScanInfo:bounds:)]) {
            MainQueueSafe(^{
                [self.delegate cameraScanInfo:code.stringValue bounds:code.bounds];
            });
        }
    }
}

#pragma mark - 配置相机

- (void)configDevice {
    AVCaptureDeviceDiscoverySession * session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:self.postion];
    NSArray * deviceList = session.devices;
    if (deviceList.count > 0) {
        self.device = deviceList[0];
        for (AVCaptureDevice * device in deviceList) {
            if ([device position] == self.postion) {
                self.device = device;
            }
        }
        __weak typeof(self) weakSelf = self;
        [UIDevice prepareCamera:^{
                [weakSelf configStreams];
        }];
    }
}

- (void)configStreams {
    
    AVCaptureInput * videoInput = self.videoInput;
    
    //请求输入流(这步会申请权限)
    NSError * err;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&err];
    
    if (!err) {
        [self.session beginConfiguration];
        
        if (videoInput) {
            [self.session removeInput:videoInput];
        }
                
        if ([self.session canAddInput:self.videoInput]) {
            [self.session addInput:self.videoInput];
        }
        
        if ([self.session canAddOutput:self.videoOutput]) {
            [self.session addOutput:self.videoOutput];
            self.videoConnec = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
        }
        
        if ([self.session canAddOutput:self.metaOutput]) {
            [self.session addOutput:self.metaOutput];
            // 需要在添加后设置
            self.metaOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code];
        }
        
        if (self.startMic) {
            AVCaptureDeviceDiscoverySession * session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInMicrophone] mediaType:AVMediaTypeVideo position:self.postion];
            NSArray * deviceList = session.devices;
            if (deviceList.count > 0) {
                AVCaptureDeviceInput * audioInput = [AVCaptureDeviceInput deviceInputWithDevice:deviceList[0] error:nil];
                if ([self.session canAddInput:audioInput]) {
                    [self.session addInput:audioInput];
                }

                AVCaptureAudioDataOutput * audioOutput = [[AVCaptureAudioDataOutput alloc] init];
                [audioOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(0, 0)];
                if ([self.session canAddOutput:audioOutput]) {
                    [self.session addOutput:audioOutput];
                }
            }
        }
        [self.session commitConfiguration];
    } else {
        if ([self.delegate respondsToSelector:@selector(cameraLoadFail:)]) {
            MainQueueSafe(^{
                [self.delegate cameraLoadFail:err.localizedDescription];
            })
            
        }
    }
}

- (void)configScanRect:(CGRect)rect superSize:(CGSize)size {
    
    self.metaOutput.rectOfInterest = CGRectMake(rect.origin.y/size.height, rect.origin.x/size.width, rect.size.height / size.height, rect.size.width / size.width);
}

- (BOOL)setSeesionPreset:(AVCaptureSessionPreset)preset {
    if ([self.device supportsAVCaptureSessionPreset:preset] && [self.session canSetSessionPreset:preset]) {
        [self.session setSessionPreset:preset];
        return YES;
    }
    return NO;
}

#pragma mark - *** get

- (AVCaptureOutput *)videoOutput {
    if (_videoOutput == nil) {
        AVCaptureVideoDataOutput * videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey, nil];
        [videoOutput setSampleBufferDelegate:self queue:dispatch_queue_create("BQCameraSetting.process.queue", DISPATCH_QUEUE_SERIAL)];
        _videoOutput = videoOutput;
    }
    return _videoOutput;
}

- (AVCaptureMetadataOutput *)metaOutput {
    if (_metaOutput == nil) {
        AVCaptureMetadataOutput * metaOutput = [[AVCaptureMetadataOutput alloc] init];
        [metaOutput setMetadataObjectsDelegate:self queue:dispatch_queue_create("BQCameraSetting.process.queue", DISPATCH_QUEUE_SERIAL)];
        _metaOutput = metaOutput;
    }
    return _metaOutput;
}

@end

