// *******************************************
//  File Name:      BQSignatureView.h       
//  Author:         MrBai
//  Created Date:   2020/5/27 11:05 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BQSignatureView : UIView

+ (void)showWithHandle:(void(^)(UIImage * img))handle;

@end

NS_ASSUME_NONNULL_END
