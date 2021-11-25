// *******************************************
//  File Name:      AppDelegate+Notification.m       
//  Author:         MrBai
//  Created Date:   2020/7/15 10:54 AM
//    
//  Copyright © 2020 baiqiang
//  All rights reserved
// *******************************************
    

#import "AppDelegate+Notification.h"

#ifdef __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate()
<
UNUserNotificationCenterDelegate
>

@end

@implementation AppDelegate (Notification)

- (void)registerRemoteNotifiCation:(UIApplication *)application {
  
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"PushNotification====注册成功");
            }else{
                //用户点击不允许
                NSLog(@"PushNotification====注册失败");
            }
        }];
    } else {
        // Fallback on earlier versions
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }

    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
}

#pragma mark - token获取与处理

//token获取失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//token获取成功
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSData  *apnsToken = [NSData dataWithData:deviceToken];
    NSString *tokenString = [self getHexStringForData:apnsToken];
    NSLog(@"My token = %@", tokenString);
    
}

- (NSString *)getHexStringForData:(NSData *)data {
    NSUInteger length = [data length];
    char *chars = (char *)[data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < length; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}

#pragma mark - 推送相关处理

// iOS7之后收到推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"push notification did receive remote notification:%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS10之后收到推送
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"push notification did receive remote notification:%@",notification.request.content.userInfo);
    completionHandler(UNNotificationPresentationOptionAlert);
}

// iOS10及以后的用户点击通知的操作
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    NSLog(@"push notification did receive remote notification:%@",response.notification.request.content.userInfo);
    completionHandler();
}

// iOS8及以后的用户点击通知的操作
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)(void))completionHandler {
    
    completionHandler();
}

@end
