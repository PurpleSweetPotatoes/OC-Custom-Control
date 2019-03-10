//
//  UIImage+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PHAssetForURLImageResultBlock)(UIImage * image);

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

+ (UIImage *)originalImageFromImagePickerMediaInfo:(NSDictionary *)info;

+ (UIImage *)originalImageFromImagePickerMediaInfo:(NSDictionary *)info resultBlock:(nullable PHAssetForURLImageResultBlock)resultBlock;

+ (UIImage *)editedImageFromImagePickerMediaInfo:(NSDictionary *)info;

+ (UIImage *)editedImageFromImagePickerMediaInfo:(NSDictionary *)info resultBlock:(nullable PHAssetForURLImageResultBlock)resultBlock;

+ (UIImage *)adjustImageOrientation:(UIImage*)image;

#pragma mark - 屏幕、保存

/**
 截取当前屏幕,不含状态栏(时间、信号等),
 如需要状态栏信息，可直接使用[view snapshotViewAfterScreenUpdates:NO]
 */
+ (UIImage *)snapshootFromSncreen;

- (void)saveToPhotosWithReslut:(void(^)(NSError *error))reslutBlock;

#pragma mark - icon变色

- (UIImage *)imageWithColor:(UIColor *)color;

@end
