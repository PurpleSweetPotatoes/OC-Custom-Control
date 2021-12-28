// *******************************************
//  File Name:      BQLaunchAd.m       
//  Author:         MrBai
//  Created Date:   2021/12/16 9:41 AM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQLaunchAd.h"

@interface BQLaunchAd ()
@property (nonatomic, strong) UIWindow * window;
@property (nonatomic, strong) BQLaunchConfig * config;
@end

@implementation BQLaunchAd

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self startShow];
    }];
}

+ (instancetype)shareAd {
    static BQLaunchAd * launchAd = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        launchAd = [[BQLaunchAd alloc] init];
    });
    return launchAd;
}

+ (void)setConfig:(BQLaunchConfig *)config {
    [self shareAd].config = config;
}

+ (void)startShow {
    BQLaunchAd * ad = [self shareAd];
    if (ad.config != nil) {
        UIWindow * launchW = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        launchW.windowLevel = UIWindowLevelStatusBar + 1;
        launchW.alpha = 1;
        launchW.hidden = NO;
        launchW.backgroundColor = [UIColor whiteColor];
        if (ad.config.showView == nil) {
            launchW.rootViewController = ad.config.showVc;
        } else {
            launchW.rootViewController = [[UIViewController alloc] init];
            [launchW.rootViewController.view addSubview:ad.config.showView];
        }
        ad.window = launchW;
    } else {
        NSLog(@"无启动图");
    }
}

+ (void)close {
    UIWindow * window = [self shareAd].window;
    if (window == nil) {
        return;
    }
    
    [UIView transitionWithView:window duration:[self shareAd].config.removeTime options:(UIViewAnimationOptions)[self shareAd].config.animateType animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        window.hidden = YES;
        [self clear];
    }];
}

+ (void)clear {
    BQLaunchAd * ad = [self shareAd];
    ad.config.showView = nil;
    ad.config.showVc = nil;
    ad.config = nil;
    ad.window = nil;
}
@end
