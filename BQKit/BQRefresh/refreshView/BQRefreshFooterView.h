//
//  BQRefreshFooterView.h
//  TianyaTest
//
//  Created by MrBai on 2017/8/15.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQRefreshView.h"

@interface BQRefreshFooterView : BQRefreshView

+ (instancetype)footerWithBlock:(CallBlock)block;

- (void)endRefreshNoMore:(BOOL)noMore;
- (void)beginAnimation;
//重置数据，可上拉加载更多
- (void)resetData;
//设置无数据
- (void)setNoMoreData;
@end
