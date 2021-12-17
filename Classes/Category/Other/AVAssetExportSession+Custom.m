// *******************************************
//  File Name:      AVAssetExportSession+Custom.m       
//  Author:         MrBai
//  Created Date:   2021/6/22 10:28 PM
//    
//  Copyright © 2021 William
//  All rights reserved
// *******************************************
    

#import "AVAssetExportSession+Custom.h"

static NSString * const typeKey  = @"typeKey";
static NSString * const typeName = @"typeName";

@implementation AVAssetExportSession (Custom)

+ (AVMutableComposition *)compositionWithTrackList:(NSArray<BQAssetTrack *> *)trackList {
    if (trackList.count == 0) {
        return nil;
    }
    AVMutableComposition *composition = [AVMutableComposition composition];
    for (BQAssetTrack * track in trackList) {
        AVMutableCompositionTrack * comTrack = [composition addMutableTrackWithMediaType:track.track.mediaType preferredTrackID:kCMPersistentTrackID_Invalid];
        NSLog(@"%@", track);
        if (![comTrack insertTimeRange:track.insertRange ofTrack:track.track atTime:track.atTime error:nil]) {
            NSLog(@"AVAssetTrack导入失败");
        }
    }
    
    return composition;
}

+ (AVAssetExportSession *)compositionFileWithType:(FileExportType)type trackList:(NSArray<BQAssetTrack *> *)trackList presetName:(NSString *)presetName handle:(void(^)(NSString * exportUrl, NSString * errDesc))handle {
    
    AVMutableComposition * composition = [self compositionWithTrackList:trackList];
    
    if (composition == nil) {
        if (handle) {
            handle(nil, @"素材列表不能为空");
        }
        return nil;
    }
    
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:composition];
    if ([presets containsObject:presetName]) {
        return [self exportFileWithAsseter:composition type:type presetName:presetName handle:handle];;
    } else {
        if (handle) {
            handle(nil, [NSString stringWithFormat:@"当前设备不支持该预设:%@", presetName]);
        }
    }
    return nil;
}

+ (AVAssetExportSession *)exportFileWithUrl:(NSString *)url type:(FileExportType)type presetName:(NSString *)presetName handle:(void(^)(NSString * exportUrl, NSString * errDesc))handle {
    if (url.length == 0) {
        handle(nil, @"目标路径不能为空!");
        return nil;
    }
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:url]];
    return [self exportFileWithAsseter:asset type:type presetName:presetName handle:handle];
}

+ (AVAssetExportSession *)exportFileWithAsseter:(AVAsset *)asset type:(FileExportType)type presetName:(NSString *)presetName handle:(void(^)(NSString * exportUrl, NSString * errDesc))handle {
    AVAssetExportSession * session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:presetName];
    session.shouldOptimizeForNetworkUse = YES;
    NSArray *supportedTypeArray = session.supportedFileTypes;
    AVFileType fileType = [self exportInfo:type][typeKey];
    if ([supportedTypeArray containsObject:fileType]) {
        session.outputFileType = fileType;
    } else {
        if (handle) {
            handle(nil, [NSString stringWithFormat:@"暂不支持导出该类型:%@", fileType]);
        }
        return nil;
    }
    
    NSString * outputPath = [NSString stringWithFormat:@"%@%@.%@",NSTemporaryDirectory() ,[NSUUID UUID].UUIDString, [self exportInfo:type][typeName]];

    if ([[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:nil];
    }
    
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (session.status) {
                case AVAssetExportSessionStatusUnknown: {
                    NSLog(@"AVAssetExportSessionStatusUnknown");
                }  break;
                case AVAssetExportSessionStatusWaiting: {
                    NSLog(@"AVAssetExportSessionStatusWaiting");
                }  break;
                case AVAssetExportSessionStatusExporting: {
                    NSLog(@"AVAssetExportSessionStatusExporting");
                }  break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    if (handle) {
                        handle(outputPath, nil);
                    }
                }  break;
                case AVAssetExportSessionStatusFailed: {
                    if (handle) {
                        handle(nil, session.error.localizedDescription);
                    }
                }  break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"AVAssetExportSessionStatusCancelled");
                    if (handle) {
                        handle(nil, @"导出任务取消");
                    }
                }  break;
                default: break;
            }
        });
    }];
    return session;
}


+ (NSDictionary *)exportInfo:(FileExportType)type {
    return @[
        @{
            typeKey: AVFileTypeMPEG4,
            typeName: @"mp4"
        },
        @{
            typeKey: AVFileTypeQuickTimeMovie,
            typeName: @"mov"
        },
        @{
            typeKey: AVFileTypeAppleM4A,
            typeName: @"m4a"
        },
        @{
            typeKey: AVFileTypeCoreAudioFormat,
            typeName: @"caf"
        }
    ][type];
}
@end


@implementation BQAssetTrack

+ (instancetype)assetWithTrack:(AVAssetTrack *)track {
    BQAssetTrack * bqTrack = [[BQAssetTrack alloc] init];
    bqTrack.track = track;
    bqTrack.insertRange = CMTimeRangeMake(kCMTimeZero, track.asset.duration);
    bqTrack.atTime = kCMTimeZero;
    return bqTrack;
}

- (void)insertRangeStart:(NSUInteger)start duration:(NSUInteger)duration {
    NSAssert((CMTimeGetSeconds(_track.asset.duration) - start) >= duration, @"取样区间不在素材区间范围内");
    _insertRange = CMTimeRangeMake(CMTimeMake(start, 1), CMTimeMake(duration, 1));
}

- (void)insertTime:(NSUInteger)seconde {
    _atTime = CMTimeMake(seconde, 1);
}

@end
