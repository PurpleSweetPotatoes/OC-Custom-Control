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


@interface SpeedVc ()
@property (nonatomic, strong) BQTimer * timer;
@property (nonatomic, strong) BQDashBoradView * dashView;
@property (nonatomic, strong) UILabel * maxSpeedLab;
@property (nonatomic, strong) UILabel * avgSpeedLab;
@property (nonatomic, strong) UILabel * timeLab;
@property (nonatomic, copy) CLLocation  * preLocation;///<经纬度坐标
@property (nonatomic, assign) CLLocationSpeed  maxSpeed;
@property (nonatomic, assign) CLLocationSpeed  totalSpeed;
@property (nonatomic, assign) NSInteger  count;
@end

@implementation SpeedVc


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.maxSpeed = 0;
    [self configUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.timer start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer pause];
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)loadDeviceSpeed {
    WeakSelf;
    NSInteger hour = (NSInteger)self.timer.runTimes / 3600;
    NSInteger min = (NSInteger)((self.timer.runTimes % 3600) / 60);
    NSInteger second = (NSInteger)(self.timer.runTimes % 60);
    self.timeLab.text = [NSString stringWithFormat:@"总耗时: %02zd:%02zd:%02zd", hour, min, second];
    [BQLocationManager startLoadLocationCallBack:^(LocationInfo *locationInfo, NSError *error) {
        
        if (locationInfo) {
            CLLocationSpeed speed = 0;
            
            NSString * errorMsg = @"";
            if ([locationInfo.location.timestamp compare:self.preLocation.timestamp] == NSOrderedAscending) { //
                errorMsg = @"定位超时无效";
            } else if (locationInfo.location.horizontalAccuracy <= 0) {
//                errorMsg = @"准确性无效";
            } else if (locationInfo.location.speed == -1) {
//                errorMsg = @"速度无效";
            }
            
            if (errorMsg.length > 0) {
                NSLog(@"定位失败: %@", errorMsg);
                return;
            }
            
            speed = locationInfo.location.speed;
            if (weakSelf.preLocation && speed == -1) {
                CLLocationDistance distance = ABS([locationInfo.location distanceFromLocation:weakSelf.preLocation]);
                NSTimeInterval time = ABS([locationInfo.location.timestamp timeIntervalSinceDate:self.preLocation.timestamp]);
                speed = distance / time;
                NSLog(@"计算速度:%.2f, 时间:%@ 距离:%.2f",speed, locationInfo.location.timestamp, distance);
                [weakSelf resetStatus:speed];
            }
            weakSelf.preLocation = locationInfo.location;
        } else {
            NSLog(@"定位失败:%@",error.localizedDescription);
        }
    }];
}
#pragma mark - *** Delegate

#pragma mark - *** Instance method

- (void)resetStatus:(CLLocationSpeed)speed {
    self.count += 1;
    CGFloat hourSpeed = speed * 3.6;
    self.totalSpeed += hourSpeed;
    if (speed > self.maxSpeed) {
        self.maxSpeed = speed;
        self.maxSpeedLab.text = [NSString stringWithFormat:@"%.2f\n最高时速\nkm/h", hourSpeed];
    }
    self.avgSpeedLab.text = [NSString stringWithFormat:@"%.2f\n平均时速\nkm/h", self.totalSpeed / self.count];
    
    [self.dashView reSetSpeed:hourSpeed];
}
#pragma mark - *** UI method

- (void)configUI {
    [self.view addSubview:self.dashView];
    [self.view addSubview:self.avgSpeedLab];
    [self.view addSubview:self.maxSpeedLab];
    [self.view addSubview:self.timeLab];
}

#pragma mark - *** Set

#pragma mark - *** Get
    

- (BQTimer *)timer {
    if (_timer == nil) {
        BQTimer * timer = [BQTimer configWithScheduleTime:1 target:self selector:@selector(loadDeviceSpeed)];
        [timer pause];
        _timer = timer;
    }
    return _timer;
}

- (BQDashBoradView *)dashView {
    if (_dashView == nil) {
        BQDashBoradView * dashView = [[BQDashBoradView alloc] initWithFrame:CGRectMake((self.view.width - 240) * 0.5, self.navbarBottom + 60, 240, 240) ringWidth:10 areaNum:12 areaDailNum:2 maxNum:120];
        NSMutableArray * arr = [NSMutableArray arrayWithCapacity:13];
        for (NSInteger i = 0; i <= 12; i++) {
            arr[i] = [NSString stringWithFormat:@"%zd", i * 10];
        }
        [dashView setDailTextList:[arr copy]];
        _dashView = dashView;
    }
    return _dashView;
}

- (UILabel *)maxSpeedLab {
    if (_maxSpeedLab == nil) {
        UILabel * maxSpeedLab = [UILabel labWithFrame:self.avgSpeedLab.frame title:@"0\n最高时速\nkm/h" font:[UIFont fontWithName:@"Helvetica Neue" size:28] textColor:[UIColor whiteColor]];
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
        UILabel * avgSpeedLab = [UILabel labWithFrame:CGRectMake(0, self.dashView.bottom + 20, self.view.width * 0.5, 120) title:@"0\n平均时速\nkm/h" font:[UIFont fontWithName:@"Helvetica Neue" size:28] textColor:[UIColor whiteColor]];
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

@end
