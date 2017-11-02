//
//  BQRefreshView.m
//  TianyaTest
//
//  Created by MrBai on 2017/8/14.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQRefreshView.h"

@interface BQRefreshView()

@end

@implementation BQRefreshView

static NSString * const scrollerOffset = @"contentOffset";
static NSString * const scrollerSize = @"contentSize";

#pragma mark - View Life
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self removeObservers];
    
    if (![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.size.width = newSuperview.bounds.size.width;
    frame.origin.x = 0;
    self.frame = frame;
    
    self.statu = RefreshStatuType_Pull;
    self.scrollView = (UIScrollView *)newSuperview;
    self.scrollViewOriginalInset = self.scrollView.contentInset;
    
    [self addObservers];
}

- (void)addObservers {
    [self.scrollView addObserver:self forKeyPath:scrollerOffset options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:scrollerSize options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    if (self.superview) {
        [self.superview removeObserver:self forKeyPath:scrollerOffset context:nil];
        [self.superview removeObserver:self forKeyPath:scrollerSize context:nil];
    }
}

- (void)layoutSubviews {
    if (self.scrollView) {
        self.origiOffsetY = self.scrollView.contentOffset.y;
    }
}

- (void)contentOffsetDidChange {
    
}

- (void)contentSizeDidChange {
    
}

#pragma mark - KVO Delegate 
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (self.userInteractionEnabled == NO || self.isHidden == YES) { return; }
    
    if ([keyPath isEqualToString:scrollerOffset]) {
        [self contentOffsetDidChange];
    } else if ([keyPath isEqualToString:scrollerSize]) {
        [self contentSizeDidChange];
    }
}

#pragma mark - get Method
- (UILabel *)statuLab {
    if (_statuLab == nil) {
        _statuLab = [[UILabel alloc] init];
        _statuLab.font = [UIFont systemFontOfSize:12];
        _statuLab.textAlignment = NSTextAlignmentCenter;
    }
    return _statuLab;
}

@end
