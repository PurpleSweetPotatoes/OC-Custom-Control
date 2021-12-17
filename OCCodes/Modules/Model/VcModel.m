// *******************************************
//  File Name:      VcModel.m       
//  Author:         MrBai
//  Created Date:   2021/12/16 2:02 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "VcModel.h"

@interface VcModel ()

@end

@implementation VcModel

- (UIViewController *)coverVc {
    Class class = NSClassFromString(self.clsName);
    UIViewController * vc = [[class alloc] init];
    vc.title = self.clsName;
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}

@end
