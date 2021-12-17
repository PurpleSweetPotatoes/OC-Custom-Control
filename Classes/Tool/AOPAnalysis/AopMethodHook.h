// *******************************************
//  File Name:      AopMethodHook.h       
//  Author:         MrBai
//  Created Date:   2021/2/5 3:53 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// hook orgin method swip with `analys+methodName`

@interface UIApplication (anayls)
- (BOOL)analysSendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event;
@end

@interface UIGestureRecognizer (anayls)
- (instancetype)analysInitWithTarget:(id)target action:(SEL)action;
- (void)analysAddTarget:(id)target action:(SEL)action;
@end

@interface UITableViewCell (anayls)
- (void)anaylsSetSelected:(BOOL)selected animated:(BOOL)animated;
@end

@interface UICollectionViewCell (anayls)
- (void)anaylsSetSelected:(BOOL)selected;
@end

NS_ASSUME_NONNULL_END
