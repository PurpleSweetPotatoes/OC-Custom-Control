//
//  BQLocationManager.m
//  Test
//
//  Created by MAC on 16/10/18.
//  Copyright © 2016年 MAC. All rights reserved.
//
#import "BQLocationManager.h"

#import "BQDefineInfo.h"
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface BQLocationManager()
<
CLLocationManagerDelegate
>
@property (nonatomic, strong                ) CLLocationManager * clManager;
@property (nonatomic, strong                ) CLGeocoder        * clGeocoder;
@property (nonatomic, assign                ) BOOL              onceLoad;
@property (nonatomic, copy) void (^callBlock) (LocationInfo * info, NSError * error            );
@end

@implementation BQLocationManager

#pragma mark - Class Method

+ (instancetype)shareManager {
    static BQLocationManager * location;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        location = [[BQLocationManager alloc] init];
    });
    return location;
}

+ (void)startLoadLocationCallBack:(void (^)(LocationInfo *, NSError *))callBack {
    BQLocationManager * manager = [BQLocationManager shareManager];
    manager.onceLoad = YES;
    [self startLoadLocation:manager block:callBack];
}

+ (void)startLoadNavLocation:(void (^)(LocationInfo *, NSError *))navBlock {
    BQLocationManager * manager = [BQLocationManager shareManager];
    manager.onceLoad = NO;
    [self startLoadLocation:manager block:navBlock];
}

+ (void)stopNavLocation {
    BQLocationManager * manager = [BQLocationManager shareManager];
    [manager.clManager stopUpdatingLocation];
}

+ (void)startLoadLocation:(BQLocationManager *)manager block:(void (^)(LocationInfo *, NSError *))block {
    //如果定位状态为未打开
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //requestWhenInUseAuthorization  前端定位
        //requestAlwaysAuthorization 前端和后台定位
        [manager.clManager requestWhenInUseAuthorization];
    }
    [manager.clManager startUpdatingLocation];
    manager.callBlock = block;
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
    NSLog(@"定位数量:%zd", locations.count);
    CLLocation * location = [locations lastObject];
    if (!CLLocationCoordinate2DIsValid(location.coordinate)) {
        NSLog(@"定位无效");
        return;
    }
    if (self.onceLoad) {
        self.onceLoad = YES;
        [self reverseLocationWithLocation:location];
        [self.clManager stopUpdatingLocation];
    } else {
        LocationInfo * info = [[LocationInfo alloc] init];
        info.location = location;
        self.callBlock(info, nil);
    }
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
        _clManager.desiredAccuracy = kCLLocationAccuracyBest;
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
