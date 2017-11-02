//
//  BQRefreshHeaderView.h
//  TianyaTest
//
//  Created by MrBai on 2017/8/14.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "BQRefreshView.h"

@interface BQRefreshHeaderView : BQRefreshView

+ (instancetype)headerWithBlock:(CallBlock)block;
+ (instancetype)headerWithPullStr:(NSString *)pullStr
                   willRefreshStr:(NSString *)willRefreshStr
                       refreshStr:(NSString *)refreshStr
                            Block:(CallBlock)block;

- (void)beginAnimation;
- (void)endRefresh;
@end
