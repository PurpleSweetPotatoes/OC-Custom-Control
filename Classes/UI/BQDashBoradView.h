// *******************************************
//  File Name:      BQDashBoradView.h       
//  Author:         MrBai
//  Created Date:   2022/1/10 3:19 PM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 使用initwithFrame初始化
 环形宽度 默认值10
 刻度数量 默认10
 刻度区域数量 默认2
 最大数值 默认100
*/
@interface BQDashBoradView : UIView


/// 创建仪表盘
/// @param frame frame
/// @param ringWidth 线宽
/// @param areaNum 刻度数量
/// @param areaDailNum 刻度区域数量
/// @param maxNum 最大值
- (instancetype)initWithFrame:(CGRect)frame
                    ringWidth:(CGFloat)ringWidth
                      areaNum:(NSInteger)areaNum
                  areaDailNum:(NSInteger)areaDailNum
                       maxNum:(CGFloat)maxNum;

/// 设置刻度区域文字
/// @param list 刻度文字数组
- (void)setDailTextList:(NSArray<NSString *> *)list;

/// 重置速度
/// @param speed 速度
- (void)reSetSpeed:(CGFloat )speed;

@end

NS_ASSUME_NONNULL_END
