// *******************************************
//  File Name:      BQKeyBoardManager.m
//  Author:         MrBai
//  Created Date:   2020/5/13 12:28 PM
//
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQKeyBoardManager.h"

@interface BQKeyBoardManager ()
@property (nonatomic, strong) UIView * responseV;
@property (nonatomic, strong) NSMutableArray * editVList;
@property (nonatomic, assign) BOOL  didAdd;
@end

@implementation BQKeyBoardManager

+ (instancetype)share {
    static dispatch_once_t onceToken;
    static BQKeyBoardManager * manager;
    dispatch_once(&onceToken, ^{
        manager = [[BQKeyBoardManager alloc] init];
        manager.editVList = [NSMutableArray array];
    });
    return manager;
}

+ (void)startResponseView:(UIView *)reView {
    BQKeyBoardManager * manager =  [self share];
    manager.responseV = reView;
}

+ (void)closeResponse {
    BQKeyBoardManager * manager =  [self share];
    manager.responseV = nil;
}

- (void)checkCanResponseCtlr:(UIView *)view {
    for (UIView * subV in view.subviews) {
        if ([subV isKindOfClass:[UITextField class]] || [subV isKindOfClass:[UITextView class]]) {
            [self.editVList addObject:subV];
        } else if (subV.subviews) {
            [self checkCanResponseCtlr:subV];
        }
    }
}

- (void)addNotifiCation {
    [self.editVList removeAllObjects];
    [self checkCanResponseCtlr:self.responseV];
    
    if (!self.didAdd) {
        self.didAdd = YES;
        //增加监听，当键盘弹出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardManger:) name:UIKeyboardWillShowNotification object:nil];
        //增加监听，当键盘修改时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardManger:) name:UIKeyboardWillChangeFrameNotification object:nil];
        //增加监听，当键盘退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)removeNotifiCation {
    if (self.didAdd) {
        self.didAdd = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)keyboardManger:(NSNotification *)notifi {
    for (UIView * editV in self.editVList) {
        if (editV.isFirstResponder) {
            //获取键盘的y值
            NSDictionary *userInfo = [notifi userInfo];
            NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
            CGRect keyboardRect = [aValue CGRectValue];
            NSInteger height = keyboardRect.size.height;
            CGFloat keyBoardY = [UIScreen mainScreen].bounds.size.height - height;
            //响应视图的最低点
            CGRect rect = [editV.superview convertRect:editV.frame toView:[UIApplication sharedApplication].keyWindow];
            CGFloat vMaxY = CGRectGetMaxY(rect);
            //键盘挡住了响应式图
            if (keyBoardY < vMaxY) {
                self.responseV.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0,keyBoardY - vMaxY);
            }
        }
    }
}

- (void)keyboardHide:(NSNotification *)notifi {
    self.responseV.transform = CGAffineTransformIdentity;
}

- (void)setResponseV:(UIView *)responseV {
    _responseV = responseV;
    if (responseV) {
        [self addNotifiCation];
    } else {
        [self removeNotifiCation];
    }
}

@end

