// *******************************************
//  File Name:      BQLaunchConfig.m       
//  Author:         MrBai
//  Created Date:   2021/12/16 11:03 AM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQLaunchConfig.h"

@interface BQLaunchConfig ()

@end

@implementation BQLaunchConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.removeTime = 0.5;
        self.animateType = UIViewAnimationOptionTransitionNone;
    }
    return self;
}
@end
