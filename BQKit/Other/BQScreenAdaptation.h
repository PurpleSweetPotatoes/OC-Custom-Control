//
//  BQScreenAdaptation.h
//  runtimeDemo
//
//  Created by baiqiang on 15/12/2.
//  Copyright © 2015年 baiqiang. All rights reserved.
//

#ifndef BQScreenAdaptation_h
#define BQScreenAdaptation_h

#import <UIKit/UIKit.h>
#import "BQDefineHead.h"

/**
    将IPHONE_WIDTH改为对应设计图的宽度
    在使用的时候直接使用BQAdaptationFrame函数
    还原为其设计图上的坐标位置，需要除以BQAdaptationWidth()
 */
#define IPHONE_WIDTH 375

FOUNDATION_STATIC_INLINE CGFloat BQAdaptationWidth() {
    return KScreenWidth / IPHONE_WIDTH;
}

FOUNDATION_STATIC_INLINE CGFloat BQAdaptation(CGFloat x) {
    return x * BQAdaptationWidth();
}

FOUNDATION_STATIC_INLINE CGSize BQadaptationSize(CGFloat width, CGFloat height) {
    CGFloat newWidth = width * BQAdaptationWidth();
    CGFloat newHeight = height * BQAdaptationWidth();
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    return newSize;
}

FOUNDATION_STATIC_INLINE CGPoint BQadaptationPoint(CGFloat x, CGFloat y) {
    CGFloat newX = x * BQAdaptationWidth();
    CGFloat newY = y * BQAdaptationWidth();
    CGPoint point = CGPointMake(newX, newY);
    return point;
}

FOUNDATION_STATIC_INLINE CGRect BQAdaptationFrame(CGFloat x,CGFloat y, CGFloat width,CGFloat height)  {
    CGFloat newX = x * BQAdaptationWidth();
    CGFloat newY = y * BQAdaptationWidth();
    CGFloat newWidth = width * BQAdaptationWidth();
    CGFloat newHeight = height * BQAdaptationWidth();
    CGRect rect = CGRectMake(newX, newY, newWidth, newHeight);
    return rect;
}

#endif /* BQScreenAdaptation_h */

