//
//  BQVideoTool.m
//  TianyaTest
//
//  Created by MrBai on 2018/7/17.
//  Copyright © 2018年 MrBai. All rights reserved.
//

#import "BQVideoTool.h"
#import <AVFoundation/AVFoundation.h>


@implementation BQVideoTool

+ (void)exportVideoWithUrl:(NSString *)urlPath presetName:(NSString *)presetName completeHandle:(void(^)(NSString * exportUrl))handle {
    
    if (!presetName) {
        presetName = AVAssetExportPresetMediumQuality;
    }
    
    NSString* tmpName = [NSString stringWithFormat:@"VID%.0f",[NSDate timeIntervalSinceReferenceDate] * 1000];
    NSString * exportPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:tmpName] stringByAppendingString:@".mp4"];
    NSURL *uploadURL = [NSURL fileURLWithPath:exportPath];
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:urlPath] options:nil];
    AVAssetExportSession *avSession = [AVAssetExportSession exportSessionWithAsset:asset presetName:presetName];
    
    avSession.shouldOptimizeForNetworkUse = YES;
    avSession.outputFileType  = AVFileTypeMPEG4;
    avSession.outputURL       = uploadURL;
    
    [avSession exportAsynchronouslyWithCompletionHandler:^{
        if (avSession.status == AVAssetExportSessionStatusCompleted) {
            handle(exportPath);
        } else {
            handle(urlPath);
        }
    }];
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
