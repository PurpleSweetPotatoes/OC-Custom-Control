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

@class BQGestureView;

@protocol BQGestureViewDelegate <NSObject>
@optional

- (void)gestureView:(BQGestureView *)view tapPoint:(CGPoint)point;

/// when begin use pinValue as orgin value to get change value
- (void)gestureViewPinBegin:(BQGestureView *)view;
- (void)gestureViewPinChange:(BQGestureView *)view changeValue:(CGFloat)value;
- (void)gestureViewPinEnd:(BQGestureView *)view;

- (void)gestureViewSwip:(BQGestureView *)view toLeft:(BOOL)toLeft;

@end

@interface BQGestureView : UIView
@property (nonatomic, weak) id<BQGestureViewDelegate>  delegate;
@property (nonatomic, assign) CGFloat  pinValue;
@end

NS_ASSUME_NONNULL_END
