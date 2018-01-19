//
//  NSDate+Custom.m
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import "NSDate+Custom.h"

@implementation NSDate (time)

- (NSString *)getFormatteTimestamp {
    return [NSString stringWithFormat:@"%.lf",self.timeIntervalSince1970];
}

- (NSString *)getTimeString:(NSDateTimeStyle)style {
    NSString * formatStr = [[self class] formaterStrWith:style];
    return [self getTimeStringFormat:formatStr];
}

- (NSString *)getTimeStringFormat:(NSString*)formatStr {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setLocale:usLocale];
    NSString* dateString = [dateFormatter stringFromDate:self];
    return dateString;
}

- (NSInteger)year {
    return [[self getCurrentComponents] year];
}

- (NSInteger)month {
    return [[self getCurrentComponents] month];
}

- (NSInteger)day {
    return [[self getCurrentComponents] day];
}

- (NSInteger)hour {
    return [[self getCurrentComponents] hour];
}

- (NSInteger)min {
    return [[self getCurrentComponents] minute];
}

- (NSInteger)second {
    return [[self getCurrentComponents] second];
}

- (NSString *)weekDay {
    NSInteger week = [[self getCurrentComponents] weekday];
    switch (week) {
        case 1: return @"周日";
        case 2: return @"周一";
        case 3: return @"周二";
        case 4: return @"周三";
        case 5: return @"周四";
        case 6: return @"周五";
        case 7: return @"周六";
        default: return @"未知";
    }
}

- (NSDateComponents *)getCurrentComponents {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents * components = [calendar components:unitFlags fromDate:self];
    return components;
}

- (NSString *)standardFormatTimeString {
    
    NSDate *date = [NSDate date];
    NSTimeInterval targetTimeStamp = [self timeIntervalSince1970];
    NSTimeInterval nowTimeStamp = [date timeIntervalSince1970];
    NSTimeInterval delay = nowTimeStamp - targetTimeStamp;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self toDate:date options:0];
    
    NSUInteger toDaySecond = date.hour * 60 * 60 + date.min * 60 + date.second;
    
    NSString * timeString = @"";
    
    if (delay <= 86400 + toDaySecond && [components day] <= 1) {
        NSUInteger nowDay = date.day;
        NSUInteger targetDay = self.day;
        if (targetDay == nowDay) { // 同一天
            
            if (delay < 60) {
                timeString = @"刚刚";
            } else if (delay >= 60 && delay < 3600) {
                int minutes = delay / 60;
                timeString = [NSString stringWithFormat:@"%d分钟前", minutes];
            } else {
                int hours = delay / 3600;
                timeString = [NSString stringWithFormat:@"%d小时前", hours];
            }
            
        } else {
            timeString = @"昨天";
        }
    } else if (delay < 86400 * 5 + toDaySecond) {
        timeString = self.weekDay;
    } else {
        NSUInteger nowYear = date.year;
        NSUInteger lateYer = self.year;
        if (nowYear == lateYer) {
            timeString = [self getTimeStringFormat:@"MM月dd日"];
        } else {
            timeString = [self getTimeStringFormat:@"yyyy年MM月dd日"];
        }
    }
    
    return timeString;
}

+ (NSString *)formaterStrWith:(NSDateTimeStyle)style {
    NSString * formatStr = nil;
    switch (style) {
        case NSDateTimeStyle_YMD1:
            formatStr = @"yyyy-MM-dd";
            break;
        case NSDateTimeStyle_YMD2:
            formatStr = @"yyyy年MM月dd";
            break;
        case NSDateTimeStyle_HM:
            formatStr = @"HH:mm";
            break;
        case NSDateTimeStyle_HMS1:
            formatStr = @"HH:mm:ss";
            break;
        case NSDateTimeStyle_HMS2:
            formatStr = @"HH时mm分ss秒";
            break;
        case NSDateTimeStyle_YMDHMS:
            formatStr = @"yyyy-MM-dd HH:mm:ss";
            break;
        default:
            formatStr = @"";
            break;
    }
    return formatStr;
}

@end
