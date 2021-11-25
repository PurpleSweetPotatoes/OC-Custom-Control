//
//  UIImage+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIImage+Custom.h"

#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Photos/Photos.h>
#import <Photos/Photos.h>
#import <float.h>
#import <objc/runtime.h>

@import Accelerate;
@implementation UIImage (Custom)

+ (UIImage *)createCodeImageWithContent:(NSString *)content {
    UIImage *image = [UIImage imageWithCIImage:[self createCodeCIImageWithContent:content]];
    return image;
}

+ (UIImage *)createCodeImageWithContent:(NSString *)content
                                   size:(CGFloat)size {
    
    CIImage *image = [self createCodeCIImageWithContent:content];
    //获得生成的二维码坐标信息
    CGRect extent = CGRectIntegral(image.extent);
    //获得缩放比例
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //颜色灰度配置
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //创建绘图上下文
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    //创建图像上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    //在图像上下文中创建图片并设置大小
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    //设置插值质量,不设置线性插值 清晰度更高
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    //对上下文大小进行缩放
    CGContextScaleCTM(bitmapRef, scale, scale);
    //对上下文进行图像绘制
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    //释放创建的对象
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    //转换成uiimage
    //6.返回生成好的二维码
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)createCodeImageWithContent:(NSString *)content
                                   size:(CGFloat)size logo:(UIImage *)logo {
    UIImage *image = [self createCodeImageWithContent:content size:size];
    return [image addlogo:logo];
}

+ (UIImage *)createCodeImageWithContent:(NSString *)content
                                   size:(CGFloat)size
                                    red:(NSInteger)red
                                  green:(NSInteger)green
                                   blue:(NSInteger)blue {
    
    UIImage *image = [UIImage createCodeImageWithContent:content size:size];
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,  kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, nil);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

+ (UIImage *)createCodeImageWithContent:(NSString *)content
                                   size:(CGFloat)size logo:(UIImage *)logo red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    UIImage *image = [self createCodeImageWithContent:content size:size red:red green:green blue:blue];
    return [image addlogo:logo];
}

+ (CIImage *)createCodeCIImageWithContent:(NSString *)content {
    //1.实例化滤镜
    CIFilter *filder = [CIFilter filterWithName:@"CIQRCodeGenerator"];//名字不能错
    //2.恢复滤镜默认属性（有可能会保存上一次的属性）
    [filder setDefaults];
    //3.将我们的字符串转换成DSData
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    //4.通过KVO设置滤镜，传入data，将来滤镜就知道要传入的数据生成二维码
    [filder setValue:data forKey:@"inputMessage"];//名字不能错，固定
    [filder setValue:@"H" forKey:@"inputCorrectionLevel"];
    //5.生成二维码
    CIImage *outputImage = [filder outputImage];
    
    return outputImage;
}

- (UIImage *)addlogo:(UIImage *)logo {
    // 添加logo
    CGFloat logoW = self.size.width / 5.;
    CGRect logoFrame = CGRectMake(logoW * 2, logoW * 2, logoW, logoW);
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [logo drawInRect:logoFrame];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

#pragma mark - 压缩

+ (UIImage *)imageWithImage:(UIImage *)image aimWidth:(NSInteger)width{
    if (!image) {
        return nil;
    }
    UIImage * newImage = [self rectImageWithImage:image];
    if (width > 0 && newImage.size.width > width) {
        return [self imageWithImage:newImage scaledToSize:CGSizeMake(width, width)];
    }
    return newImage;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    if (!image) {
        return nil;
    }
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)rectImageWithImage:(UIImage *)image{
    CGImageRef  image_cg = [image CGImage];
    CGSize      imageSize = CGSizeMake(CGImageGetWidth(image_cg), CGImageGetHeight(image_cg));
    
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    CGFloat width;
    CGPoint purePoint;
    if (imageWidth > imageHeight){
        width = imageHeight;
        purePoint = CGPointMake((imageWidth - width) / 2, 0);
    }else{
        width = imageWidth;
        purePoint = CGPointMake(0, (imageHeight - width) / 2);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(purePoint.x, purePoint.y, width, width));
    UIImage * thumbImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbImage;
    
}

+ (UIImage *)roundImageWithImage:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextAddEllipseInRect(context,CGRectMake(0,0,image.size.width,image.size.width));
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
}

+ (NSData *)compressImageWithImage:(UIImage *)image aimLength:(NSInteger)length accurancyOfLength:(NSInteger)accuracy maxCircleNum:(int)maxCircleNum{
    NSData * imageData = UIImageJPEGRepresentation(image, 1);
    CGFloat scale = image.size.height/image.size.width;
    if (imageData.length <= length + accuracy) {
        return imageData;
    }else{
        //先对质量进行0.99的压缩，再压缩尺寸
        NSData * imgData = UIImageJPEGRepresentation(image, 0.99);
        if (imgData.length <= length + accuracy) {
            return imgData;
        }else{
            UIImage * img = [UIImage imageWithData:imgData];
            int flag = 0;
            NSInteger maxWidth = img.size.width;
            NSInteger minWidth = 50;
            NSInteger midWidth = (maxWidth + minWidth)/2;
            if (flag == 0) {
                UIImage * newImage = [UIImage imageWithImage:img scaledToSize:CGSizeMake(minWidth, minWidth*scale)];
                NSData * data = UIImageJPEGRepresentation(newImage, 1);
                if ([data length] > length + accuracy) {
                    return data;
                }
            }
            
            while (1) {
                flag ++ ;
                UIImage * newImage = [UIImage imageWithImage:img scaledToSize:CGSizeMake(midWidth, midWidth*scale)];
                NSData * data = UIImageJPEGRepresentation(newImage, 1);
                NSInteger imageLength = data.length;
                if (flag >= maxCircleNum) {
                    return data;
                }
                
                if (imageLength > length + accuracy) {
                    maxWidth = midWidth;
                    midWidth = (minWidth + maxWidth)/2;
                    continue;
                }else if (imageLength < length - accuracy){
                    minWidth = midWidth;
                    midWidth = (minWidth + maxWidth)/2;
                    continue;
                }else{
                    return data;
                }
            }
        }
    }
}

+ (NSData *)compressImageWithImage:(UIImage *)image aimWidth:(CGFloat)width aimLength:(NSInteger)length accuracyOfLength:(NSInteger)accuracy{
    CGFloat imgWidth = image.size.width;
    CGFloat imgHeight = image.size.height;
    CGSize  aimSize;
    if (width >= (imgWidth > imgHeight ? imgWidth : imgHeight)) {
        aimSize = image.size;
    }else{
        if (imgHeight > imgWidth) {
            aimSize = CGSizeMake(width*imgWidth/imgHeight, width);
        }else{
            aimSize = CGSizeMake(width, width*imgHeight/imgWidth);
        }
    }
    UIImage * newImage = [UIImage imageWithImage:image scaledToSize:aimSize];
    
    NSData  * data = UIImageJPEGRepresentation(newImage, 1);
    NSInteger imageDataLen = [data length];
    
    if (imageDataLen <= length + accuracy) {
        return data;
    }else{
        NSData * imageData = UIImageJPEGRepresentation( newImage, 0.99);
        if (imageData.length < length + accuracy) {
            return imageData;
        }
        
        
        CGFloat maxQuality = 1.0;
        CGFloat minQuality = 0.0;
        int flag = 0;
        
        while (1) {
            CGFloat midQuality = (maxQuality + minQuality)/2;
            
            if (flag >= 6) {
                NSData * data = UIImageJPEGRepresentation(newImage, minQuality);
                return data;
            }
            flag ++;
            
            NSData * imageData = UIImageJPEGRepresentation(newImage, midQuality);
            NSInteger len = imageData.length;
            
            if (len > length+accuracy) {
                maxQuality = midQuality;
                continue;
            }else if (len < length-accuracy){
                minQuality = midQuality;
                continue;
            }else{
                return imageData;
                break;
            }
        }
    }
}

#pragma mark - 图片选择器

+ (UIImage*)originalImageFromImagePickerMediaInfo:(NSDictionary*)info {
    return [UIImage imageFromImagePickerMediaInfo:info imageType:UIImagePickerControllerOriginalImage resultBlock:nil];
}

+ (UIImage*)originalImageFromImagePickerMediaInfo:(NSDictionary*)info resultBlock:(PHAssetForURLImageResultBlock)resultBlock {
    return [UIImage imageFromImagePickerMediaInfo:info imageType:UIImagePickerControllerOriginalImage resultBlock:resultBlock];
}

+ (UIImage*)editedImageFromImagePickerMediaInfo:(NSDictionary*)info {
    return [UIImage imageFromImagePickerMediaInfo:info imageType:UIImagePickerControllerEditedImage resultBlock:nil];
}

+ (UIImage*)editedImageFromImagePickerMediaInfo:(NSDictionary*)info resultBlock:(PHAssetForURLImageResultBlock)resultBlock {
    return [UIImage imageFromImagePickerMediaInfo:info imageType:UIImagePickerControllerEditedImage resultBlock:resultBlock];
}

+ (UIImage*)imageFromImagePickerMediaInfo:(NSDictionary*)info imageType:(NSString*)imageType resultBlock:(PHAssetForURLImageResultBlock)resultBlock {
    UIImage* image=nil;
    
    NSString* mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString*)kUTTypeImage]) {//(NSString*)kUTTypeImage,public.image
        image= [info objectForKey:imageType];
        
        if(!image) {
            NSURL * imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
            PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[imageFileURL] options:nil];
            PHAsset *asset = fetchResult.firstObject;
            
            if (asset.mediaType == PHAssetMediaTypeImage) {
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.version = PHImageRequestOptionsVersionCurrent;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData * imageData,NSString * dataUTI,UIImageOrientation orientation,NSDictionary *info) {
                    if (imageData) {
                        UIImage * resultImage = [[UIImage alloc] initWithData:imageData] ;
                        resultBlock([UIImage adjustImageOrientation:resultImage]);
                    }else {
                        resultBlock(nil);
                    }
                    
                 }];
            }
        } else {
            if([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                image = [UIImage adjustImageOrientation:image];
            }
        }
    }
    
    return image;
}

+ (UIImage *)adjustImageOrientation:(UIImage*)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - 屏幕、保存

+ (UIImage *)snapshootFromSncreen {
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)saveToPhotosWithReslut:(void(^)(NSError *error))reslutBlock {
    //plist文件需要添加 Privacy - Photo Library Additions Usage Description 字段
    objc_setAssociatedObject(self, "resultBlock", reslutBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    void(^clickedBlock)(NSError *error) = objc_getAssociatedObject(self, "resultBlock");
    clickedBlock(error);
}

#pragma mark - icon变色

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)applyLightEffect{
    
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyExtraLightEffect {
    
    UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyDarkEffect {
    
    UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
    return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor {
    
    const CGFloat EffectColorAlpha = 0.6;
    UIColor      *effectColor      = tintColor;
    int           componentCount   = (int)CGColorGetNumberOfComponents(tintColor.CGColor);
    
    if (componentCount == 2) {
        
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
        
    } else {
        
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    
    return [self applyBlurWithRadius:20 tintColor:effectColor saturationDeltaFactor:1.4 maskImage:nil];
}

- (UIImage *)blurImage {
    
    return [self applyBlurWithRadius:20
                           tintColor:[UIColor colorWithWhite:0 alpha:0.0]
               saturationDeltaFactor:1.4
                           maskImage:nil];
}

- (UIImage *)blurImageWithRadius:(CGFloat)radius {
    
    return [self applyBlurWithRadius:radius
                           tintColor:[UIColor colorWithWhite:0 alpha:0.0]
               saturationDeltaFactor:1.4
                           maskImage:nil];
}

- (UIImage *)blurImageWithMask:(UIImage *)maskImage {
    
    return [self applyBlurWithRadius:20
                           tintColor:[UIColor colorWithWhite:0 alpha:0.0]
               saturationDeltaFactor:1.4
                           maskImage:maskImage];
}

- (UIImage *)blurImageAtFrame:(CGRect)frame {
    
    return [self applyBlurWithRadius:20
                           tintColor:[UIColor colorWithWhite:0 alpha:0.0]
               saturationDeltaFactor:1.4
                           maskImage:nil
                             atFrame:frame];
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        
        NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    
    if (!self.CGImage) {
        
        NSLog (@"*** error: image must be backed by a CGImage: %@", self);
        return nil;
    }
    
    if (maskImage && !maskImage.CGImage) {
        
        NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect   imageRect   = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur             = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
        }
        
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            
            if (hasBlur) {
                
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
                
            } else {
                
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        
        if (!effectImageBuffersAreSwapped) {
            
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped) {
            
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        
        CGContextSaveGState(outputContext);
        
        if (maskImage) {
            
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIImage *)grayScale {
    
    int width  = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate(nil,
                                                 width,
                                                 height,
                                                 8, // bits per component
                                                 0,
                                                 colorSpace,
                                                 kCGBitmapByteOrderDefault);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef image   = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:image];
    CFRelease(image);
    CGContextRelease(context);
    
    return grayImage;
}

- (UIImage *)scaleWithFixedWidth:(CGFloat)width {
    
    float newHeight = self.size.height * (width / self.size.width);
    CGSize size     = CGSizeMake(width, newHeight);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}

- (UIImage *)scaleWithFixedHeight:(CGFloat)height {
    
    float newWidth = self.size.width * (height / self.size.height);
    CGSize size    = CGSizeMake(newWidth, height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}

- (UIColor *)averageColor {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

- (UIImage *)croppedImageAtFrame:(CGRect)frame {
    CGImageRef newImageRef = CGImageCreateWithImageInRect(self.CGImage, frame);
    UIImage * newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}

- (UIImage *)addImageToImage:(UIImage *)img atRect:(CGRect)cropRect {
    
    CGSize size = CGSizeMake(self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
    CGPoint pointImg1 = CGPointMake(0,0);
    [self drawAtPoint:pointImg1];
    
    CGPoint pointImg2 = cropRect.origin;
    [img drawAtPoint: pointImg2];
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
                       tintColor:(UIColor *)tintColor
           saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                       maskImage:(UIImage *)maskImage
                         atFrame:(CGRect)frame
{
    UIImage *blurredFrame = \
    [[self croppedImageAtFrame:frame] applyBlurWithRadius:blurRadius
                                                tintColor:tintColor
                                    saturationDeltaFactor:saturationDeltaFactor
                                                maskImage:maskImage];
    
    return [self addImageToImage:blurredFrame atRect:frame];
}

+ (UIImage *)arrowImgWithFrame:(CGRect)frame color:(UIColor *)color lineWidth:(CGFloat)line direction:(BQArrowDirection)direction {
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef ct = UIGraphicsGetCurrentContext();
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGPoint startPoint, centerPoint, endPoint;
    switch (direction) {
        case BQArrowDirection_Top:
            startPoint = CGPointMake(line, height - line);
            centerPoint = CGPointMake(width * 0.5, line);
            endPoint = CGPointMake(width - line, height - line);
            break;
        case BQArrowDirection_bottom:
            startPoint = CGPointMake(line, line);
            centerPoint = CGPointMake(width * 0.5, height - line);
            endPoint = CGPointMake(width - line, line);
            break;
        case BQArrowDirection_Left:
            startPoint = CGPointMake(width - line, line);
            centerPoint = CGPointMake(line, height * 0.5);
            endPoint = CGPointMake(width - line, height - line);
            break;
        case BQArrowDirection_Right:
            startPoint = CGPointMake(line, line);
            centerPoint = CGPointMake(width - line, height * 0.5);
            endPoint = CGPointMake(line, height - line);
            break;
        default:
            break;
    }
    CGContextSetLineJoin(ct, kCGLineJoinRound);
    CGContextSetLineCap(ct, kCGLineCapRound);
    CGContextMoveToPoint(ct, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(ct, centerPoint.x, centerPoint.y);
    CGContextAddLineToPoint(ct, endPoint.x, endPoint.y);
    CGContextSetLineWidth(ct, line);
    CGContextSetStrokeColorWithColor(ct, color.CGColor);
    CGContextStrokePath(ct);
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - 视屏流转换

- (CVPixelBufferRef)converToPixelBuffer {
    CGImageRef imageRef=[self CGImage];
    
    CGSize frameSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    NSDictionary *options = @{
                              (__bridge NSString *)kCVPixelBufferCGImageCompatibilityKey: @(NO),
                              (__bridge NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @(NO)
                              };
    CVPixelBufferRef pixelBuffer;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width,
                                          frameSize.height,  kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pixelBuffer);
    if (status != kCVReturnSuccess) {
        return NULL;
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void *data = CVPixelBufferGetBaseAddress(pixelBuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, frameSize.width, frameSize.height,
                                                 8, CVPixelBufferGetBytesPerRow(pixelBuffer), rgbColorSpace,
                                                 (CGBitmapInfo) kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(imageRef),
                                           CGImageGetHeight(imageRef)), imageRef);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return pixelBuffer;
}

+ (UIImage *)getFirstVideoImage:(NSString *)urlPath {
    
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:urlPath]];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    // 截图时调整到正确的方向
    imageGenerator.appliesPreferredTrackTransform = YES;
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime; // 缩略图的实际生成时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (error) {
        NSLog(@"获取视频图片失败:%@", error.localizedDescription);
    }
    CMTimeShow(actualTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return  image;
}
@end
