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

@interface BQPhotoView : UIView
@property (nonatomic, weak) id<BQPhotoViewDelegate> delegate;
@property (nonatomic, strong) UIImageView * imgV;

+ (void)show:(UIImage *)img;

- (void)setImage:(UIImage *)img;

- (void)resetNormal;
@end

NS_ASSUME_NONNULL_END
