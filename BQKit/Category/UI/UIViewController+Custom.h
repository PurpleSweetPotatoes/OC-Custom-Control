//
//  UIViewController+Custom.h
//  tianyaTest
//
//  Created by baiqiang on 2019/4/24.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, StatusColorType) {
    StatusColorType_Normal,
    StatusColorType_White,
};

@interface UIViewController (Custom)

@property (nonatomic, assign) StatusColorType  statuType;

+ (UIViewController *)currentDisPalyVc;

@end

NS_ASSUME_NONNULL_END
