//
//  UIImageView+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Custom)

/// 可通过点击视图对视图进行展示和手势操作
- (void)canShowImage;

/// 配置gif图片
/// @param name 图片名称
- (void)setGifImgWithName:(NSString *)name;

/// 配置gif图片
/// @param name 图片名称
/// @param bundle 包名
- (void)setGifImgWithName:(NSString *)name inBundle:(NSBundle *)bundle;
@end
