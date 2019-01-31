//
//  UIApplication+Custom.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/18.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "UIApplication+Custom.h"


@implementation UIApplication (Custom)

+ (void)load {
    [self exchangeMethod:@selector(sendEvent:) with:@selector(bq_sendEvent:)];
}

- (void)bq_sendEvent:(UIEvent *)event {
//    NSLog(@"事件发送:%@",event);
    [self bq_sendEvent:event];
}


@end
