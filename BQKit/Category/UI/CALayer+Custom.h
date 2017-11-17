//
//  CALayer+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Frame)

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat sizeW;
@property (nonatomic, assign) CGFloat sizeH;
@property (nonatomic, readonly, assign) CGPoint thisCenter;

@end
