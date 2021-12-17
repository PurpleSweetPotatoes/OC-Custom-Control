//
//  BQCirLabel.h
//  tianyaTest
//
//  Created by baiqiang on 2019/4/28.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// 自定义圆环文本
@interface BQCirLabel : UILabel
@property (nonatomic, strong) UIColor * cirBgColor;                 ///< 圆环背景色
@property (nonatomic, strong) UIColor * cirShowColor;               ///< 圆环进度颜色
@property (nonatomic, assign) CGFloat  cirWidth;                    ///< 圆环宽度
@property (nonatomic, assign) CGFloat  cirpercentNum;               ///< 进度, 0 ~ 1
@end

NS_ASSUME_NONNULL_END
