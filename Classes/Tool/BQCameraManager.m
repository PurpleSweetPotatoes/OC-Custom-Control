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
,AVCapturePhotoCaptureDelegate
>
@property (nonatomic, strong) dispatch_queue_t           queue;
@property (nonatomic, assign) CGColorSpaceRef            colorSpace;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * showLayer;
@property (nonatomic, strong) AVCaptureDeviceInput       * cameraInput;
@property (nonatomic, strong) AVCaptureDeviceInput       * audioInput;

@property (nonatomic, strong) AVCapturePhotoOutput       * photoOutput;
/// 默认使用32RGB类型的videoDataOutput
@property (nonatomic, strong) AVCaptureOutput            * videoOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput   * audioOutput;
@property (nonatomic, strong) AVCaptureMetadataOutput    * metaOutput;

@end

@implementation BQCameraManager

- (void)dealloc {
    NSLog(@"设备管理释放");
    CGColorSpaceRelease(self.colorSpace);
}

#pragma mark - 公共方法

+ (instancetype)manager {
    return [self managerWithDelegate:nil];
}

+ (instancetype)managerWithDelegate:(_Nullable id<BQCameraManagerDelegate>)delegate {
    BQCameraManager * manager = [[BQCameraManager alloc] init];
    manager.postion = AVCaptureDevicePositionBack;
    manager.delegate = delegate;
    manager.session = [[AVCaptureSession alloc] init];
    manager.colorSpace = CGColorSpaceCreateDeviceRGB();
    manager.queue = dispatch_queue_create("BQCameraSetting.process.queue", DISPATCH_QUEUE_SERIAL);
    manager.type = BQCameraType_Photo;
    [manager configDevice];

    return manager;
}

#pragma mark - 操作方法

- (void)startRunning {
    if (self.cameraInput && ![self.session isRunning]) {
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
    if (self.cameraInput && [self.session isRunning]) {
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
    if (self.type & BQCameraType_Scan) {
        if ([self.delegate respondsToSelector:@selector(cameraChangeStatusFail:)]) {
            [self.delegate cameraChangeStatusFail:@"扫描状态不支持摄像头转化"];
        }
        return;
    }
    
    if (self.postion == AVCaptureDevicePositionBack) {
        self.postion = AVCaptureDevicePositionFront;
    } else if (self.postion == AVCaptureDevicePositionFront) {
        self.postion = AVCaptureDevicePositionBack;
    }
        
    [self configDevice];
    
    if (self.cameraInput) {
        [self startRunning];
    }
}

- (void)takePhoto {
    if (self.type & BQCameraType_Photo) {
        
        AVCapturePhotoSettings * setting = [AVCapturePhotoSettings photoSettings];
        if ([self.photoOutput.availablePhotoCodecTypes containsObject:AVVideoCodecJPEG]) {
            NSDictionary *format = @{AVVideoCodecKey: AVVideoCodecJPEG};
            setting = [AVCapturePhotoSettings photoSettingsWithFormat:format];
        }
        setting.flashMode = self.flashModel;
        setting.autoStillImageStabilizationEnabled = YES;
        [self.photoOutput capturePhotoWithSettings:setting delegate:self];
    } else {
        if ([self.delegate respondsToSelector:@selector(cameraLoadFail:)]) {
            [self.delegate cameraLoadFail:@"未设置拍照模式"];
        }
    }
}

///// 闪光灯操作
//- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
//    AVCapturePhotoSettings * settings = [AVCapturePhotoSettings photoSettings];
//    if (settings.flashMode != flashMode && [self.photoOutput.supportedFlashModes containsObject:@(flashMode)]) {
//        [self changeDeviceStatus:^{
//            settings.flashMode = flashMode;
//        }];
//    }
//}

/// 手电筒操作
- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
    if (self.device.torchMode != torchMode && [self.device isTorchModeSupported:torchMode]) {
        [self changeDeviceStatus:^{
            self.device.torchMode = torchMode;
        }];
    }
}

- (AVCaptureTorchMode)torchMode {
    return self.device.torchMode;
}

- (void)focusAtPoint:(CGPoint)point vSize:(CGSize)size {
    CGPoint focusPoint = [self transtionPoint:point size:size];
    if (!CGPointEqualToPoint(focusPoint, CGPointZero)) {
        [self focusAtPoint:focusPoint];
    }
}

- (void)focusAtPoint:(CGPoint)point {
    AVCaptureFocusMode mode = AVCaptureFocusModeContinuousAutoFocus;
    if ([self.device isFocusPointOfInterestSupported] && [self.device isFocusModeSupported:mode]) {
        [self changeDeviceStatus:^{
            self.device.focusMode = mode;
            self.device.focusPointOfInterest = point;
        }];
    }
}

- (void)exposeAtPoint:(CGPoint)point vSize:(CGSize)size {
    CGPoint exposePoint = [self transtionPoint:point size:size];
    if (!CGPointEqualToPoint(exposePoint, CGPointZero)) {
        [self exposeAtPoint:exposePoint];
    }
}

- (void)exposeAtPoint:(CGPoint)point {
    AVCaptureExposureMode mode = AVCaptureExposureModeContinuousAutoExposure;
    if (self.device.isExposurePointOfInterestSupported && [self.device isExposureModeSupported:mode]) {
        [self changeDeviceStatus:^{
            self.device.exposurePointOfInterest = point;
            self.device.exposureMode = mode;
        }];
    }
}

- (CGPoint)transtionPoint:(CGPoint)point size:(CGSize)size {
    if (point.x > size.width || point.y > size.height) {
        if ([self.delegate respondsToSelector:@selector(cameraChangeStatusFail:)]) {
            MainQueueSafe(^{
                [self.delegate cameraChangeStatusFail:@"调整点位不正确"];
            });
            return CGPointZero;
        }
    }
    return CGPointMake(point.x / size.width, point.y / size.height);
}

- (void)resetFocusAndExposureModes {
    CGPoint center = CGPointMake(0.5, 0.5);
    [self focusAtPoint:center];
    [self exposeAtPoint:center];
}

- (void)changeDeviceStatus:(void(^)(void))block {
    NSError * err;
    if ([self.device lockForConfiguration:&err]) {
        block();
        [self.device unlockForConfiguration];
    } else if([self.delegate respondsToSelector:@selector(cameraChangeStatusFail:)]){
        MainQueueSafe(^{
            [self.delegate cameraChangeStatusFail:err.localizedDescription];
        });
    } else {
        NSLog(@"状态修改错误:%@",err.localizedDescription);
    }
}

#pragma mark - Delegate


/// iOS10~11 拍照完成
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    NSData * data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    [self converImgData:data error:error];
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error  API_AVAILABLE(ios(11.0)){
    [self converImgData:[photo fileDataRepresentation] error:error];
}

- (void)converImgData:(NSData *)data error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(cameraPhotoImage:error:)]) {
        UIImage * img = nil;
        if (!error) {
            img = [UIImage imageWithData:data];
        }
        MainQueueSafe(^{
            [self.delegate cameraPhotoImage:img error:error];
        });
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (output == self.videoOutput) {
        //视频处理
//        if ([self.delegate respondsToSelector:@selector(cameraFrameImage:)]) {
//            UIImage * image = [self imageFromSampleBuffer:sampleBuffer];
//            MainQueueSafe(^{
//                [self.delegate cameraFrameImage:image];
//            });
//        }
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
    
    AVCaptureInput * deviceInput = self.cameraInput;
    
    //请求输入流(这步会申请权限)
    NSError * err;
    self.cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&err];
    
    if (!err) {
        [self.session beginConfiguration];
        [self reSetInput:deviceInput add:NO];
        [self reSetInput:self.cameraInput add:YES];
        [self.session commitConfiguration];
    } else {
        if ([self.delegate respondsToSelector:@selector(cameraLoadFail:)]) {
            MainQueueSafe(^{
                [self.delegate cameraLoadFail:err.localizedDescription];
            });
        }
    }
}

- (void)configPhotoStream:(BQCameraType)type {
    BOOL add = type & BQCameraType_Photo;
    [self reSetOutput:self.photoOutput add:add];
}

- (void)configVideoStream:(BQCameraType)type {
    BOOL add = type & BQCameraType_Video;
    [self reSetOutput:self.videoOutput add:add];
}

- (void)configAudioStream:(BQCameraType)type {
    BOOL add = type & BQCameraType_Audio;
    [self reSetInput:self.audioInput add:add];
    [self reSetOutput:self.audioOutput add:add];
}

- (void)configMetaStream:(BQCameraType)type {
    BOOL add = type & BQCameraType_Scan;
    [self reSetOutput:self.metaOutput add:add];
    if (add) {
        self.metaOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code];
    }
}

- (void)reSetInput:(AVCaptureInput *)input add:(BOOL)add {
    if (add) {
        if ([self.session canAddInput:input]) {
            [self.session addInput:input];
        }
    } else {
        if ([self.session.inputs containsObject:input]) {
            [self.session removeInput:input];
        }
    }
}

- (void)reSetOutput:(AVCaptureOutput *)output add:(BOOL)add {
    if (add) {
        if ([self.session canAddOutput:output]) {
            [self.session addOutput:output];
        }
    } else {
        if ([self.session.outputs containsObject:output]) {
            [self.session removeOutput:output];
        }
    }
}

- (void)configScanRect:(CGRect)rect superSize:(CGSize)size {
    self.metaOutput.rectOfInterest = CGRectMake(rect.origin.y/size.height, rect.origin.x/size.width, rect.size.height / size.height, rect.size.width / size.width);
}

- (void)configShowView:(UIView *)supView {
    [self configShowView:supView model:AVLayerVideoGravityResizeAspectFill];
}

- (void)configShowView:(UIView *)supView model:(AVLayerVideoGravity)model {
    if (supView.layer != self.showLayer.superlayer) {
        [self.showLayer removeFromSuperlayer];
        [supView.layer addSublayer:self.showLayer];
    }
    
    self.showLayer.frame = supView.bounds;
    self.showLayer.videoGravity = model;
}

- (BOOL)setSeesionPreset:(AVCaptureSessionPreset)preset {
    if ([self.device supportsAVCaptureSessionPreset:preset] && [self.session canSetSessionPreset:preset]) {
        [self.session setSessionPreset:preset];
        return YES;
    }
    return NO;
}

- (void)setType:(BQCameraType)type {
    _type = type;
    dispatch_async(self.queue, ^{
        [self.session beginConfiguration];

        [self configPhotoStream:type];
        [self configMetaStream:type];
        [self configVideoStream:type];

        [self.session commitConfiguration];
        
        [self resetFocusAndExposureModes];
    });
}

#pragma mark - *** get

- (AVCaptureVideoPreviewLayer *)showLayer {
    if (_showLayer == nil) {
        AVCaptureVideoPreviewLayer * showLayer = [[AVCaptureVideoPreviewLayer alloc] init];
        [showLayer setSession:self.session];
        _showLayer = showLayer;
    }
    return _showLayer;
}

- (AVCaptureOutput *)videoOutput {
    if (_videoOutput == nil) {
        AVCaptureVideoDataOutput * videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        videoOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey, nil];
        [videoOutput setSampleBufferDelegate:self queue:self.queue];
        _videoOutput = videoOutput;
    }
    return _videoOutput;
}

- (AVCaptureMetadataOutput *)metaOutput {
    if (_metaOutput == nil) {
        AVCaptureMetadataOutput * metaOutput = [[AVCaptureMetadataOutput alloc] init];
        [metaOutput setMetadataObjectsDelegate:self queue:self.queue];
        _metaOutput = metaOutput;
    }
    return _metaOutput;
}

- (AVCapturePhotoOutput *)photoOutput {
    if (_photoOutput == nil) {
        AVCapturePhotoOutput * photoOutput = [[AVCapturePhotoOutput alloc] init];
        _photoOutput = photoOutput;
    }
    return _photoOutput;
}

- (AVCaptureDeviceInput *)audioInput {
    if (_audioInput == nil) {
        AVCaptureDeviceDiscoverySession * session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInMicrophone] mediaType:AVMediaTypeVideo position:self.postion];
        NSArray * deviceList = session.devices;
        if (deviceList.count > 0) {
            _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:deviceList[0] error:nil];
        }
    }
    return _audioInput;
}

- (AVCaptureAudioDataOutput *)audioOutput {
    if (_audioOutput == nil) {
        AVCaptureAudioDataOutput * audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [audioOutput setSampleBufferDelegate:self queue:self.queue];
        _audioOutput = audioOutput;
    }
    return _audioOutput;
}

@end

