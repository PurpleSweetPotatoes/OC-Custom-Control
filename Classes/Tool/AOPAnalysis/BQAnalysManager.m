// *******************************************
//  File Name:      BQAnalysManager.m       
//  Author:         MrBai
//  Created Date:   2021/2/4 3:49 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "BQAnalysManager.h"
#import "AopMethodHook.h"

static AnalysBlock upLoadBlock;

@implementation BQAnalysManager

+ (void)configAnalysBlock:(AnalysBlock)block {
    if (upLoadBlock != nil) {
        NSAssert(0, @"不可重复设置埋点处理回调");
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        upLoadBlock = block;
        [self exchangeMethod:@selector(sendAction:to:from:forEvent:) with:@selector(analysSendAction:to:from:forEvent:) instance:[UIApplication class]];
        [self exchangeMethod:@selector(addTarget:action:) with:@selector(analysAddTarget:action:) instance:[UIGestureRecognizer class]];
        [self exchangeMethod:@selector(initWithTarget:action:) with:@selector(analysInitWithTarget:action:) instance:[UIGestureRecognizer class]];
        [self exchangeMethod:@selector(setSelected:animated:) with:@selector(anaylsSetSelected:animated:) instance:[UITableViewCell class]];
        [self exchangeMethod:@selector(setSelected:) with:@selector(anaylsSetSelected:) instance:[UICollectionViewCell class]];
    });
}

+ (void)analysModel:(NSDictionary *)model {
    if ([model isKindOfClass:[NSDictionary class]] && upLoadBlock) {
        upLoadBlock(model);
    }
}

+ (void)exchangeMethod:(SEL)target with:(SEL)repalce instance:(Class)instance {
    Method orignM = class_getInstanceMethod(instance,target);
    Method newM = class_getInstanceMethod(instance, repalce);
    BOOL isAdd = class_addMethod(instance, target, method_getImplementation(newM), method_getTypeEncoding(newM));
    if (isAdd) {
        class_replaceMethod(self, repalce, method_getImplementation(orignM), method_getTypeEncoding(orignM));
    }else{
        method_exchangeImplementations(orignM, newM);
    }
}
@end
