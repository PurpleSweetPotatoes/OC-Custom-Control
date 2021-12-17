//
//  DatePickView.h
//  tianyaTest
//
//  Created by baiqiang on 2019/5/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, BQDatePickerModel) {
    BQDatePickerModelYear   = 1 << 0,
    BQDatePickerModelMonth  = 1 << 1,
    BQDatePickerModelDay    = 1 << 2,
    BQDatePickerModelHour   = 1 << 3,
    BQDatePickerModelMinute = 1 << 4,
    BQDatePickerModelSecond = 1 << 5,
};

@protocol BQDatePickerViewDelegate <NSObject>
@optional
/** 确定按钮 */
- (void)didClickFinishDateTimePickerView:(NSDate *)date formatStr:(NSString *)formatStr;

@end


/// 自定义时间选择器
@interface BQDatePickerView : UIView

@property(nonatomic, strong)id<BQDatePickerViewDelegate>delegate;

/// 时间展示格式，默认年月日时分秒
@property (nonatomic, assign)BQDatePickerModel model;

/// 时间选择后格式化样式, 默认yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString * formatStr;

/// 中心标题
@property(nonatomic, copy)NSString * centerTitle;

/// 当前时间
@property(nonatomic, strong)NSDate * currentDate;

+ (instancetype)pickView;

- (void)showDateTimePickerView;

- (void)hideDateTimePickerView;

@end

NS_ASSUME_NONNULL_END
