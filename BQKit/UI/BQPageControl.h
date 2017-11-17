//
//  BQPageControl.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQPageControl : UIPageControl
/** 点之间的间距 */
@property (nonatomic, assign) CGFloat spacing;
/** 正常点的大小,默认为7 */
@property (nonatomic, assign) CGFloat normalSize;
/** 被选择点的大小,默认为7 */
@property (nonatomic, assign) CGFloat selectedSize;
@end
