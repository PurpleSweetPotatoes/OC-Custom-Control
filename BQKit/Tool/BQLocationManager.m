//
//  BQLocationManager.m
//  Test
//
//  Created by MAC on 16/10/18.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BQDefineHead.h"
#import "BQLocationManager.h"
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLLocationManager.h>

@interface BQLocationManager()
<
CLLocationManagerDelegate
>
@property (nonatomic, strong                ) CLLocationManager * clManager;
@property (nonatomic, strong                ) CLGeocoder        * clGeocoder;
@property (nonatomic, assign                ) BOOL              loadSuccess;
@property (nonatomic, copy) void (^callBlock) (LocationInfo * info, NSError * error            );
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

+ (instancetype)shareManager {
    return [[BQLocationManager alloc] init];
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

+ (void)loadLocationWithlocation:(CLLocation *)location
                        callBack:(void(^)(LocationInfo * locationInfo, NSError * error))callBack {
    BQLocationManager * manager = [[BQLocationManager alloc] init];
    manager.callBlock = callBack;
    [manager reverseLocationWithLocation:location];
}

+ (void)loadLocationWithAddress:(NSString *)address
                       callBack:(void(^)(LocationInfo * locationInfo, NSError * error))callBack {
    BQLocationManager * manager = [[BQLocationManager alloc] init];
    manager.callBlock = callBack;
    [manager geocodeAddressString:address];
}

#pragma mark - instancetype Method
- (void)reverseLocationWithLocation:(CLLocation *) location {
    WeakSelf;
    [self.clGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            weakSelf.callBlock(nil, error);
        } else {
            [weakSelf prcoessPlacemMarks:placemarks];
        }
    }];
}

- (void)geocodeAddressString:(NSString *)address {
    WeakSelf;
    [self.clGeocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            weakSelf.callBlock(nil, error);
        } else {
            [weakSelf prcoessPlacemMarks:placemarks];
        }
    }];
}

- (void)prcoessPlacemMarks:(NSArray<CLPlacemark *> *) placemarks {
    LocationInfo * info = [[LocationInfo alloc] init];
    info.location = [placemarks firstObject].location;
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
