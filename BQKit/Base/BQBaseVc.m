//
//  BQBaseVc.m
//  HaoJiLaiSeller
//
//  Created by MAC on 16/11/9.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BQBaseVc.h"
#import <objc/runtime.h>


#define AppMainColor [UIColor cyanColor]

@interface BQBaseVc ()
/** 底部视图 */
@property (nonatomic, strong) UIScrollView * contentView;
/** 是否隐藏导航栏 */
@property (nonatomic, assign) BOOL  isHideBar;
/** 增加显示视图滚动高度 */
@property (nonatomic, assign) CGFloat  addHeight;
@end

@implementation BQBaseVc

#pragma mark - Live Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isHideBar = NO;
    self.addHeight = 0;
    self.contentView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    if (self.navigationController != nil) {
        self.contentView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    }
    self.contentView.bounces = NO;
    [self.view addSubview:self.contentView];
    self.contentView.contentSize = self.contentView.bounds.size;
    //返回按钮
    if ([self.navigationController.viewControllers indexOfObject:self] != 0) {
        UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemAction:)];
        self.navigationItem.leftBarButtonItem = leftBarItem;
    }
    //主题色
    [self.navigationController.navigationBar lt_setBackgroundColor:AppMainColor];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isHideBar == YES) {
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    }
    [self layoutContentView];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isHideBar == YES) {
        [self.navigationController.navigationBar lt_setBackgroundColor:AppMainColor];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - instancetype Method
- (void)HideNavgationBar {
    self.contentView.frame = self.view.bounds;
    self.isHideBar = YES;
}
- (void)adjustHeight {
    CGRect frame = self.contentView.frame;
    frame.size.height -= 49;
    self.contentView.frame = frame;
}
- (void)addContentViewBottom:(CGFloat)height {
    self.addHeight = height;
}
- (void)layoutContentView {
    CGFloat contentHeight = 0;
    NSArray * subViews = self.contentView.subviews;
    for (UIView * view in subViews) {
        if (CGRectGetMaxY(view.frame) > contentHeight) {
            contentHeight = CGRectGetMaxY(view.frame);
        }
    }
    contentHeight += self.addHeight;
    
    if (contentHeight > self.contentView.bounds.size.height) {
       self.contentView.contentSize = CGSizeMake(self.contentView.bounds.size.width, contentHeight);
    }
    
}
#pragma mark - Btn Action
- (void)leftBarItemAction:(UIBarButtonItem *) barItem {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
