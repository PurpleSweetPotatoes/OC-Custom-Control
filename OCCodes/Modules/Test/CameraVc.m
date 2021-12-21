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
#import "ScanView.h"
#import "UIColor+Custom.h"
#import "UILabel+Custom.h"
#import "UIViewController+Custom.h"
#import "CameraGestureView.h"
@interface CameraVc ()
<
BQCameraManagerDelegate
,CAAnimationDelegate
>
@property (nonatomic, strong) BQCameraManager   * cameraManager;
@property (nonatomic, strong) UIImageView       * showImgV;
@property (nonatomic, strong) CameraGestureView * gestureV;
@property (nonatomic, assign) CALayer           * btnLayer;
@property (nonatomic, assign) UIButton          * preBtn;
@property (nonatomic, strong) UIView            * topView;

@property (nonatomic, strong) ScanView          * scanV;

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
- (void)cameraFrameImage:(UIImage *)image {
    self.showImgV.image = image;
}

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.showImgV];
    [self.view addSubview:self.gestureV];
    
    [self.view addSubview:self.scanV];
    
    [self.cameraManager configScanRect:self.scanV.scanFrame superSize:self.showImgV.size];
}

#pragma mark - *** Set

#pragma mark - *** Get
    

- (UIImageView *)showImgV {
    if (_showImgV == nil) {
        UIImageView * showImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, self.view.width, self.view.height - self.topView.bottom)];
//        showImgV.contentMode = UIViewContentModeScaleAspectFit;
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
        ScanView * scanV = [[ScanView alloc] initWithFrame:self.showImgV.frame scanFrame:CGRectMake((self.showImgV.width - 200) * 0.5, (self.showImgV.height - 200) * 0.5 - 50, 200, 200)];
        _scanV = scanV;
    }
    return _scanV;
}

- (CameraGestureView *)gestureV {
    if (_gestureV == nil) {
        CameraGestureView * gestureV = [[CameraGestureView alloc] initWithFrame:self.showImgV.frame];
        gestureV.manager = self.cameraManager;
        _gestureV = gestureV;
    }
    return _gestureV;
}

@end
