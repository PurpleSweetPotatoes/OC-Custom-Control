// *******************************************
//  File Name:      SpeedVc.m       
//  Author:         MrBai
//  Created Date:   2022/1/7 5:37 PM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "SpeedVc.h"

#import "BQDashBoradView.h"
#import "BQDefineInfo.h"
#import "BQLocationManager.h"
#import "BQTimer.h"
#import "CALayer+Custom.h"
#import "UILabel+Custom.h"
#import "BQTipView.h"

@interface SpeedVc ()
@property (nonatomic, strong) BQTimer * timer;
@property (nonatomic, strong) BQDashBoradView * dashView;
@property (nonatomic, strong) UILabel * maxSpeedLab;
@property (nonatomic, strong) UILabel * avgSpeedLab;
@property (nonatomic, strong) UILabel * timeLab;
@property (nonatomic, copy) CLLocation  * preLocation;///<经纬度坐标
@property (nonatomic, assign) CLLocationSpeed  maxSpeed;
@property (nonatomic, assign) CGFloat  totalSpeed;
@property (nonatomic, assign) NSInteger  speedCount;
@property (nonatomic, strong) UILabel * errorLab;
@property (nonatomic, strong) UIButton * navBtn;
@end

@implementation SpeedVc

#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.maxSpeed = 0;
    self.totalSpeed = 0;
    [self configUI];
    
}

- (void)dealloc {
    NSLog(@"清理数据");
    [self.timer clear];
    [BQLocationManager stopNavLocation];
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)navBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        [self.timer start];
        [self loadDeviceSpeed];
    } else {
        [self.timer pause];
        [BQLocationManager stopNavLocation];
        [self.dashView reSetSpeed:0];
    }
    sender.selected = !sender.selected;
}

- (void)timeChange {
    NSInteger hour = (NSInteger)self.timer.runTimes / 3600;
    NSInteger min = (NSInteger)((self.timer.runTimes % 3600) / 60);
    NSInteger second = (NSInteger)(self.timer.runTimes % 60);
    self.timeLab.text = [NSString stringWithFormat:@"总耗时: %02zd:%02zd:%02zd", hour, min, second];
    if (self.speedCount > 0) {
        self.avgSpeedLab.text = [NSString stringWithFormat:@"%.2f\n平均时速\nkm/h", self.totalSpeed / self.speedCount * 3.6];
    }
}

#pragma mark - *** Delegate

#pragma mark - *** Instance method

- (void)loadDeviceSpeed {
    WeakSelf;
    [BQLocationManager startLoadNavLocation:^(LocationInfo *locationInfo, NSError *error) {
        
        if (locationInfo) {
            NSString * errorMsg = @"";
            CLLocation * location = locationInfo.location;
            
            if ([location.timestamp compare:weakSelf.preLocation.timestamp] == NSOrderedAscending) { //
                errorMsg = @"定位超时无效";
            } else if (location.horizontalAccuracy <= 0 && location.horizontalAccuracy > 70) {
                errorMsg = @"准确性无效";
            } else if (location.speed == -1) {
                errorMsg = @"速度无效";
            }
            NSLog(@"定位信息: 速度:%lf 范围:%lf, 时间:%@", location.speed, location.horizontalAccuracy, location.timestamp);
            
            if (errorMsg.length > 0) {
                weakSelf.errorLab.text = [NSString stringWithFormat:@"定位失败: %@", errorMsg];
                weakSelf.errorLab.hidden = NO;
                return;
            }
            
            [weakSelf resetStatus:locationInfo.location];
        } else {
            NSLog(@"定位失败:%@",error.localizedDescription);
        }
    }];
}

- (void)resetStatus:(CLLocation *)location {
    
    self.speedCount += 1;
    self.totalSpeed += location.speed;
    self.preLocation = location;
    self.errorLab.hidden = YES;
    
    CGFloat hourSpeed = location.speed * 3.6;
    if (location.speed > self.maxSpeed) {
        self.maxSpeed = location.speed;
        self.maxSpeedLab.text = [NSString stringWithFormat:@"%.2f\n最高时速\nkm/h", hourSpeed];
    }
    [self.dashView reSetSpeed:hourSpeed];
}
#pragma mark - *** UI method

- (void)configUI {
    [self.view addSubview:self.dashView];
    [self.view addSubview:self.avgSpeedLab];
    [self.view addSubview:self.maxSpeedLab];
    [self.view addSubview:self.timeLab];
    [self.view addSubview:self.navBtn];
    [self.view addSubview:self.errorLab];
}

#pragma mark - *** Set

#pragma mark - *** Get
    

- (BQTimer *)timer {
    if (_timer == nil) {
        BQTimer * timer = [BQTimer configWithScheduleTime:1 target:self selector:@selector(timeChange)];
        _timer = timer;
    }
    return _timer;
}

- (BQDashBoradView *)dashView {
    if (_dashView == nil) {
        BQDashBoradView * dashView = [[BQDashBoradView alloc] initWithFrame:CGRectMake((self.view.width - 240) * 0.5, self.navbarBottom + 60, 240, 240) ringWidth:10 areaNum:12 areaDailNum:2 maxNum:120];
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:13];
        for (NSInteger i = 0; i <= 12; i++) {
            arr[i] = [NSString stringWithFormat:@"%ld", i * 10];
        }
        [dashView setDailTextList:[arr copy]];
        _dashView = dashView;
    }
    return _dashView;
}

- (UILabel *)maxSpeedLab {
    if (_maxSpeedLab == nil) {
        UILabel * maxSpeedLab = [UILabel labWithFrame:self.avgSpeedLab.frame title:@"0.00\n最高时速\nkm/h" font:[UIFont fontWithName:@"Helvetica Neue" size:28] textColor:[UIColor whiteColor]];
        maxSpeedLab.textAlignment = NSTextAlignmentCenter;
        maxSpeedLab.numberOfLines = 0;
        maxSpeedLab.left = self.avgSpeedLab.right;
        [maxSpeedLab.layer addSublayer:[CALayer layerWithFrame:CGRectMake(0, 0, 1, maxSpeedLab.height) color:[UIColor whiteColor]]];
        _maxSpeedLab = maxSpeedLab;
    }
    return _maxSpeedLab;
}

- (UILabel *)avgSpeedLab {
    if (_avgSpeedLab == nil) {
        UILabel * avgSpeedLab = [UILabel labWithFrame:CGRectMake(0, self.dashView.bottom + 20, self.view.width * 0.5, 120) title:@"0.00\n平均时速\nkm/h" font:[UIFont fontWithName:@"Helvetica Neue" size:28] textColor:[UIColor whiteColor]];
        avgSpeedLab.textAlignment = NSTextAlignmentCenter;
        avgSpeedLab.numberOfLines = 0;
        _avgSpeedLab = avgSpeedLab;
    }
    return _avgSpeedLab;
}

- (UILabel *)timeLab {
    if (_timeLab == nil) {
        UILabel * timeLab = [UILabel labWithFrame:CGRectMake(self.dashView.left, self.avgSpeedLab.bottom + 20, self.dashView.width, 50) title:@"总耗时: 00:00:00" font:[UIFont fontWithName:@"Helvetica Neue" size:20] textColor:[UIColor whiteColor]];
        timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab = timeLab;
    }
    return _timeLab;
}

- (UILabel *)errorLab {
    if (_errorLab == nil) {
        UILabel * lab = [UILabel labWithFrame:CGRectMake(0, self.navBtn.bottom + 20, self.view.width, 40) title:@"" fontSize:16 textColor:[UIColor whiteColor]];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.hidden = YES;
        _errorLab = lab;
    }
    return _errorLab;
}
- (UIButton *)navBtn {
    if (_navBtn == nil) {
        UIButton * navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        navBtn.frame = CGRectMake((self.view.width - 80) * 0.5, self.timeLab.bottom + 30, 80, 40);
        [navBtn setRadius:8];
        [navBtn setBorderWidth:1 color:[UIColor whiteColor]];
        [navBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [navBtn setTitle:@"开始" forState:UIControlStateNormal];
        [navBtn setTitle:@"完成" forState:UIControlStateSelected];
        _navBtn = navBtn;
    }
    return _navBtn;
}

@end
