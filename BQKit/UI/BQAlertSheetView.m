//
//  BQAlertSheetView.m
//  TianyaTest
//
//  Created by MrBai on 2018/5/25.
//  Copyright © 2018年 MrBai. All rights reserved.
//

#import "BQAlertSheetView.h"

@interface BQAlertSheetView ()
@property (nonatomic, strong) UIView * bottomView;              ///<  底部动画View
@property (nonatomic, copy) void(^callBlock)(NSInteger index, NSString * title);
@property (nonatomic, strong) NSArray <NSString *> * titles;
@end

@implementation BQAlertSheetView

+ (void)showSheetViewWithTitles:(NSArray <NSString *>*)titles callBlock:(void(^)(NSInteger index, NSString * title))callBlock {
    
    if (titles.count <= 0) {
        return;
    }
    
    BQAlertSheetView * view = [[BQAlertSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.callBlock = callBlock;
    view.titles = titles;
    [view setUpUI];
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (void)didMoveToSuperview {
    CGRect frame = self.bottomView.frame;
    frame.origin.y = self.bounds.size.height - self.bottomView.bounds.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        self.bottomView.frame = frame;
    }];
}

- (void)setUpUI {
    self.alpha = 0;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    CGFloat rowHeight = 44;
    CGFloat height = rowHeight * (self.titles.count + 1) + 4 + 1 * self.titles.count;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, height)];
    [self addSubview:self.bottomView];
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        UIButton * btn  = [self createTitleBtnWithFrame:CGRectMake(0, i * (rowHeight + 1), self.bounds.size.width, rowHeight) title:self.titles[i] tag:i];
        
        if (i != 0) {
            CAShapeLayer * lineLayer = [CAShapeLayer layer];
            lineLayer.frame = CGRectMake(0, CGRectGetMaxY(btn.frame), self.bounds.size.width, 1 + (i == (self.titles.count - 1)?4:0));
            lineLayer.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
            [self.bottomView.layer addSublayer:lineLayer];
        }
        
        [self.bottomView addSubview:btn];
    }
    
    UIButton * btn = [self createTitleBtnWithFrame:CGRectMake(0, height - rowHeight, self.bounds.size.width, rowHeight) title:@"取消" tag:100];
    [self.bottomView addSubview:btn];
}

- (UIButton *)createTitleBtnWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    return btn;
}

- (void)btnAction:(UIButton *)sender {
    
    if (self.callBlock && sender.tag != 100) {
        self.callBlock(sender.tag, sender.currentTitle);
    }
    [self removeWithAnimation];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeWithAnimation];
}

- (void)removeWithAnimation {
    
    CGRect frame = self.bottomView.frame;
    frame.origin.y = self.bounds.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.frame = frame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
