//
//  BQRefreshView.h
//  TianyaTest
//
//  Created by MrBai on 2017/8/14.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSBundle+Refresh.h"


typedef NS_ENUM(NSUInteger, RefreshStatuType) {
    RefreshStatuType_Pull,
    RefreshStatuType_Refreshing,
    RefreshStatuType_willRefresh,
    RefreshStatuType_noMoreData
};

typedef void (^CallBlock)();

@interface BQRefreshView : UIView

@property (nonatomic, assign) CGFloat origiOffsetY;
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;
@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, assign) RefreshStatuType statu;
@property (nonatomic, copy) CallBlock block;
@property (nonatomic, strong) UILabel * statuLab;

- (void)contentOffsetDidChange;
- (void)contentSizeDidChange;
@end
