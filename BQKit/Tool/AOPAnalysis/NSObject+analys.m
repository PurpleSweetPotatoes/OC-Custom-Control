// *******************************************
//  File Name:      NSObject+analys.m       
//  Author:         MrBai
//  Created Date:   2021/2/5 4:34 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "NSObject+analys.h"
#import <objc/runtime.h>

@implementation NSObject (analys)

- (NSDictionary *)umInfo {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUmInfo:(NSDictionary *)umInfo {
    objc_setAssociatedObject(self, @selector(umInfo), umInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
