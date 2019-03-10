//
//  BQPopView.h
//  Test
//
//  Created by MAC on 16/11/2.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQDefineHead.h"

@interface BQMsgView : UIView

+ (void)showInfo:(NSString *)info;

+ (void)showInfo:(NSString *)info
   completeBlock:(VoidBlock)callblock;

+ (void)showTitle:(NSString *)title
             info:(NSString *)info;

+ (void)showTitle:(NSString *)title
             info:(NSString *)info
    completeBlock:(VoidBlock)callblock;
@end
