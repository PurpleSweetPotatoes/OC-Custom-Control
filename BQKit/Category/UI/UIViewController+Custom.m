//
//  UIViewController+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/4/24.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "UIViewController+Custom.h"
#import <objc/runtime.h>


@implementation UIViewController (Custom)

- (UIStatusBarStyle)preferredStatusBarStyle {
    StatusColorType type = self.statuType;
    switch (type) {
        case StatusColorType_Normal:
            return UIStatusBarStyleDefault;
            break;
        case StatusColorType_White:
            return UIStatusBarStyleLightContent;
            break;
        default:
            break;
    }
}

+ (UIViewController *)currentDisPalyVc {
    UIViewController * output = [UIApplication sharedApplication].keyWindow.rootViewController;
    output = [self vcTypeChoose:output];
    output = [self getTopVcInSupVc:output];
    return output;
}

+ (UIViewController *)vcTypeChoose:(UIViewController *)mainVc {
    UIViewController * outputVc;
    if ([mainVc isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabVc = (UITabBarController *)mainVc;
        if (tabVc.viewControllers.count > 0) {
            outputVc = [self vcTypeChoose:tabVc.viewControllers[tabVc.selectedIndex]];
        } else {
            outputVc = tabVc;
        }
    } else if ([mainVc isKindOfClass:[UINavigationController class]]) {
        UINavigationController * navVc = (UINavigationController *)mainVc;
        if (navVc.viewControllers.count > 0) {
            outputVc = [self vcTypeChoose:navVc.visibleViewController];
        } else {
            outputVc = navVc;
        }
    } else {
        outputVc = mainVc;
    }
    return outputVc;
}

+ (UIViewController *)getTopVcInSupVc:(UIViewController *)vc {
    UIViewController * outputVc = vc;
    while (outputVc.presentedViewController) {
        outputVc = outputVc.presentedViewController;
    }
    return outputVc;
}

- (CGFloat)navbarBottom {
    if (self.navigationController) {
        return self.navigationController.navigationBar.sizeH + [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return 0;
}

- (CGFloat)tabbarHeight {
    return self.tabBarController.tabBar.bounds.size.height;
}

#pragma mark - Associate Object

- (StatusColorType)statuType {
    return [objc_getAssociatedObject(self, @selector(statuType)) intValue];
}

- (void)setStatuType:(StatusColorType)statuType {
    objc_setAssociatedObject(self, @selector(statuType), @(statuType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
