//
//  DatePickView.h
//  tianyaTest
//
//  Created by baiqiang on 2019/5/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BQDatePickerViewMode) {
    BQDatePickerViewModeYear = 0,              //年
    BQDatePickerViewModeYearAndMonth,          //年月
    BQDatePickerViewModeDate,                  //年月日
    BQDatePickerViewModeDateHour,              //年月日时
    BQDatePickerViewModeDateHourMinute,        //年月日时分
    BQDatePickerViewModeDateHourMinuteSecond,  //年月日时分秒
    BQDatePickerViewModeTime,                  //时分
    BQDatePickerViewModeTimeAndSecond,         //时分秒
    BQDatePickerViewModeMinuteAndSecond,       //分秒
};

@protocol BQDatePickerViewDelegate <NSObject>
@optional
/** 确定按钮 */
- (void)didClickFinishDateTimePickerView:(NSDateComponents *)comp;

@end


/// 自定义时间选择器
@interface BQDatePickerView : UIView

@property(nonatomic, strong)id<BQDatePickerViewDelegate>delegate;

///  时间格式，默认年月日
@property (nonatomic, readonly, assign)BQDatePickerViewMode pickerViewMode;

/// 中心标题
@property(nonatomic, copy)NSString * centerTitle;

/// 当前时间
@property(nonatomic, strong)NSDate * currentDate;

+ (instancetype)configDateView:(BQDatePickerViewMode)dateMode;

- (void)showDateTimePickerView;

- (void)hideDateTimePickerView;


@end

NS_ASSUME_NONNULL_END
