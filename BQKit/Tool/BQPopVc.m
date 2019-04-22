//
//  BQPopVc.m
//  Test-demo
//
//  Created by baiqiang on 2018/9/29.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "BQPopVc.h"

@interface BQPopVc ()

@property (nonatomic, copy) void(^handle)(id objc);         ///<  结束时的回调函数
@property (nonatomic, strong) UIView * backView;            ///<  黑色透明
@end

@implementation BQPopVc

#pragma mark - Class Method

- (void)dealloc {
    NSLog(@"%@ 被释放了", self);
}

+ (instancetype)createVcWithHandle:(void(^)(id objc))handle {
    BQPopVc * popVc = [[self alloc] init];
    popVc.needBackView = YES;
    popVc.showTime = 0.25;
    popVc.hideTime = 0.25;
    popVc.handle = handle;
    popVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    return popVc;
}

+ (void)showViewWithfromVc:(UIViewController *)fromVc Handle:(void(^)(id objc))handle {
    BQPopVc * popVc = [self createVcWithHandle:handle];
    [popVc showFromVc:fromVc];
}

#pragma mark - Live Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgestureAction:)];
    
    if (self.needBackView) {
        [self.view addSubview:self.backView];
        [self.backView addGestureRecognizer:tap];
    } else {
        [self.view addGestureRecognizer:tap];
    }
    
}

#pragma mark - public Method

- (void)showFromVc:(UIViewController *)fromVc {
    [fromVc presentViewController:self animated:NO completion:^{
        [self animationShow];
    }];
}

- (void)animationShow {
    
    [UIView animateWithDuration:self.showTime animations:^{
        self.backView.alpha = 1;
    }];
}

- (void)animationHide {
    
    if (self.needBackView) {
        
        [UIView animateWithDuration:self.hideTime animations:^{
            self.backView.alpha = 0;
        } completion:^(BOOL finished) {
            [self dismissSelf];
        }];
        
    } else {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.hideTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissSelf];
        });
    }
}

#pragma mark - hide Method

- (void)tapgestureAction:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self animationHide];
    }
}

- (void)dismissSelf {
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        [weakSelf actionHanleMethod];
    }];
}

- (void)actionHanleMethod {
    
    if (self.handle && self.objc) {
        self.handle(self.objc);
    }
}

#pragma mark - get Method

- (UIView *)backView {
    if (_backView == nil) {
        UIView * backView = [[UIView alloc] initWithFrame:self.view.bounds];
        UIColor * color = [UIColor blackColor];
        backView.backgroundColor = [color colorWithAlphaComponent:0.25];
        backView.alpha = 0;
        _backView = backView;
    }
    return _backView;
}

@end
