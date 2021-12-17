// *******************************************
//  File Name:      BQLaunchConfig.h       
//  Author:         MrBai
//  Created Date:   2021/12/16 11:03 AM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

/// 启动图配置项
@interface BQLaunchConfig : NSObject
@property (nonatomic, strong) UIViewController       * showVc;      ///< 展示vc
@property (nonatomic, strong) UIView                 * showView;    ///< 展示视图,优先级高于showVc
@property (nonatomic, assign) CGFloat                removeTime;    ///< 移除时间(s), 默认0.5
@property (nonatomic, assign) UIViewAnimationOptions animateType;   ///< 移除动画
@end

