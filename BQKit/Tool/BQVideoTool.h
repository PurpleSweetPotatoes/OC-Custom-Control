//
//  BQVideoTool.h
//  TianyaTest
//
//  Created by MrBai on 2018/7/17.
//  Copyright © 2018年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^ExportVideoAssetBlock)(NSData * data, NSError * error);

/** 视频处理类 */
@interface BQVideoTool : NSObject

/**
 压缩本地视频

 @param urlPath 视频路径
 @param presetName 压缩方式
 @param handle 压缩完成回调
 */
+ (void)exportVideoWithUrl:(NSString *)urlPath presetName:(NSString *)presetName completeHandle:(void(^)(NSString * exportUrl))handle;

/**
 使用PHAsset导出视频元数据
 
 @param videoAsset 视频Asset
 @param complete 完成后回调
 */
+ (void)exportVideoAsset:(PHAsset *)videoAsset
                complete:(ExportVideoAssetBlock)complete;

/**
 获取视频第一帧图片

 @param urlPath 本地视频路径
 @return 第一帧图片
 */
+ (UIImage *)getFirstVideoImage:(NSString *)urlPath;

@end
