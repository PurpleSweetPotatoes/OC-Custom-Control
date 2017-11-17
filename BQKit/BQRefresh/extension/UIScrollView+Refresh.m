//
//  UIScrollView+Refresh.m
//  TianyaTest
//
//  Created by MrBai on 2017/8/15.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "BQRefreshHeaderView.h"
#import "BQRefreshFooterView.h"

static const NSInteger headerTag = 100105;
static const NSInteger footerTag = 100106;

@implementation UIScrollView (Refresh)

- (BQRefreshHeaderView *)bq_headerView {
    return [self viewWithTag:headerTag];
}
- (void)setBq_headerView:(BQRefreshHeaderView *)bq_headerView {
    if (self.bq_headerView) {
        [self.bq_headerView removeFromSuperview];
    }
    bq_headerView.tag = headerTag;
    [self addSubview:bq_headerView];
}
- (BQRefreshFooterView *)bq_footerView {
    return [self viewWithTag:footerTag];
}
- (void)setBq_footerView:(BQRefreshFooterView *)bq_footerView {
    if (self.bq_footerView) {
        [self.bq_footerView removeFromSuperview];
    }
    bq_footerView.tag = footerTag;
    [self addSubview:bq_footerView];
}
@end
