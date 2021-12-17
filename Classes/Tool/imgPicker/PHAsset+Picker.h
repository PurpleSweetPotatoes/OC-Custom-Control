//
//  PHAsset+Picker.h
//  DrawingBoard
//
//  Created by baiqiang on 2019/3/22.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (Picker)
@property (nonatomic, assign) BOOL    selected;///<  是否选中
@property (nonatomic, strong) UIImage * image;///<  对应图片
@property (nonatomic, strong) NSData  * data;///<  对应数据
@end

NS_ASSUME_NONNULL_END
