// *******************************************
//  File Name:      AopMethodHook.m       
//  Author:         MrBai
//  Created Date:   2021/2/5 3:53 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "AopMethodHook.h"
#import "BQAnalysManager.h"
#import "NSObject+analys.h"
#import <objc/runtime.h>


@implementation UIApplication (anayls)

- (BOOL)analysSendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    BOOL flag = [self analysSendAction:action to:target from:sender forEvent:event];
    if ([sender respondsToSelector:@selector(umInfo)]) {
        [BQAnalysManager analysModel:[sender umInfo]];
    }
    return flag;
}

@end


@implementation UIGestureRecognizer (anayls)

- (instancetype)analysInitWithTarget:(id)target action:(SEL)action {
    UIGestureRecognizer * gesture = [self analysInitWithTarget:target action:action];
    [gesture aopMethodWithTarget:target action:action];
    return gesture;
}

- (void)analysAddTarget:(id)target action:(SEL)action {
    [self analysAddTarget:target action:action];
    [self aopMethodWithTarget:target action:action];
}

- (void)aopMethodWithTarget:(id)target action:(SEL)action {
    SEL replace = @selector(analysGesturAction:);
    Method newM = class_getInstanceMethod([self class], replace);
    // 未添加方法进行添加并执行方法交换操作，
    if (class_addMethod([target class], replace, method_getImplementation(newM), method_getTypeEncoding(newM))) {
        Method orginM = class_getInstanceMethod([target class], action);
        Method replaceM = class_getInstanceMethod([target class], replace);
        method_exchangeImplementations(orginM, replaceM);
    }
}

- (void)analysGesturAction:(UIGestureRecognizer *)sender {
    [self analysGesturAction:sender];
    [BQAnalysManager analysModel:sender.umInfo];
}

@end


@implementation UITableViewCell (anayls)

- (void)anaylsSetSelected:(BOOL)selected animated:(BOOL)animated{
    [self anaylsSetSelected:selected animated:animated];
    UITableView * listV = (UITableView *)self.superview;
    if (selected && [listV.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [BQAnalysManager analysModel:self.umInfo];
    }
}

@end


@implementation UICollectionViewCell (anayls)

- (void)anaylsSetSelected:(BOOL)selected{
    [self anaylsSetSelected:selected];
    UICollectionView * listV = (UICollectionView *)self.superview;
    if (selected && [listV.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
        [BQAnalysManager analysModel:self.umInfo];
    }
}
@end
