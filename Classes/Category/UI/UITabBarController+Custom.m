//
//  UITabBarController+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/2/15.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "UITabBarController+Custom.h"

@implementation TabBarInfo

+ (instancetype)infoWithName:(NSString *)clsName
                    barTitle:(NSString *)barTitle {
    return [self infoWithName:clsName barTitle:barTitle normalImgName:@"" selectImgName:@""];
}

+ (instancetype)infoWithName:(NSString *)clsName barTitle:(NSString *)barTitle normalImgName:(NSString *)normalImgName selectImgName:(NSString *)selectImgName {
    TabBarInfo * info = [[TabBarInfo alloc] init];
    info.clsName = clsName ?: @"";
    info.barTitle = barTitle ?: @"";
    info.normalImgName = normalImgName ?: @"";
    info.selectImgName = selectImgName ?: @"";
    return info;
}

@end

@implementation UITabBarController (Custom)

+ (instancetype)createVcWithInfo:(NSArray<TabBarInfo *> *)infos {
    return [self createVcWithInfo:infos needNaVc:YES];
}

+ (instancetype)createVcWithInfo:(NSArray<TabBarInfo *> *)infos needNaVc:(BOOL)needNaVc {

    UITabBarController * tabbarVc = [[UITabBarController alloc] init];
    [tabbarVc configVcWithInfo:infos needNaVc:needNaVc];
    return tabbarVc;
}

- (void)configVcWithInfo:(NSArray<TabBarInfo *> *)infos {
    [self configVcWithInfo:infos needNaVc:YES];
}

- (void)configVcWithInfo:(NSArray<TabBarInfo *> *)infos needNaVc:(BOOL)needNaVc {
    
    NSMutableArray * vcs = [NSMutableArray arrayWithCapacity:infos.count];
    
    if (infos.count > 0) {
        for (TabBarInfo * info in infos) {
            
            Class class = NSClassFromString(info.clsName);
            if (!class) {
                NSAssert(true, @"控制器<%@>转化失败", info.clsName);
            }
            NSString * title = info.barTitle;
            UIImage * normalImg = nil;
            UIImage * selectImg = nil;
            if (info.normalImgName.length > 0) {
                normalImg = [[UIImage imageNamed:info.normalImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            if (info.selectImgName.length > 0) {
                selectImg = [[UIImage imageNamed:info.selectImgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            
            UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:title image:normalImg selectedImage:selectImg];
            UIViewController * vc = [[class alloc] init];
            vc.tabBarItem = item;
            vc.title = title;
            if (needNaVc) {
                vc = [[UINavigationController alloc] initWithRootViewController:vc];
            }
            [vcs addObject:vc];
        }
        
    }
    self.viewControllers = vcs;
}


@end
