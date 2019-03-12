//
//  SwipeSubTableVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/3/12.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "BQSwipeSubTableVc.h"

@interface BQSwipeSubTableVc ()

@property (nonatomic, strong) UIView * disPalyHeaderView;
@property (nonatomic, assign) NSInteger  currentTabIndex;
@property (nonatomic, assign) BOOL  isFirst;
@property (nonatomic, copy) void(^switchBlock)(NSInteger index);
@property (nonatomic, assign) CGFloat  navBottom;
@end

@implementation BQSwipeSubTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFirst = YES;
    self.currentTabIndex = 0;
    self.navBottom = self.navigationController ? KNavBottom : 0;
    [self setUpUI];
}

- (void)setUpUI {
    self.disPalyHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.sizeW, 0)];
    if (self.headerView) {
        [self.disPalyHeaderView addSubview:self.headerView];
        self.disPalyHeaderView.sizeH = self.headerView.bottom;
    }
    
    if (self.barView) {
        self.barView.top = self.headerView.bottom;
        [self.disPalyHeaderView addSubview:self.barView];
        self.disPalyHeaderView.sizeH = self.barView.bottom;
    }
    
    [self.view addSubview:self.disPalyHeaderView];
    
    [self configTabArrs];
}

- (void)configTabArrs {

    for (UIViewController<BQSwipTableViewDelegate> * tVc in self.tabArrs) {
        tVc.headerHeight = self.disPalyHeaderView.sizeH;
        WeakSelf;
        [tVc scrollViewDidScrollBlock:^(CGFloat offsetY) {
            StrongSelf;
            [strongSelf updateDisplayViewFrame:offsetY];
        }];
        
        [self addChildViewController:tVc];
        [self.view addSubview:tVc.view];
        tVc.view.left = self.view.sizeW;
        if (self.navBottom == 0) {
            tVc.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UISwipeGestureRecognizer * swipRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGestureAction:)];
        swipRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [tVc.view addGestureRecognizer:swipRightGesture];
        UISwipeGestureRecognizer * swipLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipGestureAction:)];
        swipLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [tVc.view addGestureRecognizer:swipLeftGesture];
        
    }
    
    UIViewController<BQSwipTableViewDelegate> * curVc = self.tabArrs[self.currentTabIndex];
    curVc.view.left = 0;
    curVc.needScrollBlock = YES;
    
    [self.view bringSubviewToFront:self.disPalyHeaderView];
}

- (void)resetTabArrs:(NSArray<UIViewController<BQSwipTableViewDelegate> *> *)tabArrs {
    
    for (UIViewController<BQSwipTableViewDelegate> * vc in tabArrs) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    self.tabArrs = tabArrs;
    
    [self configTabArrs];
}

- (void)updateDisplayViewFrame:(CGFloat)offsetY {
    
    if (!self.headerView) {
        return;
    }
    
    if (offsetY >= self.headerView.sizeH - self.navBottom) {
        
        if (self.disPalyHeaderView.top != self.navBottom - self.headerView.sizeH) {
            for (NSInteger i = 0; i < self.tabArrs.count; i++) {
                if (i == self.currentTabIndex) {
                    continue;
                } else {
                    [self.tabArrs[i].tableView setContentOffset:CGPointMake(0, self.headerView.sizeH - self.navBottom) animated:NO];
                }
            }
        }
        self.disPalyHeaderView.top = self.navBottom - self.headerView.sizeH;
        
    } else {
        
        if (!self.isFirst) { //第一次进入contentOffset会出现偏移错误
            for (NSInteger i = 0; i < self.tabArrs.count; i++) {
                if (i == self.currentTabIndex) {
                    continue;
                } else {
                    [self.tabArrs[i].tableView setContentOffset:CGPointMake(0, offsetY) animated:NO];
                }
            }
        }
        
        self.isFirst = NO;
        self.disPalyHeaderView.top = -offsetY;
    }
}

- (void)switchToTabVc:(NSInteger)index {
    
    if (index >= 0 && index < self.tabArrs.count && index != self.currentTabIndex) {
        
        UIViewController<BQSwipTableViewDelegate> * tabVc = self.tabArrs[index];
        tabVc.view.left = 0;
        tabVc.needScrollBlock = YES;
        
        UIViewController<BQSwipTableViewDelegate> * currentTabVc = self.tabArrs[self.currentTabIndex];
        currentTabVc.needScrollBlock = NO;
        currentTabVc.view.right = 0;
        
        self.currentTabIndex = index;
    }
}

- (void)tabVcWillSwitchToIndex:(void (^)(NSInteger))changeBlock {
    self.switchBlock = changeBlock;
}

#pragma mark - Gesture Action

- (void)swipGestureAction:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight && self.currentTabIndex != 0) {
    
        self.currentTabIndex -= 1;
        
        [self changeVcFrom:self.tabArrs[self.currentTabIndex + 1] to:self.tabArrs[self.currentTabIndex] swipRight:YES];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionLeft && self.currentTabIndex < self.tabArrs.count - 1) {

        self.currentTabIndex += 1;
        
        [self changeVcFrom:self.tabArrs[self.currentTabIndex - 1] to:self.tabArrs[self.currentTabIndex] swipRight:NO];
    }
}

- (void)changeVcFrom:(UIViewController<BQSwipTableViewDelegate> *)fromVc to:(UIViewController<BQSwipTableViewDelegate> *)toVc swipRight:(BOOL)swipRight {
    
    fromVc.needScrollBlock = NO;
    toVc.needScrollBlock = YES;
    
    toVc.view.left = swipRight ? -self.view.sizeW: self.view.sizeW;
    
    [UIView animateWithDuration:0.25 animations:^{
        fromVc.view.left = swipRight ? self.view.sizeW : -self.view.sizeW;
        toVc.view.left = 0;
    }];
    
    if (self.switchBlock) {
        self.switchBlock(self.currentTabIndex);
    }
}

@end
