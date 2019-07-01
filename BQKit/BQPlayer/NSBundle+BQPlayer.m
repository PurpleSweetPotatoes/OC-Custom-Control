//
//  NSBundle+BQPlayer.m
//  tianyaTest
//
//  Created by baiqiang on 2019/6/27.
//  Copyright © 2019 baiqiang. All rights reserved.
//

#import "NSBundle+BQPlayer.h"

@implementation NSBundle (BQPlayer)

+ (UIImage *)playerBundleWithImgName:(NSString *)imgName {
    NSString * path = [NSString stringWithFormat:@"BQPlayer.bundle/%@",imgName];
    UIImage * img = [UIImage imageNamed:path];
    return img;
}
@end
