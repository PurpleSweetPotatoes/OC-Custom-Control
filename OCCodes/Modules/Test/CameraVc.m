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
#import "BQGestureView.h"
#import "ScanView.h"
#import "UIColor+Custom.h"
#import "UIImageView+Custom.h"
#import "UILabel+Custom.h"
#import "UIViewController+Custom.h"
#import "BQAlertSheetView.h"

@interface CameraVc ()
<
BQCameraManagerDelegate
,CAAnimationDelegate
,BQGestureViewDelegate
>
@property (nonatomic, strong) UIView            * bottomView;
@property (nonatomic, assign) CALayer           * btnLayer;
@property (nonatomic, strong) BQCameraManager   * cameraManager;
@property (nonatomic, strong) BQGestureView * gestureV;
@property (nonatomic, assign) UIButton          * preBtn;
@property (nonatomic, strong) ScanView          * scanV;
@property (nonatomic, strong) UIView            * showV;
@property (nonatomic, strong) UIView            * topView;
@property (nonatomic, strong) UIButton          * photoBtn;
@property (nonatomic, strong) UIButton          * videoBtn;
@property (nonatomic, strong) UIButton          * flashBtn;
@property (nonatomic, strong) UIButton          * torchBtn;
@property (nonatomic, strong) CALayer * foucsLayer;     ///<  聚焦框
@end

@implementation CameraVc

#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self configUI];
    
    [self topBtnClick:[self.topView viewWithTag:100]];
    [self configFlashBtnImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.cameraManager startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.cameraManager stopRunning];
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)topBtnClick:(UIButton *)sender {

    if (sender == self.preBtn) return;
    
    self.preBtn.selected = !self.preBtn.isSelected;
    
    sender.selected = !sender.isSelected;
    self.preBtn = sender;
    self.btnLayer.left = self.preBtn.left;
    
    self.scanV.hidden = ![sender.currentTitle isEqualToString:@"扫描"];
    self.videoBtn.hidden = YES;
    self.photoBtn.hidden = YES;
    NSString * title = sender.currentTitle;
    if ([title isEqualToString:@"扫描"]) {
        self.showV.frame = self.scanV.frame;
        self.cameraManager.type = BQCameraType_Scan;
    } else if ([title isEqualToString:@"拍照"]) {
        self.showV.frame = self.gestureV.frame;
        self.cameraManager.type = BQCameraType_Photo;
        self.photoBtn.hidden = NO;
    } else if ([title isEqualToString:@"录像"]) {
        self.showV.frame = self.view.bounds;
        self.cameraManager.type = BQCameraType_Video;
        self.videoBtn.hidden = NO;
    }
    [self.cameraManager configShowView:self.showV];
}

- (void)flashBtnClick {
    if (self.cameraManager.type & BQCameraType_Photo) {
        [BQAlertSheetView showSheetViewWithTitles:@[@"关闭",@"打开",@"自动"] callBlock:^(NSInteger index, NSString *title) {
            self.cameraManager.flashModel = index;
            [self configFlashBtnImage];
        }];
    } else {
        [BQTipView showInfo:@"非拍照状态下不可用"];
    }
}

- (void)configFlashBtnImage {
    NSArray * flashNames = @[@"camera_flash_close", @"camera_flash_open", @"camera_flash_auto"];
    NSString * flashName = flashNames[self.cameraManager.flashModel];
    [self.flashBtn setImage:[UIImage imageNamed:flashName] forState:UIControlStateNormal];
}

- (void)photoBtnClick {
    if (self.cameraManager.type & BQCameraType_Photo) {
        [self.cameraManager takePhoto];
    } else {
        [BQTipView showInfo:@"非拍照状态下不可用"];
    }
}

- (void)videoBtnClick:(UIButton *)sender {
    
}

- (void)torchBtnClick {
    [BQAlertSheetView showSheetViewWithTitles:@[@"关闭",@"打开"] callBlock:^(NSInteger index, NSString *title) {
        self.cameraManager.torchMode = index;
        self.torchBtn.selected = index == 1;
    }];
}

#pragma mark - *** Delegate
- (void)cameraLoadFail:(NSString *)fail {
    [BQTipView showInfo:fail];
}

- (void)cameraChangeStatusFail:(NSString *)fail {
    [BQTipView showInfo:fail];
}

- (void)cameraScanInfo:(NSString *)info bounds:(CGRect)bounds {
    
    if (self.scanV.isHidden) return;
        
    [BQTipView showInfo:info];
    [self.cameraManager stopRunning];
}

/// 使用默认output有效
- (void)cameraPhotoImage:(UIImage *)image error:(NSError *)error {
    if (!error) {
        [BQShowImageView showImage:image frame:self.showV.frame];
    } else {
        [BQTipView showInfo:error.localizedDescription];
    }
    self.torchBtn.selected = AVCaptureTorchModeOn == self.cameraManager.torchMode;
}

#pragma mark - *** BQGestureView Delegate

- (void)gestureView:(BQGestureView *)view tapPoint:(CGPoint)point {
    if (!self.scanV.hidden) return;
    
    [self.cameraManager focusAtPoint:point vSize:view.size];
    [self.cameraManager exposeAtPoint:point vSize:view.size];
    [self focusLayerAnimation:point];
}

- (void)gestureViewPinBegin:(BQGestureView *)view {
    view.pinValue = self.cameraManager.device.videoZoomFactor;
}

- (void)gestureViewPinChange:(BQGestureView *)view changeValue:(CGFloat)value {
    [self.cameraManager setVideoZoomFactor:value];
}

- (void)gestureViewSwip:(BQGestureView *)view toLeft:(BOOL)toLeft {
    NSInteger tag = self.preBtn.tag + (toLeft? -1:1);
    if (tag < 100 || tag > 102) return;
    [self topBtnClick:[self.topView viewWithTag:tag]];
}

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    [self.view addSubview:self.showV];
    [self.view addSubview:self.scanV];
    [self.view addSubview:self.gestureV];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
}

- (void)focusLayerAnimation:(CGPoint)point {
    CALayer *focusLayer = self.foucsLayer;
    focusLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [focusLayer setPosition:point];
    focusLayer.transform = CATransform3DMakeScale(2.0f,2.0f,1.0f);
    [CATransaction commit];
    
    CABasicAnimation *animation = [ CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.toValue = [ NSValue valueWithCATransform3D: CATransform3DMakeScale(1.0f,1.0f,1.0f)];
    animation.delegate = self;
    animation.duration = 0.3f;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [focusLayer addAnimation: animation forKey:@"animation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.foucsLayer.hidden = YES;
    [self.foucsLayer removeAllAnimations];
}

#pragma mark - *** Set

#pragma mark - *** Get

- (BQCameraManager *)cameraManager {
    if (_cameraManager == nil) {
        BQCameraManager * cameraManager = [BQCameraManager managerWithDelegate:self];
        _cameraManager = cameraManager;
    }
    return _cameraManager;
}

- (UIView *)topView {
    if (_topView == nil) {
        UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.isPhoneX ? 88 : 64)];
        topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(15, self.isPhoneX ? 44 : 20, 44, 44);
        [backBtn setImage:[UIImage imageNamed:@"item_bakc"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchDown];
        [topView addSubview:backBtn];
        
        NSArray * arr = @[@"拍照", @"录像", @"扫描"];
        CGFloat btnW = 50;
        CGFloat left = topView.width * 0.5 - (arr.count / 2.0) * btnW;
        for (NSInteger i = 0; i < arr.count; i++) {
            NSString * title = arr[i];
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(left + btnW * i, backBtn.top, btnW, backBtn.height);
            btn.tag = 100 + i;
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitle:title forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [topView addSubview:btn];
            if (i == 0) {
                _btnLayer = [CALayer layerWithFrame:CGRectMake(btn.left, btn.bottom - 4, btn.width, 1) color:[UIColor whiteColor]];
            }
        }
        
        [topView.layer addSublayer:_btnLayer];
        
        _topView = topView;
    }
    return _topView;
}

- (ScanView *)scanV {
    if (_scanV == nil) {
        ScanView * scanV = [[ScanView alloc] initWithFrame:self.gestureV.frame scanFrame:CGRectMake((self.gestureV.width - 200) * 0.5, (self.gestureV.height - 200) * 0.5 - 50, 200, 200)];
        _scanV = scanV;
    }
    return _scanV;
}

- (BQGestureView *)gestureV {
    if (_gestureV == nil) {
        BQGestureView * gestureV = [[BQGestureView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.topView.width, self.bottomView.top - self.topView.bottom)];
        gestureV.delegate = self;
        _gestureV = gestureV;
    }
    return _gestureV;
}

- (UIView *)showV {
    if (_showV == nil) {
        UIView * showV = [[UIView alloc] initWithFrame:CGRectZero];
        _showV = showV;
    }
    return _showV;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        CGFloat height = self.isPhoneX ? 100 : 80;
        CGFloat top = self.isPhoneX ? -10: 0 ;
        UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - height, self.view.width, height)];
        bottomView.backgroundColor = self.topView.backgroundColor;
        self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = 50;
        self.photoBtn.frame = CGRectMake((bottomView.width - btnW) * 0.5, (bottomView.height - btnW) * 0.5  + top, btnW, btnW);
        [self.photoBtn setImage:[UIImage imageNamed:@"camera_take_photo"] forState:UIControlStateNormal];
        [self.photoBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:self.photoBtn];
        
        self.flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.flashBtn.frame = CGRectMake((self.photoBtn.left - 30)  * 0.5, (bottomView.height - 30) * 0.5 + top, 30, 30);
        [self.flashBtn addTarget:self action:@selector(flashBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:self.flashBtn];
        
        self.videoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.videoBtn.frame = self.photoBtn.frame;
        [self.videoBtn addTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.videoBtn setImage:[UIImage imageNamed:@"camera_start_video"] forState:UIControlStateNormal];
        [self.videoBtn setImage:[UIImage imageNamed:@"camera_stop_video"] forState:UIControlStateSelected];
        [bottomView addSubview:self.videoBtn];
        
        self.torchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.torchBtn.frame = CGRectMake(self.photoBtn.right + (self.view.width - self.photoBtn.right - 60)  * 0.5, (bottomView.height - 50) * 0.5 + top, 60, 50);
        [self.torchBtn setImage:[UIImage imageNamed:@"camera_torch_off"] forState:UIControlStateNormal];
        [self.torchBtn setImage:[UIImage imageNamed:@"camera_torch_open"] forState:UIControlStateSelected];
        [self.torchBtn addTarget:self action:@selector(torchBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:self.torchBtn];
        
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (CALayer *)foucsLayer {
    if (_foucsLayer == nil) {
        CALayer * foucslayer = [CALayer layer];
        foucslayer.bounds = CGRectMake(0, 0, 60, 60);
        foucslayer.contents = (__bridge id)[UIImage imageNamed:@"camera_foucs"].CGImage;
        foucslayer.hidden = YES;
        [self.gestureV.layer addSublayer:foucslayer];
        _foucsLayer = foucslayer;
    }
    return _foucsLayer;
}

@end
