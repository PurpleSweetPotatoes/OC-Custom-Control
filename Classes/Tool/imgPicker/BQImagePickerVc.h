//
//  BQImagePickerVc.h
//  DrawingBoard
//
//  Created by baiqiang on 2019/3/22.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PickerCompletedBlock)(NSArray * arr);

/*
 使用相册需在info.plist文件中添加
 NSPhotoLibraryUsageDescription字段
*/

/// 自定义多图片选择器
@interface BQImagePickerVc : UIViewController
@property (nonatomic, assign) NSInteger                maxSelecd;   ///< 最大选择数,默认为1
@property (nonatomic, assign) PHAssetCollectionSubtype sourceType;  ///< 资源类型，默认为PHAssetCollectionSubtypeSmartAlbumUserLibrary

/**
 选取成功返回对应 image 或 video 数组
 */
- (void)configSelectCompletedHandle:(PickerCompletedBlock)handle;

- (void)configAuthFailHanle:(PickerCompletedBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
