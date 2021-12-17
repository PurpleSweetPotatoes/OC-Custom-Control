//
//  BQPopVc.h
//  Test-demo
//
//  Created by baiqiang on 2018/9/29.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 can use for something has more views popView
 inherit BQPopVc and override funcs
 animationShow ==> config your views animation when view will apper
 animationHide ==> config your views animation when view will disapper
 */
@interface BQPopVc : UIViewController

#pragma mark - Main

+ (instancetype)createVc;

+ (void)showViewWithfromVc:(UIViewController *)fromVc;

#pragma mark - subClass
@property (nonatomic, strong) UIView * backView;                ///<  background black View
@property (nonatomic, assign) NSTimeInterval showTime;          ///<  animationShowTime, default is 0.25
@property (nonatomic, assign) NSTimeInterval hideTime;          ///<  anmationHideTime default is 0.25

- (void)showFromVc:(UIViewController *)fromVc;

- (void)showVc;

/** subClass can override, need use super func */

- (void)animationShow;

- (void)animationHide;

@end
