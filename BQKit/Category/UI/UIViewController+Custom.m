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
    
    while (output.presentedViewController) {
        output = output.presentedViewController;
    }
    
    if ([output isKindOfClass:[UITabBarController class]]) {
        UITabBarController * tabVc = (UITabBarController *)output;
        output = tabVc.viewControllers[tabVc.selectedIndex];
        
        while (output.presentedViewController) {
            output = output.presentedViewController;
        }
        
    }
    
    return output;
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
