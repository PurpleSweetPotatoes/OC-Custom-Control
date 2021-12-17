//
//  BQHintViewTool.m
//  TianyaTest
//
//  Created by MrBai on 2018/6/1.
//  Copyright © 2018年 MrBai. All rights reserved.
//

#import "BQHintViewTool.h"

@interface BQHintViewBgView: UIView

@property (nonatomic, strong) NSMutableArray<UIView *> * hintViews;

- (void)showNextHintView;

@end

static BQHintViewBgView * bgView;

@implementation BQHintViewTool

+ (void)showHintView {
    if (bgView.subviews.count == 0) {
        [bgView showNextHintView];
    }
}

+ (void)showNextView {
    [bgView showNextHintView];
}

+ (void)addHintView:(UIView *)hintView {
    if (bgView == nil) {
        bgView = [[BQHintViewBgView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    [bgView.hintViews addObject:hintView];
}

@end

@implementation BQHintViewBgView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.hintViews = [NSMutableArray array];
        [self addTapGesture];
    }
    return self;
}

- (void)addTapGesture {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCurrentSubView)];
    [self addGestureRecognizer:tap];
}

- (void)removeCurrentSubView {
    
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    [self showNextHintView];
}

- (void)showNextHintView {
    
    if (self.superview == nil) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    if (self.hintViews.count > 0) {
        [self addSubview:self.hintViews.firstObject];
        [self.hintViews removeObjectAtIndex:0];
    } else {
        [self removeFromSuperview];
    }
    
}

@end
