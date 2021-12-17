//
//  UIImage+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PHAssetForURLImageResultBlock)(UIImage * image);

typedef NS_ENUM(NSUInteger, BQArrowDirection) {
    BQArrowDirection_Top,             ///< 上箭头
    BQArrowDirection_bottom,          ///< 下箭头
    BQArrowDirection_Left,            ///< 左箭头
    BQArrowDirection_Right,           ///< 右箭头
};

@interface UIImage (Custom)

#pragma mark - 二维码

/**
 *  二维码生成
 *  @param content 二维码文本内容
 */
+ (UIImage *)createCodeImageWithContent:(NSString *)content;

/**
 *  高清二维码生成
 *  @param content 二维码文本内容
 *  @param size    生成后的二维码图片大小
 */
+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size;

/**
 *  生成带标示的二维码
 *  @param content 二维码文本内容
 *  @param size    生成后的二维码图片大小
 *  @param logo    标示图片
 */
+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size logo:(UIImage *)logo;

/**
 *  带颜色的高清二维码
 *  @param content 二维码文本内容
 *  @param size    生成后的二维码图片大小
 *  @param red     红色值
 *  @param green   绿色值
 *  @param blue    蓝色值
 */
+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 *  带颜色标示符的高清二维码
 *  @param content 二维码文本内容
 *  @param size    生成后的二维码图片大小
 *  @param logo    标示图片
 *  @param red     红色值
 *  @param green   绿色值
 *  @param blue    蓝色值
 */
+ (UIImage *)createCodeImageWithContent:(NSString *)content size:(CGFloat)size logo:(UIImage *)logo red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

#pragma mark - 压缩

/** 裁剪成正方形
 *  width > 0，根据width进行压缩
 *  width <= 0,根据原图尺寸最小值进行压缩
 */
+ (UIImage *)imageWithImage:(UIImage *)image aimWidth:(NSInteger)width;

/**
 *  裁剪成正方形
 *  根据原图尺寸最小值进行剪切
 */
+ (UIImage *)rectImageWithImage:(UIImage *)image;

/**
 裁剪为圆形(请保证图片宽高相同)
 */
+ (UIImage *)roundImageWithImage:(UIImage *)image;

/** 指定尺寸压缩 */
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  质量不变，压缩到指定大小
 *  aimLength：目标大小
 *  accurancyOfLength：压缩控制误差范围(+ / -)
 *  maxCircleNum:最大循环次数
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimLength:(NSInteger)length accurancyOfLength:(NSInteger)accuracy maxCircleNum:(int)maxCircleNum;

/**
 *  压缩图片质量
 *  aimWidth:  （宽高最大值）
 *  aimLength: 目标大小，单位：字节（b）
 *  accuracyOfLength: 压缩控制误差范围(+ / -)
 *  推荐使用个方法对图片进行压缩
 */
+ (NSData *)compressImageWithImage:(UIImage *)image aimWidth:(CGFloat)width aimLength:(NSInteger)length accuracyOfLength:(NSInteger)accuracy;

#pragma mark - 图片选择器

/// 根据系统返回的图片字典信息获取源图片
/// @param info 系统图片信息
+ (UIImage *)originalImageFromImagePickerMediaInfo:(NSDictionary *)info;

/// 根据系统返回的图片字典信息获取源图片
/// @param info 系统图片信息
/// @param resultBlock 未获取到图片回调处理
+ (UIImage *)originalImageFromImagePickerMediaInfo:(NSDictionary *)info resultBlock:(nullable PHAssetForURLImageResultBlock)resultBlock;

/// 根据系统返回的图片字典信息获取编辑后的图片
/// @param info 系统图片信息
+ (UIImage *)editedImageFromImagePickerMediaInfo:(NSDictionary *)info;

/// 根据系统返回的图片字典信息获取编辑后的图片
/// @param info 系统图片信息
/// @param resultBlock 未获取到图片回调处理
+ (UIImage *)editedImageFromImagePickerMediaInfo:(NSDictionary *)info resultBlock:(nullable PHAssetForURLImageResultBlock)resultBlock;

/// 图片方向调整，调整为正向
/// @param aImage 源图片
+ (UIImage *)adjustImageOrientation:(UIImage*)aImage;

#pragma mark - 屏幕、保存

/**
 截取当前屏幕,不含状态栏(时间、信号等),
 如需要状态栏信息，可直接使用[view snapshotViewAfterScreenUpdates:NO]
 */
+ (UIImage *)snapshootFromSncreen;


/// 保存图片至相册，需开通相册权限
/// @param reslutBlock 图片保存结果
- (void)saveToPhotosWithReslut:(void(^)(NSError *error))reslutBlock;

#pragma mark - icon变色


/// 改变icon颜色
/// @param color 颜色
- (UIImage *)imageWithColor:(UIColor *)color;

#pragma mark - Blur Image

/**
 *  Get blured image.
 *
 *  @return Blured image.
 */
- (UIImage *)blurImage;

/**
 *  Get the blured image masked by another image.
 *
 *  @param maskImage Image used for mask.
 *
 *  @return the Blured image.
 */
- (UIImage *)blurImageWithMask:(UIImage *)maskImage;

/**
 *  Get blured image and you can set the blur radius.
 *
 *  @param radius Blur radius.
 *
 *  @return Blured image.
 */
- (UIImage *)blurImageWithRadius:(CGFloat)radius;

/**
 *  Get blured image at specified frame.
 *
 *  @param frame The specified frame that you use to blur.
 *
 *  @return Blured image.
 */
- (UIImage *)blurImageAtFrame:(CGRect)frame;

#pragma mark - Grayscale Image

/**
 *  Get grayScale image.
 *
 *  @return GrayScaled image.
 */
- (UIImage *)grayScale;

#pragma mark - Some Useful Method

/**
 *  Scale image with fixed width.
 *
 *  @param width The fixed width you give.
 *
 *  @return Scaled image.
 */
- (UIImage *)scaleWithFixedWidth:(CGFloat)width;

/**
 *  Scale image with fixed height.
 *
 *  @param height The fixed height you give.
 *
 *  @return Scaled image.
 */
- (UIImage *)scaleWithFixedHeight:(CGFloat)height;

/**
 *  Get the image average color.
 *
 *  @return Average color from the image.
 */
- (UIColor *)averageColor;

/**
 *  Get cropped image at specified frame.
 *
 *  @param frame The specified frame that you use to crop.
 *
 *  @return Cropped image
 */
- (UIImage *)croppedImageAtFrame:(CGRect)frame;

/**
 * 生成箭头图片,建议宽高比为14:22
 */
+ (UIImage *)arrowImgWithFrame:(CGRect)frame color:(UIColor *)color lineWidth:(CGFloat)line direction:(BQArrowDirection)direction;

#pragma mark - 视屏流转换

- (CVPixelBufferRef)converToPixelBuffer;

/**
 获取视频第一帧图片

 @param urlPath 本地视频路径
 @return 第一帧图片
 */
+ (UIImage *)getFirstVideoImage:(NSString *)urlPath;
@end
