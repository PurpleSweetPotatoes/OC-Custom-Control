//
//  BQImgPickerCell.h
//  DrawingBoard
//
//  Created by baiqiang on 2019/3/22.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/PHAsset.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BQImgPickCellDelegate <NSObject>

- (BOOL)imgPiackCellBtnActionWithAsset:(PHAsset *)assetModel;

@end

@interface BQImgPickerCell : UICollectionViewCell
@property (nonatomic, weak) id<BQImgPickCellDelegate>   delegate;
@property (nonatomic, weak) PHAsset                     * assetModel;
@end

NS_ASSUME_NONNULL_END
