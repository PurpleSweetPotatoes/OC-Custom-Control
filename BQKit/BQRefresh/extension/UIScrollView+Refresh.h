//
//  UIScrollView+Refresh.h
//  TianyaTest
//
//  Created by MrBai on 2017/8/15.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BQRefreshHeaderView;
@class BQRefreshFooterView;

@interface UIScrollView (Refresh)
@property (nonatomic, strong) BQRefreshHeaderView * bq_headerView;
@property (nonatomic, strong) BQRefreshFooterView * bq_footerView;
@end
