//
//  BQRefreshFooterView.m
//  TianyaTest
//
//  Created by MrBai on 2017/8/15.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQRefreshFooterView.h"

@interface BQRefreshFooterView ()
@property (nonatomic, strong) UIActivityIndicatorView * activeView;
@property (nonatomic, assign) BOOL resetContentSize;
@end

@implementation BQRefreshFooterView

static NSString * const keyIdle = @"BQRefreshAutoFooterIdleText";
static NSString * const keyRefresh = @"BQRefreshAutoFooterRefreshingText";
static NSString * const keyNoMore = @"BQRefreshAutoFooterNoMoreDataText";

+ (instancetype)footerWithBlock:(CallBlock)block {
    //脚部刷新视图高度
    CGFloat height = 50;
    BQRefreshFooterView * footerView = [[self alloc] initWithFrame:CGRectMake(0, 0, 0, height)];
    footerView.block = block;
    return footerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setupUI];
        [self addTapGesture];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.activeView];
    [self addSubview:self.statuLab];
    
    self.activeView.hidden = YES;
    self.statuLab.font = [UIFont systemFontOfSize:17.0f];
    self.resetContentSize = NO;
    self.statuLab.text = [NSBundle refreshStringKey:keyIdle];
}

- (void)addTapGesture {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usingMyBlock)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.activeView.center = CGPointMake(self.bounds.size.width * 0.25, self.bounds.size.height * 0.5);
    self.statuLab.frame = CGRectMake(0, 5, self.bounds.size.width, 40);
}

#pragma mark - KVO Method 
- (void)contentOffsetDidChange {
    [super contentOffsetDidChange];
    //刷新、无更多数据、未拖拽直接返回
    if (self.statu == RefreshStatuType_Refreshing || self.statu == RefreshStatuType_noMoreData || !self.scrollView.isDragging || (self.origiOffsetY - self.scrollView.contentOffset.y) > 0)  {
        return;
    }
    
    switch (self.statu) {
        case RefreshStatuType_Pull:
        {
            //追加一个20的增量
            if (self.scrollView.contentSize.height + 20 < self.scrollView.bounds.size.height + self.scrollView.contentOffset.y) {
                self.statu = RefreshStatuType_willRefresh;
            }
        }
            break;
        case RefreshStatuType_willRefresh:
        {
            [self usingMyBlock];
        }
            break;
        default:
            break;
    }
}

- (void)contentSizeDidChange {
    if (!self.resetContentSize) {
        self.resetContentSize = YES;
        CGRect frame = self.frame;
        frame.origin.y = self.scrollView.contentSize.height;
        self.frame = frame;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.contentSize.height + self.bounds.size.height);
        self.resetContentSize = NO;
    }
}

#pragma mark - Refresh Method
- (void)usingMyBlock {
    if (self.block) {
        self.block();
    }
}

- (void)beginAnimation {
    if (self.statu == RefreshStatuType_noMoreData) { return; }
    self.activeView.hidden = !self.activeView.hidden;
    [self.activeView startAnimating];
    self.statuLab.text = [NSBundle refreshStringKey:keyRefresh];
    self.statu = RefreshStatuType_Refreshing;
}

- (void)endRefreshNoMore:(BOOL)noMore {
    self.activeView.hidden = !self.activeView.hidden;
    [self.activeView stopAnimating];
    
    if (noMore) {
        [self setNoMoreData];
    }else {
        [self resetData];
    }
}

- (void)resetData {
    self.statu = RefreshStatuType_Pull;
    self.statuLab.text = [NSBundle refreshStringKey: keyIdle];
}

- (void)setNoMoreData {
    self.statu = RefreshStatuType_noMoreData;
    self.statuLab.text = [NSBundle refreshStringKey: keyNoMore];
}

#pragma mark - Get Method
- (UIActivityIndicatorView *)activeView {
    if (_activeView == nil) {
        _activeView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activeView;
}
@end
