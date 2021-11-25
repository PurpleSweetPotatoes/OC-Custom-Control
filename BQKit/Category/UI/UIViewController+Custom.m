//
//  UIViewController+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/4/24.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "BQDefineHead.h"
#import "CALayer+Custom.h"
#import "UIColor+Custom.h"
#import "UIView+Custom.h"
#import "UIViewController+Custom.h"
#import <objc/runtime.h>

@interface UIViewController()
@property (nonatomic, strong) UIView * barBgView;
@property (nonatomic, strong) CALayer * showadLine;
@end

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
        return self.navigationController.navigationBar.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return 0;
}

- (CGFloat)tabbarHeight {
    return self.tabBarController.tabBar.bounds.size.height;
}

- (void)setNavBarLeftItem:(UIBarButtonItem *)item {
    self.navigationItem.leftBarButtonItem = item;
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - 导航栏配色

+ (void)startConfigNavBar {
    UIImage * img = [[UIImage alloc] init];
    [[UINavigationBar appearance] setShadowImage:img];
    [[UINavigationBar appearance] setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
}

- (void)bq_configsetShadowLine:(BOOL)hide {
    if (self.showadLine == nil) {
        self.showadLine = [CALayer layerWithFrame:CGRectMake(0, self.barBgView.height - 1, self.barBgView.width, 1) color:[UIColor hexstr:@"d2d2d2"]];
        [self.view.layer addSublayer:self.showadLine];
    }

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.showadLine.hidden = hide;
    [CATransaction commit];
}


- (void)bq_setNavBarBackgroundColor:(UIColor *)color {
    if (self.navigationController) {
        if (self.barBgView == nil) {
            self.barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.navbarBottom)];
            [self.view addSubview:self.barBgView];
        }
        self.barBgView.backgroundColor = color;
    }
}

- (void)bq_setNavBarGgViewAlpha:(CGFloat)alpha {
    self.barBgView.alpha = alpha;
}

#pragma mark - Associate Object

- (StatusColorType)statuType {
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

- (void)setStatuType:(StatusColorType)statuType {
    objc_setAssociatedObject(self, @selector(statuType), @(statuType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsStatusBarAppearanceUpdate];
}


- (UIView *)barBgView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBarBgView:(UIView *)barBgView {
    objc_setAssociatedObject(self, @selector(barBgView), barBgView, OBJC_ASSOCIATION_RETAIN);
}




- (CALayer *)showadLine {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setShowadLine:(CALayer *)showadLine {
    objc_setAssociatedObject(self, @selector(showadLine), showadLine, OBJC_ASSOCIATION_RETAIN);
}

@end
