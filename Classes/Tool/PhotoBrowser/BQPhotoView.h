// *******************************************
//  File Name:      BQPhotoView.h       
//  Author:         MrBai
//  Created Date:   2020/3/4 10:21 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BQPhotoViewDelegate <NSObject>

- (void)photoTapAction;

@end

/// 自定义图片浏览视图，支持手势操作
@interface BQPhotoView : UIView
@property (nonatomic, weak) id<BQPhotoViewDelegate> delegate;   ///< 图片点击回调
@property (nonatomic, strong) UIImageView * imgV;               ///< 图片展示视图

/// 展示视图
/// @param img 对应图片
+ (instancetype)show:(UIImage *)img;

/// 配置图片
/// @param img 对应图片
- (void)setImage:(UIImage *)img;

/// 恢复默认状态
- (void)resetNormal;

/// 配置进度指示器 0 ~ 1
- (void)setProgressNum:(CGFloat)num;
@end

NS_ASSUME_NONNULL_END
