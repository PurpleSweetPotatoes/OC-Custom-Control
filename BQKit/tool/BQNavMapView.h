// *******************************************
//  File Name:      BQNavMapView.h       
//  Author:         MrBai
//  Created Date:   2020/3/26 9:27 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

/**
 info文件需要添加白名单
 LSApplicationQueriesSchemes
 <array>
     <string>iosamap</string>  高德
     <string>baidumap</string>  百度
     <string>comgooglemaps</string>  谷歌
     <string>qqmap</string> 腾讯
 </array>
 */

typedef NS_ENUM(NSUInteger, NavMapType) {
    NavMapType_Drive,       ///< 驾车
};

NS_ASSUME_NONNULL_BEGIN

@interface BQNavMapView : UIView
+ (void)showNavMapViewWithType:(NavMapType)type latitude:(NSString *)latitude longitude:(NSString *)longitude;
@end

NS_ASSUME_NONNULL_END
