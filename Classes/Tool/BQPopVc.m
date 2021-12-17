//
//  BQPopVc.m
//  Test-demo
//
//  Created by baiqiang on 2018/9/29.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "BQPopVc.h"

#import "UIColor+Custom.h"

@interface BQPopVc ()

@end

@implementation BQPopVc

#pragma mark - Class Method

- (void)dealloc {
    NSLog(@"%@ 被释放了", self);
}

+ (instancetype)createVc {
    BQPopVc * popVc = [[self alloc] init];
    popVc.showTime = 0.25;
    popVc.hideTime = 0.25;
    popVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    return popVc;
}

+ (void)showViewWithfromVc:(UIViewController *)fromVc {
    BQPopVc * popVc = [self createVc];
    [popVc showFromVc:fromVc];
}

#pragma mark - Live Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    if (self.backView) {
        [self.view addSubview:self.backView];
    }
}

#pragma mark - public Method

- (void)showFromVc:(UIViewController *)fromVc {
    [fromVc presentViewController:self animated:NO completion:^{
        [self animationShow];
    }];
}

- (void)showVc {
    UIViewController * vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    
    [self showFromVc:vc];
}

- (void)animationShow {
    
    [UIView animateWithDuration:self.showTime animations:^{
        self.backView.alpha = 1;
    }];
}

- (void)animationHide {
    
    if (self.backView) {
        [UIView animateWithDuration:self.hideTime animations:^{
            self.backView.alpha = 0;
        }];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.hideTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:nil];
        });
}



#pragma mark - get Method

- (UIView *)backView {
    if (_backView == nil) {
        UIView * backView = [[UIView alloc] initWithFrame:self.view.bounds];
        UIColor * color = [UIColor hexstr:@"282520"];
        backView.backgroundColor = [color colorWithAlphaComponent:0.6];
        backView.alpha = 0;
        _backView = backView;
    }
    return _backView;
}

@end
