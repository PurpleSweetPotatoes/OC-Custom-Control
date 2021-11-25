// *******************************************
//  File Name:      BQNavMapView.m       
//  Author:         MrBai
//  Created Date:   2020/3/26 9:27 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQNavMapView.h"

#import <MapKit/MapKit.h>

@interface BQNavMapView ()
@property (nonatomic, assign) NavMapType     type;
@property (nonatomic, assign) NSString       * latitude;
@property (nonatomic, assign) NSString       * longitude;
@property (nonatomic, strong) NSMutableArray * openUrls;
@end

@implementation BQNavMapView

#pragma mark - *** Public method
+ (void)showNavMapViewWithType:(NavMapType)type latitude:(NSString *)latitude longitude:(NSString *)longitude {
    BQNavMapView * view = [[BQNavMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.type = type;
    view.latitude = latitude;
    view.longitude = longitude;
    [view configUI];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}
#pragma mark - *** Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return self;
}

#pragma mark - *** NetWork method

#pragma mark - *** Event Action

- (void)mapBtnAction:(UIButton *)sender {
    if (sender.tag < self.openUrls.count) { // 三方地图
        NSURL * url = [NSURL URLWithString:self.openUrls[sender.tag]];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    } else if (sender.tag == self.openUrls.count) { //苹果地图
        float lat = [self.latitude floatValue];
        float lon = [self.longitude floatValue];
        //终点坐标
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
        
        //用户位置
        MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
        //终点位置
        MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil] ];
        
        NSArray *items = @[currentLoc,toLocation];
        //第一个
        NSDictionary *dic = @{
                              MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                              MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                              MKLaunchOptionsShowsTrafficKey : @(YES)
                              };
        [MKMapItem openMapsWithItems:items launchOptions:dic];
    }
    [self removeFromSuperview];
}
#pragma mark - *** Delegate

#pragma mark - *** Instance method

- (NSString *)urlCode:(NSString *)url {
    NSMutableCharacterSet * set = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [set addCharactersInString:@"#"];
    return [url stringByAddingPercentEncodingWithAllowedCharacters:set];
}

#pragma mark - *** UI method

- (void)configUI {
    NSMutableArray * arr = [NSMutableArray array];
    self.openUrls = [NSMutableArray array];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [arr addObject:@"高德地图"];
        NSString * urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%@&lon=%@&dev=0&style=2",@"导航功能",@"",self.latitude,self.longitude];
        [self.openUrls addObject:[self urlCode:urlString]];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        [arr addObject:@"谷歌地图"];
        NSString * urlString = [NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%@,%@&directionsmode=driving",@"导航功能",@"",self.latitude, self.longitude];
        [self.openUrls addObject:[self urlCode:urlString]];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [arr addObject:@"百度地图"];
        NSString * urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%@,%@|name:终点&mode=driving&coord_type=gcj02",self.latitude,self.longitude];
        [self.openUrls addObject:[self urlCode:urlString]];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        [arr addObject:@"腾讯地图"];
        NSString * urlString = [NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%@,%@&to=终点&coord_type=1&policy=0",self.latitude,self.longitude];
        [self.openUrls addObject:[self urlCode:urlString]];
    }
    
    [arr addObject:@"原生地图"];
    
    [arr addObject:@"取消"];
    
    CGFloat height = 44 * arr.count + 10 + ([UIApplication sharedApplication].statusBarFrame.size.height == 44 ? 20 : 0);
    UIView * bottomV = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - height, self.bounds.size.width, height)];
    bottomV.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomV];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i * 44 + ((i == arr.count - 1) ? 8: 0), bottomV.bounds.size.width, 44);
        btn.tag = i;
        [btn addTarget:self action:@selector(mapBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bottomV addSubview:btn];
        
        if (i == arr.count - 1) {
            CALayer * layer = [CALayer layer];
            layer.frame = CGRectMake(0, i * 44, btn.bounds.size.width, 8);
            layer.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1].CGColor;
            [bottomV.layer addSublayer:layer];
        } else {
            CALayer * layer = [CALayer layer];
            layer.frame = CGRectMake(0, btn.bounds.size.height - 1, btn.bounds.size.width, 1);
            layer.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1].CGColor;
            [btn.layer addSublayer:layer];
        }
    }
    
}

#pragma mark - *** Set

#pragma mark - *** Get
    

@end
