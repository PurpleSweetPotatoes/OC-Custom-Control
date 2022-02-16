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

#if __has_include(<SDWebImage/UIImageView+WebCache.h>)

/// 基于sdwebimage封装
- (void)setImgWithUrl:(NSString *)url;

- (void)setImgWithUrl:(NSString *)url holdImg:(UIImage *)holdImg;

#endif
@end



@interface BQShowImageView : UIView
/**  图片视图 */
@property (nonatomic, strong) UIImageView *imageView;
/**  背景视图 */
@property (nonatomic, strong) UIView      *backView;
/**  原图片位置 */
@property (nonatomic, assign) CGRect      orgiFrame;

+ (void)showImage:(UIImage *)image frame:(CGRect)frame;

@end;
