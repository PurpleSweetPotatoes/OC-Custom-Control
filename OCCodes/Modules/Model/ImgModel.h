// *******************************************
//  File Name:      ImgModel.h       
//  Author:         MrBai
//  Created Date:   2022/1/4 1:40 PM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImgModel : NSObject
@property (nonatomic, copy  ) NSString * imgName;
@property (nonatomic, assign) CGFloat  width;
@property (nonatomic, assign) CGFloat  height;
@end

NS_ASSUME_NONNULL_END
