// *******************************************
//  File Name:      LottieVc.m       
//  Author:         MrBai
//  Created Date:   2022/2/21 10:15 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "LottieVc.h"

#import "BQTipView.h"
#import <LOTAnimationView.h>

@interface LottieVc ()
@property (nonatomic, strong) LOTAnimationView * gifV;
@end

@implementation LottieVc


#pragma mark - *** Public method

#pragma mark - *** Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.gifV play];
    });
}
#pragma mark - *** NetWork method

#pragma mark - *** Event Action

#pragma mark - *** Delegate

#pragma mark - *** Instance method

#pragma mark - *** UI method

- (void)configUI {
    [self.view addSubview:self.gifV];
}

#pragma mark - *** Set

#pragma mark - *** Get
    

- (LOTAnimationView *)gifV {
    if (_gifV == nil) {
        LOTAnimationView * gifV = [LOTAnimationView animationNamed:@"loading_gradient_strokes"];
        gifV.frame = self.view.bounds;
        gifV.contentMode = UIViewContentModeScaleAspectFit;
        gifV.completionBlock = ^(BOOL complet){
            [BQTipView showInfo:@"动画完成"];
        };
        _gifV = gifV;
    }
    return _gifV;
}

@end
