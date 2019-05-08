//
//  BQAlertVc.h
//  tianyaTest
//
//  Created by baiqiang on 2019/5/7.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VoidAlertBlock)(void);

typedef NS_ENUM(NSUInteger, AlertBtnType) {
    AlertBtnTypeNormal,
    AlertBtnTypeDestroy,
};

@interface BQAlertVc : UIViewController

+ (instancetype)configAlertVcWithTile:(NSString *)title content:(NSString *)content;

- (void)addCustomView:(UIView *)customView;

- (void)addBtnWithTitle:(NSString *)title type:(AlertBtnType)type handle:(_Nullable VoidAlertBlock)handle;

- (void)showVc;
@end

NS_ASSUME_NONNULL_END
