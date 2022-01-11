// *******************************************
//  File Name:      CollectionImgCell.h       
//  Author:         MrBai
//  Created Date:   2022/1/4 11:57 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

#import "ImgModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface CollectionImgCell : UICollectionViewCell

- (void)configInfo:(ImgModel *)model;
@end

NS_ASSUME_NONNULL_END
