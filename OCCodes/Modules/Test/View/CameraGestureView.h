// *******************************************
//  File Name:      CameraGestureView.h       
//  Author:         MrBai
//  Created Date:   2021/12/21 5:38 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>
#import "BQCameraManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CameraGestureView : UIView
@property (nonatomic, assign) BQCameraManager * manager;
@end

NS_ASSUME_NONNULL_END
