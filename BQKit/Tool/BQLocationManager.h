//
//  BQLocationManager.h
//  Test
//
//  Created by MAC on 16/10/18.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreLocation/CLPlacemark.h>

/**
 *  info.plist添加字段
    iOS8:NSLocationWhenInUseUsageDescription使用期间访问位置
         NSLocationAlwaysUsageDescription始终访问位置
    iOS10:NSLocationUsageDescription访问位置
          NSLocationWhenInUseUsageDescription使用期间访问位置
          NSLocationAlwaysUsageDescription始终访问位置
 */

@interface LocationInfo: NSObject

@property (nonatomic, copy) NSString * address;       ///<地址
@property (nonatomic, copy) NSString * city;          ///<城市
@property (nonatomic, copy) CLLocation * location;    ///<经纬度坐标
@property (nonatomic, copy) CLPlacemark * place;         ///<详细地址

@end


@interface BQLocationManager : NSObject

/**
 *  启动定位,获取用户地理位置信息
 *
 *  @param callBack 定位后回调方法
 */
+ (void)startLoadLocationCallBack:(void(^)(LocationInfo * locationInfo, NSError * error))callBack;

@end
