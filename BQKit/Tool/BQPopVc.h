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
 setUpUI ==> config your views
 animationShow ==> config your views animation when view will apper
 animationHide ==> config your views animation when view will disapper
 willUseHandleMethod ==> when will callback handle, you can config something for handle
 
 */
@interface BQPopVc : UIViewController

#pragma mark - Main

+ (instancetype)showViewWithfromVc:(UIViewController *)fromVc Handle:(void(^)(id objc))handle;

+ (instancetype)showViewWihtDictInfo:(NSDictionary *)dictInfo fromVc:(UIViewController *)fromVc handle:(void(^)(id objc))handle;

#pragma mark - subClass

@property (nonatomic, strong) NSDictionary * dicInfo;           ///<  config UI info
@property (nonatomic, assign) BOOL needBackView;                ///<  background black View， default is YES
@property (nonatomic, assign) NSTimeInterval showTime;          ///<  animationShowTime, default is 0.25
@property (nonatomic, assign) NSTimeInterval hideTime;          ///<  anmationHideTime default is 0.25

/** subClass can override, need use super func */
- (void)setUpUI;

- (void)animationShow;

- (void)animationHide;

@end
