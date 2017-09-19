//
//  UIImage+corner.h
//  TianyaTest
//
//  Created by MrBai on 2017/9/19.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (corner)

/**
 对图像进行圆角处理，边界处会有1个像素点的失真

 @param radius 半径(像素单位)
 @return 处理后的图像
 */
- (UIImage *)dealCornerRadius:(CGFloat)radius;
@end
