//
//  UIImage+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "UIImage+Custom.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <Photos/Photos.h>
#import <objc/runtime.h>

@implementation UIImage (QRcode)

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

@end


@implementation UIImage (Zip)

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

@end


@implementation UIImage (UIImagePickerControllerDidFinishPickingMedia)

+ (UIImage*)originalImageFromImagePickerMediaInfo:(NSDictionary*)info {
    return [UIImage imageFromImagePickerMediaInfo:info imageType:UIImagePickerControllerOriginalImage resultBlock:nil];
}

+ (UIImage*)originalImageFromImagePickerMediaInfo:(NSDictionary*)info resultBlock:(ALAssetsLibraryAssetForURLImageResultBlock)resultBlock {
    return [UIImage imageFromImagePickerMediaInfo:info imageType:UIImagePickerControllerOriginalImage resultBlock:resultBlock];
}

+ (UIImage*)editedImageFromImagePickerMediaInfo:(NSDictionary*)info {
    return [UIImage imageFromImagePickerMediaInfo:info imageType:UIImagePickerControllerEditedImage resultBlock:nil];
}

+ (UIImage*)editedImageFromImagePickerMediaInfo:(NSDictionary*)info resultBlock:(ALAssetsLibraryAssetForURLImageResultBlock)resultBlock {
    return [UIImage imageFromImagePickerMediaInfo:info imageType:UIImagePickerControllerEditedImage resultBlock:resultBlock];
}

+ (UIImage*)imageFromImagePickerMediaInfo:(NSDictionary*)info imageType:(NSString*)imageType resultBlock:(ALAssetsLibraryAssetForURLImageResultBlock)resultBlock {
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
//                options.synchronous = YES;
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

+ (UIImage *)adjustImageOrientation:(UIImage*)image {
    
    UIImageOrientation imageOrientation = image.imageOrientation;
    
    if(imageOrientation != UIImageOrientationUp) {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会逆时针旋转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    return image;
}
@end

@implementation UIImage (Screen)

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
@end
