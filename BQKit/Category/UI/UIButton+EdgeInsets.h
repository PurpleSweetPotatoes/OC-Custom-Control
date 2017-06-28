//
//  UIButton+EdgeInsets.h
//  MyCocoPods
//
//  Created by baiqiang on 17/2/17.
//  Copyright © 2017年 baiqiang. All rights reserved.
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
