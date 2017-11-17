//
//  UIButton+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BtnEdgeType) {
    EdgeTypeCenter,
    EdgeTypeLeft,
    EdgeTypeRight,
    EdgeTypeImageTopLabBottom,
};

@interface UIButton (EdgeInsets)

- (void)adjustLabAndImageLocation:(BtnEdgeType)type;

@end
