// *******************************************
//  File Name:      CameraVc.m       
//  Author:         MrBai
//  Created Date:   2021/12/20 1:55 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "CameraVc.h"

#import "BQCameraManager.h"
#import "BQTimer.h"
#import "BQTipView.h"
#import "CALayer+Custom.h"
#import "UIColor+Custom.h"
#import "UIViewController+Custom.h"

@interface CameraVc ()
<
BQCameraManagerDelegate
>
@property (nonatomic, strong) UIImageView * showImgV;
@property (nonatomic, strong) BQCameraManager * cameraManager;

@property (nonatomic, strong) CALayer * guideLayer;
@property (nonatomic, strong) CAShapeLayer * borderLayer;
@property (nonatomic, strong) CALayer * animationLayer;
@end

@implementation CameraVc


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.cameraManager startRunning];
//    [self.timer start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.cameraManager stopRunning];
//    [self.timer pause];
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action


//- (void)timeChange {
//    if (self.showImgV.image) {
//        NSLog(@"图片检测");
//        CIDetector * detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
//        CIImage * image = [CIImage imageWithCGImage:self.showImgV.image.CGImage];
//        NSArray * features = [detector featuresInImage:image];
//        if (features.count >= 1) {
//            CIQRCodeFeature * feature = features.firstObject;
//            NSLog(@"扫描位置: %@, 结果: %@",NSStringFromCGRect(feature.bounds), feature.messageString);
//        }
//        NSLog(@"检查完毕");
//    }
//}
#pragma mark - *** Delegate
- (void)cameraLoadFail:(NSString *)fail {
    [BQTipView showInfo:fail];
}

- (void)cameraChangeStatusFail:(NSString *)fail {
    [BQTipView showInfo:fail];
}

- (void)cameraScanInfo:(NSString *)info bounds:(CGRect)bounds {
    
    [BQTipView showInfo:info];
    
    [self.cameraManager stopRunning];
}

/// 使用默认output有效
- (void)cameraFrameImage:(UIImage *)image {
    self.showImgV.image = image;
}
#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    [self.view addSubview:self.showImgV];
    
    [self.guideLayer addSublayer:self.borderLayer];
    [self.guideLayer addSublayer:self.animationLayer];
    [self.showImgV.layer addSublayer:self.guideLayer];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - *** Set

#pragma mark - *** Get
    

- (UIImageView *)showImgV {
    if (_showImgV == nil) {
        UIImageView * showImgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        showImgV.contentMode = UIViewContentModeScaleAspectFit;
        _showImgV = showImgV;
    }
    return _showImgV;
}

- (BQCameraManager *)cameraManager {
    if (_cameraManager == nil) {
        BQCameraManager * cameraManager = [BQCameraManager configManagerWithDelegate:self];
        _cameraManager = cameraManager;
    }
    return _cameraManager;
}

//- (BQTimer *)timer {
//    if (_timer == nil) {
//        BQTimer * timer = [BQTimer configWithScheduleTime:0.3 target:self selector:@selector(timeChange)];
//        [timer pause];
//        _timer = timer;
//    }
//    return _timer;
//}

- (CALayer *)guideLayer {
    if (_guideLayer == nil) {
        CALayer * guideLayer = [CALayer guideLayerWithFrame:self.borderLayer.frame];

        [self.cameraManager configScanRect:self.borderLayer.frame superSize:guideLayer.size];
        
        _guideLayer = guideLayer;
    }
    return _guideLayer;
}

- (CAShapeLayer *)borderLayer {
    if (_borderLayer == nil) {
        CAShapeLayer * borderLayer = [CAShapeLayer layer];
        borderLayer.frame = CGRectMake((self.showImgV.width - 200) * 0.5, (self.showImgV.height - 200) * 0.5 - 50, 200, 200);
        
        CGFloat lineW = 20;
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, lineW)];
        [path addLineToPoint:CGPointZero];
        [path addLineToPoint:CGPointMake(lineW, 0)];
        
        [path moveToPoint:CGPointMake(borderLayer.width - lineW, 0)];
        [path addLineToPoint:CGPointMake(borderLayer.width , 0)];
        [path addLineToPoint:CGPointMake(borderLayer.width, lineW)];
        
        [path moveToPoint:CGPointMake(borderLayer.width, borderLayer.height - lineW)];
        [path addLineToPoint:CGPointMake(borderLayer.width, borderLayer.height)];
        [path addLineToPoint:CGPointMake(borderLayer.width - lineW, borderLayer.height)];
        
        [path moveToPoint:CGPointMake(lineW, borderLayer.height)];
        [path addLineToPoint:CGPointMake(0, borderLayer.height)];
        [path addLineToPoint:CGPointMake(0, borderLayer.height - lineW)];
        
        borderLayer.lineWidth = 4;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [UIColor greenColor].CGColor;
        borderLayer.path = path.CGPath;
        
        _borderLayer = borderLayer;
    }
    return _borderLayer;
}

- (CALayer *)animationLayer {
    if (_animationLayer == nil) {
        CAShapeLayer * animationLayer = [CAShapeLayer layer];
        animationLayer.frame = CGRectMake(self.borderLayer.left + 5, 0, self.borderLayer.width - 10, 4);
        animationLayer.backgroundColor = self.borderLayer.strokeColor;
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        animation.fromValue = @(self.borderLayer.top + 2);
        animation.toValue = @(self.borderLayer.bottom - 2);
        animation.duration = 2.5;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.repeatCount = 1000;
        [animationLayer addAnimation:animation forKey:@"animationLayer"];
        _animationLayer = animationLayer;
    }
    return _animationLayer;
}

@end
