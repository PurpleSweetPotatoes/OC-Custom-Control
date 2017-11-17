//
//  NSDate+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NSDateTimeStyle) {
    NSDateTimeStyle_YMD1,//yyyy-MM-dd
    NSDateTimeStyle_YMD2,//yyyy年MM月dd日
    NSDateTimeStyle_HM,//HH:mm
    NSDateTimeStyle_HMS1,//HH:mm:ss
    NSDateTimeStyle_HMS2,//HH时mm分ss秒
    NSDateTimeStyle_YMDHMS,//yyyy-MM-dd HH:mm:ss,
};

@interface NSDate (time)

@property (nonatomic, assign, readonly) NSInteger year;
@property (nonatomic, assign, readonly) NSInteger month;
@property (nonatomic, assign, readonly) NSInteger day;
@property (nonatomic, assign, readonly) NSInteger hour;
@property (nonatomic, assign, readonly) NSInteger min;
@property (nonatomic, assign, readonly) NSInteger second;
@property (nonatomic, strong, readonly) NSString * weekDay;


- (NSString *)getFormatteTimestamp;

- (NSString *)getTimeString:(NSDateTimeStyle)style;

- (NSString *)getTimeStringFormat:(NSString*)formatStr;

/**
 标准通用时间字符串
 1分钟内：刚刚
 1小时内：xx分钟前
 1小时-当天0点：x小时前
 昨天：昨天
 2-5天：星期x
 >5天：x月x日
 @return 时间字符串
 */
- (NSString *)standardFormatTimeString;

@end
