//
//  UIImageView+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Show) <UIGestureRecognizerDelegate>
/**
 可通过点击视图对视图进行展示和手势操作
 */
- (void)canShowImage;

- (void)setGifImgWithName:(NSString *)name;

- (void)setGifImgWithName:(NSString *)name inBundle:(NSBundle *)bundle;
@end
