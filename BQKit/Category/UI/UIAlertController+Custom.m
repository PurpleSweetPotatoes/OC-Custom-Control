//
//  UIAlertController+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIAlertController+Custom.h"

@implementation UIAlertController (Custom)
+ (void)showWithTitle:(NSString *)title content:(NSString *)content {
    [self showWithTitle:title content:content handle:nil];
}

+ (void)showWithTitle:(NSString *)title content:(NSString *)content handle:(void (^)())clickedBtn {
    [self showWithTitle:title content:content buttonTitles:@[@"确定"] clickedHandle:clickedBtn];
}

+ (void)showWithTitle:(NSString *)title content:(NSString *)content buttonTitles:(NSArray <NSString *> *)titles clickedHandle:(void(^)(NSInteger index))clickedBtn {
    [self showWithTitle:title content:content buttonTitles:titles clickedHandle:clickedBtn compeletedHandle:nil];
}

+ (void)showWithTitle:(NSString *)title content:(NSString *)content buttonTitles:(NSArray<NSString *> *)titles clickedHandle:(void (^)(NSInteger))clickedBtn compeletedHandle:(void (^)())handle {
    
    if (title == nil) {
        title = @"";
    }
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    UIViewController * currentVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (currentVc.presentedViewController) {
        currentVc = currentVc.presentedViewController;
    }
    
    NSInteger index = 0;
    
    for (NSString *btnTitle in titles) {
        [alertVc addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (clickedBtn != nil) {
                clickedBtn(index);
            }
        }]];
        ++index;
    }
    
    [currentVc presentViewController:alertVc animated:YES completion:^{
        if (handle != nil) {
            handle();
        }
    }];
}

- (void)tapGesDismissAlert {
    
    if (self.view.superview) {
        self.view.superview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertBackViewTap:)];
        [self.view.superview addGestureRecognizer:tap];
    }
}

- (void)alertBackViewTap:(UITapGestureRecognizer *)sender {
    [sender removeTarget:self action:@selector(alertBackViewTap:)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

