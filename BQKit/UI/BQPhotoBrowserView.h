// *******************************************
//  File Name:      BQPhotoBrowserView.h       
//  Author:         MrBai
//  Created Date:   2020/3/4 2:27 PM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>
#import "BQPhotoView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BQPhotoBrowserViewDelegate <NSObject>

- (NSInteger)numberOfBrowser;

- (void)browserConfigImgV:(BQPhotoView *)photoV index:(NSInteger)index;

@end

/// 自定义图片浏览器
@interface BQPhotoBrowserView : UIView

+ (instancetype)showWithDelegate:(id<BQPhotoBrowserViewDelegate>)delegate;

+ (instancetype)configViewWithFrame:(CGRect)frame delegate:(id<BQPhotoBrowserViewDelegate>)delegate;

@property (nonatomic, weak) id<BQPhotoBrowserViewDelegate>  delegate;

@property (nonatomic, assign) BOOL tapBack;         ///< 单击返回，默认YES

- (void)reLoadData;

@end

NS_ASSUME_NONNULL_END
