// *******************************************
//  File Name:      AppDelegate.m       
//  Author:         MrBai
//  Created Date:   2021/12/14 2:25 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "AppDelegate.h"
#import "UITabBarController+Custom.h"
#import "BQLaunchAd.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NSArray * vcInfos = @[
        [TabBarInfo infoWithName:@"TestListVc" barTitle:@"演示" normalImgName:@"tabbar_test_normal" selectImgName:@"tabbar_test_select"]
        ,[TabBarInfo infoWithName:@"CenterInfoVc" barTitle:@"信息" normalImgName:@"tabbar_info_normal" selectImgName:@"tabbar_info_select"]
    ];
    
    self.window.rootViewController = [UITabBarController createVcWithInfo:vcInfos];
    [self.window makeKeyAndVisible];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.window.bounds;
    btn.backgroundColor = [UIColor cyanColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    BQLaunchConfig * config = [[BQLaunchConfig alloc] init];
    config.showView = btn;
    [BQLaunchAd setConfig:config];
    return YES;
}

- (void)btnAction:(UIButton *)sender {
    [BQLaunchAd close];
}

@end
