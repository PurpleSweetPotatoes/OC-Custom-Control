// *******************************************
//  File Name:      LaunchAdVc.m       
//  Author:         MrBai
//  Created Date:   2022/1/4 2:47 PM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "LaunchAdVc.h"

#import "BQDefineInfo.h"
#import "BQLaunchAd.h"
#import "UIButton+Custom.h"

@interface LaunchAdVc ()
@property (nonatomic, strong) UIImageView * imgV;
@property (nonatomic, strong) UIButton * timeBtn;
@end

@implementation LaunchAdVc


#pragma mark - *** Public method
+ (void)show {
    BQLaunchConfig * config = [[BQLaunchConfig alloc] init];
    config.showVc = [[LaunchAdVc alloc] init];
    [BQLaunchAd setConfig:config];
}

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    WeakSelf;
    [self.timeBtn reduceTime:6 interval:1 callBlock:^(NSTimeInterval sec) {
        [weakSelf.timeBtn setTitle:[NSString stringWithFormat:@"%0.fs跳过", sec] forState:UIControlStateNormal];
        if (sec == 0) {
            [weakSelf timeBtnClick];
        }
    }];
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action
- (void)timeBtnClick {
    NSLog(@"关闭广告");
    [BQLaunchAd close];
}
#pragma mark - *** Delegate

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    [self.view addSubview:self.imgV];
    [self.view addSubview:self.timeBtn];
}

#pragma mark - *** Set

#pragma mark - *** Get
    

- (UIImageView *)imgV {
    if (_imgV == nil) {
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imgV.image = [UIImage imageNamed:@"collection_9.jpg"];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV = imgV;
    }
    return _imgV;
}

- (UIButton *)timeBtn {
    if (_timeBtn == nil) {
        UIButton * timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        timeBtn.frame = CGRectMake(self.view.width - 110, 100, 70, 30);
        timeBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [timeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [timeBtn setRadius:timeBtn.height * 0.5];
        [timeBtn addTarget:self action:@selector(timeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _timeBtn = timeBtn;
    }
    return _timeBtn;
}

@end
