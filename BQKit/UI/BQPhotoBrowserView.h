// *******************************************
//  File Name:      BQPhotoBrowserView.h       
//  Author:         MrBai
//  Created Date:   2020/3/4 2:27 PM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 自定义图片浏览器
@interface BQPhotoBrowserView : UIView

+ (void)show:(NSArray <UIImage *> *)imgs;

@end

NS_ASSUME_NONNULL_END
