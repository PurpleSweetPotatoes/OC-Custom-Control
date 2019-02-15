//
//  UITabBarController+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/2/15.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "UITabBarController+Custom.h"

@implementation UITabBarController (Custom)


+ (instancetype)createVcWithInfo:(NSArray *)infos {
    return [self createVcWithInfo:infos needNaVc:YES];
}

+ (instancetype)createVcWithInfo:(NSArray *)infos needNaVc:(BOOL)needNaVc {

    UITabBarController * tabbarVc = [[UITabBarController alloc] init];
    NSMutableArray * vcs = [NSMutableArray arrayWithCapacity:infos.count];
    
    if (infos.count > 0) {
        for (NSDictionary * vcInfo in infos) {
            if ([vcInfo[kVcName] isKindOfClass:[NSString class]]) {
                Class class = NSClassFromString(vcInfo[kVcName]);
                NSString * title = @"";
                NSString * normalImgName = @"";
                NSString * selectImgName = @"";
                if ([vcInfo[kVcTitle] isKindOfClass:[NSString class]]) {
                    title = vcInfo[kVcTitle];
                }
                
                if ([vcInfo[kNormalImg] isKindOfClass:[NSString class]]) {
                    normalImgName = vcInfo[kNormalImg];
                }
                
                if ([vcInfo[kSelectImg] isKindOfClass:[NSString class]]) {
                    selectImgName = vcInfo[kSelectImg];
                }
                
                UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:normalImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
                UIViewController * vc = [[class alloc] init];
                vc.tabBarItem = item;
                vc.title = title;
                if (needNaVc) {
                    vc = [[UINavigationController alloc] initWithRootViewController:vc];
                }
                [vcs addObject:vc];
            }
        }
    }
    
    tabbarVc.viewControllers = vcs;
    
    return tabbarVc;
}


@end
