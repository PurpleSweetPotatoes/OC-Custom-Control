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
#import "NSString+Custom.h"
#import <Photos/Photos.h>

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
@property (nonatomic, strong) AVCaptureOutput            * videoOutput; ///<  默认使用32RGB类型的videoDataOutput
@property (nonatomic, strong) AVCaptureAudioDataOutput   * audioOutput;
@property (nonatomic, strong) AVCaptureMetadataOutput    * metaOutput;

@property (nonatomic, assign) RecordStatus               recordStatus;
@property (nonatomic, assign) CMTime                     startTime;  ///< 开始录制点时间
@property (nonatomic, assign) NSTimeInterval             recordDuration; ///< 录制时长
@property (nonatomic, strong) AVAssetWriter              * assetWriter;
@property (nonatomic, strong) AVAssetWriterInput         * videoWrite;
@property (nonatomic, strong) AVAssetWriterInput         * audioWrite;
@property (nonatomic, assign) CMTime                     lastVideoTime;
@property (nonatomic, assign) CMTime                     videoOffset;
@property (nonatomic, assign) BOOL                       reSetOffsetV;
@property (nonatomic, assign) CMTime                     lastAudioTime;
@property (nonatomic, assign) CMTime                     audioOffset;
@property (nonatomic, assign) BOOL                       reSetOffsetA;
@end

@implementation BQCameraManager

- (void)dealloc {
    NSLog(@"设备管理释放");
    CGColorSpaceRelease(_colorSpace);
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
    manager.recordStatus = RecordStatus_Disabled;
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
        dispatch_async(self.queue, ^{
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
    if (_type & BQCameraType_Scan) {
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
    if (!self.isRun) return;
    
    if (_type & BQCameraType_Photo) {
        
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

/// 手电筒操作
- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
    if (self.device.torchMode == torchMode) return;
    
    if ([self.device isTorchModeSupported:torchMode] && self.postion == AVCaptureDevicePositionBack) {
        [self changeDeviceStatus:^{
            self.device.torchMode = torchMode;
        }];
    } else {
        if ([self.delegate respondsToSelector:@selector(cameraChangeStatusFail:)]) {
            [self.delegate cameraChangeStatusFail:@"不支持手电筒模式"];
        }
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

#pragma mark - *** Record

- (void)startRecord {

    if (self.isRun && self.recordStatus == RecordStatus_Ready) {
        self.assetWriter = [self configAssetWriter];
        if ([self.assetWriter startWriting]) {
            self.recordStatus = RecordStatus_Start;
            if ([self.delegate respondsToSelector:@selector(cameraStartRecordVideo)]) {
                [self.delegate cameraStartRecordVideo];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(cameraRecordVideoFail:)]) {
                [self.delegate cameraRecordVideoFail:self.assetWriter.error.localizedDescription];
            }
        }
    }
}

- (void)pauseRecord {
    NSLog(@"暂停录像");
    self.recordStatus = RecordStatus_Pause;
}

- (void)resumeRecord {
    NSLog(@"继续录像");
    self.reSetOffsetA = YES;
    self.reSetOffsetV = YES;
    self.recordStatus = RecordStatus_Record;
}

- (void)stopRecord {
    NSLog(@"停止录制");
    if (self.recordStatus == RecordStatus_Record || self.recordStatus == RecordStatus_Pause) {
        NSLog(@"录制状态修改");
        self.recordStatus = RecordStatus_Completed;
        [self.assetWriter finishWritingWithCompletionHandler:^{
            NSLog(@"停止录制完成");
            MainQueueSafe(^{
                if ([self.delegate respondsToSelector:@selector(cameraRecordVideoCompleted:)]) {
                    [self.delegate cameraRecordVideoCompleted:[self videoFilePath]];
                }
            });
            self.recordStatus = RecordStatus_Ready;
        }];
    }
}

- (CGAffineTransform)getVideoTransForm {
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortraitUpsideDown:
            return CGAffineTransformRotate(CGAffineTransformIdentity, (M_PI * -90.0) / 180.0);
        case UIDeviceOrientationLandscapeLeft:
            return CGAffineTransformRotate(CGAffineTransformIdentity, (M_PI * -180.0) / 180.0);
        case UIDeviceOrientationLandscapeRight:
            return CGAffineTransformRotate(CGAffineTransformIdentity, (M_PI * 0.0) / 180.0);
        default:
            return CGAffineTransformRotate(CGAffineTransformIdentity, (M_PI * 90.0) / 180.0);;
    }
}

- (NSString *)videoFilePath {
    return [@"bqcameraVideo.mp4" appendTempPath];
}

#pragma mark - *** Delegate


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
    
    if (self.recordStatus == RecordStatus_Start) { //开始需要写入时间
        if (output == self.videoOutput) {
            self.startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            [self.assetWriter startSessionAtSourceTime:self.startTime];
            self.videoOffset = kCMTimeZero;
            self.audioOffset = kCMTimeZero;
            self.lastVideoTime = kCMTimeZero;
            self.lastAudioTime = kCMTimeZero;
            self.recordStatus = RecordStatus_Record;
            NSLog(@"初始化开始时间: %lf", CMTimeGetSeconds(self.startTime));
        }
    } else if (self.recordStatus ==  RecordStatus_Pause) {
        if (output == self.videoOutput) { //视频处理
            if (!CMTimeCompare(self.lastVideoTime, kCMTimeZero)) {
                self.lastVideoTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                NSLog(@"记录视频最后时间");
            }
        } else if (output == self.audioOutput) {
            if (!CMTimeCompare(self.lastAudioTime, kCMTimeZero)) {
                self.lastAudioTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                NSLog(@"记录音频最后时间");
            }
        }
    }
    
    if (self.recordStatus == RecordStatus_Record) {
        CMTime time = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        if (output == self.videoOutput) { //视频处理
            if (self.reSetOffsetV) {
                self.videoOffset = [self getOffsetTime:self.videoOffset currtime:time lastTime:self.lastVideoTime];
                NSLog(@"视频新偏移量: %lld -- %d", self.videoOffset.value, self.videoOffset.timescale);
                self.lastVideoTime = kCMTimeZero;
                self.reSetOffsetV = NO;
            }
            [self writeBuffer:sampleBuffer inInput:self.videoWrite offset:self.videoOffset];
            
            if ([self.delegate respondsToSelector:@selector(cameraRecordTimeChange:)] || self.maxDuration > 0) { // 有回调或最大时长限制需要计算时间
                time = CMTimeSubtract(time, self.startTime);
                if (CMTimeCompare(self.videoOffset, kCMTimeZero)) {
                    time = CMTimeSubtract(time, self.videoOffset);
                }
                NSTimeInterval duration = CMTimeGetSeconds(time);
                if (duration - self.recordDuration >= 0.1) {
                    self.recordDuration = duration;
                    MainQueueSafe(^{
                        [self.delegate cameraRecordTimeChange:duration];
                    });
                }

                if (self.maxDuration > 0 && duration >= self.maxDuration) { // 最大时长限制
                    [self stopRecord];
                }
            }
        } else if (output == self.audioOutput) { //音频处理
            if (self.reSetOffsetA) {
                self.audioOffset = [self getOffsetTime:self.audioOffset currtime:time lastTime:self.lastAudioTime];
                NSLog(@"音频新偏移量: %lld -- %d", self.audioOffset.value, self.audioOffset.timescale);
                self.lastAudioTime = kCMTimeZero;
                self.reSetOffsetA = NO;
            }
            [self writeBuffer:sampleBuffer inInput:self.audioWrite offset:self.audioOffset];
        }
    }
}

/// 偏移时间计算
/// @param offset 原偏移时间
/// @param curTime 当前时间
/// @param lastTime 暂停前时间
- (CMTime)getOffsetTime:(CMTime)offset currtime:(CMTime)curTime lastTime:(CMTime)lastTime {
    CMTime offsetTime = CMTimeSubtract(curTime, lastTime);
    if (CMTimeCompare(offset, kCMTimeZero)) {
        return CMTimeAdd(offset, offsetTime);;
    }
    return offsetTime;
}

- (void)writeBuffer:(CMSampleBufferRef)sample inInput:(AVAssetWriterInput *)input offset:(CMTime)offset {
    if ([input isReadyForMoreMediaData]) {
        if (CMTimeCompare(offset, kCMTimeZero)) {
            CMSampleBufferRef buffer = [self adjustTime:sample by:offset];
            [input appendSampleBuffer:buffer];
            CFRelease(buffer);
        } else {
            [input appendSampleBuffer:sample];
        }
    } else {
        NSLog(@"数据写入失败");
    }
}

//调整媒体数据的时间
- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset {
    CMItemCount count;
    CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
    CMSampleTimingInfo* pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
    CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
    for (CMItemCount i = 0; i < count; i++) {
        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
    }
    CMSampleBufferRef sout;
    CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
    free(pInfo);
    return sout;
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
            [weakSelf startRunning];
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

- (void)configPhotoStream {
    BOOL add = _type & BQCameraType_Photo;
    [self reSetOutput:self.photoOutput add:add];
}

- (void)configVideoStream {
    BOOL add = _type & BQCameraType_Video;
    self.recordStatus = RecordStatus_Ready;
    [self reSetOutput:self.videoOutput add:add];
}

- (void)configAudioStream {
    BOOL add = _type & BQCameraType_Audio;
    [self reSetInput:self.audioInput add:add];
    [self reSetOutput:self.audioOutput add:add];
}

- (void)configMetaStream {
    BOOL add = _type & BQCameraType_Scan;
    [self reSetOutput:self.metaOutput add:add];
    if (add) {
        self.metaOutput.metadataObjectTypes = [self.metaOutput availableMetadataObjectTypes];
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

- (AVAssetWriter *)configAssetWriter {
    NSString * filePath = [self videoFilePath];
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath] && [manager removeItemAtPath:filePath error:nil]) {
        NSLog(@"存在文件,删除文件");
    }
    AVAssetWriter * assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:filePath] fileType:AVFileTypeMPEG4 error:nil];
    assetWriter.movieFragmentInterval = kCMTimeInvalid;
    assetWriter.shouldOptimizeForNetworkUse = YES;
    
    CGFloat width = self.showLayer.bounds.size.width;
    CGFloat height = self.showLayer.bounds.size.height;

    //每像素比特
    CGFloat bitsPerPixel = 12.0;
    NSInteger bitsPerSecond = width * height * bitsPerPixel;

    // 码率和帧率设置
    NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey : @(bitsPerSecond),
                                             AVVideoExpectedSourceFrameRateKey : @(15),
                                             AVVideoMaxKeyFrameIntervalKey : @(15),
                                             AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel };
    //视频属性
    NSDictionary * videoConfig = @{ AVVideoCodecKey : AVVideoCodecH264,
                                       AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                       AVVideoWidthKey : @(height * 2),
                                       AVVideoHeightKey : @(width * 2),
                                       AVVideoCompressionPropertiesKey : compressionProperties };
    self.videoWrite = [self configAssertWriteInput:AVMediaTypeVideo setting:videoConfig assetWriter:assetWriter];
    self.videoWrite.transform = [self getVideoTransForm];
    
    if (_type & BQCameraType_Audio) {
        NSDictionary * audioConfig = @{
            AVFormatIDKey: @(kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: @2,
            AVSampleRateKey: @44100.0,
            AVEncoderBitRateKey: @192000
        };
        self.audioWrite = [self configAssertWriteInput:AVMediaTypeAudio setting:audioConfig assetWriter:assetWriter];
    } else {
        self.audioWrite = nil;
    }
    
    return assetWriter;
}

- (AVAssetWriterInput *)configAssertWriteInput:(AVMediaType)type setting:(nullable NSDictionary<NSString *, id> *)settting assetWriter:(AVAssetWriter *)assetWrite {
    AVAssetWriterInput * input = [AVAssetWriterInput assetWriterInputWithMediaType:type outputSettings:settting];
    input.expectsMediaDataInRealTime = YES;
    if ([assetWrite canAddInput:input]) {
        [assetWrite addInput:input];
        NSLog(@"添加输入源成功");
    }
    return input;
}

- (void)configStreamsByType {
    [self configPhotoStream];
    [self configMetaStream];
    [self configVideoStream];
    [self configAudioStream];
}

- (BOOL)setSeesionPreset:(AVCaptureSessionPreset)preset {
    if ([self.device supportsAVCaptureSessionPreset:preset] && [self.session canSetSessionPreset:preset]) {
        [self.session setSessionPreset:preset];
        return YES;
    }
    return NO;
}

- (void)setType:(BQCameraType)type {
    if (_type == type) return;
    _type = type;
    
    if ((type & BQCameraType_Scan) && self.postion == AVCaptureDevicePositionFront) {
        [self switchCamera];
    }
    
    dispatch_async(self.queue, ^{ // 保证平滑切换
        [self.session beginConfiguration];
        [self configStreamsByType];
        [self.session commitConfiguration];
    });
}

#pragma mark - *** get

- (BOOL)isRun {
    return [self.session isRunning];
}

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
        if (_type & BQCameraType_Audio) { // 有使用才授权
            AVCaptureDevice * audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
            _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
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

