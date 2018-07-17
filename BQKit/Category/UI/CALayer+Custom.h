//
//  CALayer+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

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


/** 同cell底部灰线颜色相同 */
+ (instancetype)cellLineLayerWithFrame:(CGRect)frame;


/** 线条layer */
+ (instancetype)layerWithFrame:(CGRect)frame color:(UIColor *)backColor;

@end
