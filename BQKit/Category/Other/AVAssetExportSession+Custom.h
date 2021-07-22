// *******************************************
//  File Name:      AVAssetExportSession+Custom.h       
//  Author:         MrBai
//  Created Date:   2021/6/22 10:28 PM
//    
//  Copyright © 2021 William
//  All rights reserved
// *******************************************
    

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, FileExportType) {
    FileExportType_MP4 = 0,
    FileExportType_MOV,
    FileExportType_M4A,
    FileExportType_CAF
};

@interface BQAssetTrack : NSObject

/// 素材
@property (nonatomic, strong) AVAssetTrack * track;

/// 素材取样区间
@property (nonatomic, assign) CMTimeRange  insertRange;

/// 素材插入时间点
@property (nonatomic, assign) CMTime  atTime;

+ (instancetype)assetWithTrack:(AVAssetTrack *)track;

/// 设置素材取样区间
/// @param start 起点
/// @param duration 时长
- (void)insertRangeStart:(NSUInteger)start duration:(NSUInteger)duration;

/// 设置素材插入时间点
- (void)insertTime:(NSUInteger)seconde;

@end


@interface AVAssetExportSession (Custom)

/// 生成素材合成样本,可用于试看
/// @param trackList 素材列表
+ (AVMutableComposition *)compositionWithTrackList:(NSArray<BQAssetTrack *> *)trackList;


/// 压缩导出音视频文件
/// @param type 导出文件类型
/// @param trackList 素材列表
/// @param presetName 导出预设样式
/// @param handle 回调
+ (AVAssetExportSession *)compositionFileWithType:(FileExportType)type
                                        trackList:(NSArray<BQAssetTrack *> *)trackList
                                       presetName:(NSString *)presetName
                                           handle:(void(^)(NSString * exportUrl, NSString * errDesc))handle;

/// 压缩导出音视频文件
/// @param url 本地文件路径
/// @param type 导出文件类型
/// @param presetName 导出预设样式
/// @param handle 回调
+ (AVAssetExportSession *)exportFileWithUrl:(NSString *)url
                                       type:(FileExportType)type
                                 presetName:(NSString *)presetName
                                     handle:(void(^)(NSString * exportUrl, NSString * errDesc))handle;


/// 压缩导出音视频文件
/// @param asset 本地音视频文件
/// @param type 导出文件类型
/// @param presetName 导出预设样式
/// @param handle 回调
+ (AVAssetExportSession *)exportFileWithAsseter:(AVAsset *)asset
                                           type:(FileExportType)type
                                     presetName:(NSString *)presetName
                                         handle:(void(^)(NSString * exportUrl, NSString * errDesc))handle;
@end

NS_ASSUME_NONNULL_END
