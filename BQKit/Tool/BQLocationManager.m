//
//  BQLocationManager.m
//  Test
//
//  Created by MAC on 16/10/18.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BQLocationManager.h"
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLGeocoder.h>

@interface BQLocationManager() <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * clManager;
@property (nonatomic, strong) CLGeocoder * clGeocoder;
@property (nonatomic, assign) BOOL loadSuccess;
@property (nonatomic, copy) void (^callBlock)(LocationInfo * info, NSError * error);
@end

@implementation BQLocationManager

#pragma mark - Class Method

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static BQLocationManager * location;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [super allocWithZone:zone];
    });
    return location;
}

+ (void)startLoadLocationCallBack:(void (^)(LocationInfo *, NSError *))callBack {
    
    BQLocationManager * manager = [[BQLocationManager alloc] init];
    manager.loadSuccess = NO;
    
    //判断系统IOS版本
    if (@available(iOS 8.0, *)) {
        [manager.clManager requestWhenInUseAuthorization];
    }
    
    [manager.clManager startUpdatingLocation];
    manager.callBlock = callBack;
}

#pragma mark - instancetype Method
- (void)reverseLocationWithLocation:(CLLocation *) location {
    
    [self.clGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        LocationInfo * info = [[LocationInfo alloc] init];
        info.location = location;
        
        for (CLPlacemark *place in placemarks) {
            //通过CLPlacemark可以输出用户位置信息
            if (place.name != nil) {
                info.address = place.name;
            }
            
            if (place.locality != nil) {
                info.city = place.locality;
            }
            
            if (place != nil) {
                info.place = place;
            }
        }
        
        if (self.callBlock != nil) {
            self.callBlock(info, nil);
        }
    }];
}

#pragma mark - Delegate Method
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *newLocation = [locations lastObject];
    
    if (self.loadSuccess == NO) {
        self.loadSuccess = YES;
        [self reverseLocationWithLocation:newLocation];
    }
    
    [self.clManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (self.callBlock != nil) {
        self.callBlock(nil,error);
    }
    
}

#pragma mark - get Method

- (CLLocationManager *)clManager {
    if (_clManager == nil) {
        _clManager = [[CLLocationManager alloc] init];
        _clManager.delegate = self;
    }
    return _clManager;
}

- (CLGeocoder *)clGeocoder {
    if (_clGeocoder == nil) {
        _clGeocoder = [[CLGeocoder alloc] init];
    }
    return _clGeocoder;
}
@end

#pragma mark - LocationInfo

@implementation LocationInfo

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p> {\naddress : %@\ncity : %@\nlocation : %@\nplace : %@\n}",NSStringFromClass(self.class) , self, self.address, self.city, self.location, self.place];
}

@end
