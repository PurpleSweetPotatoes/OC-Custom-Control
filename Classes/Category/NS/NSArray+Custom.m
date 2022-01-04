// *******************************************
//  File Name:      NSArray+Custom.m       
//  Author:         MrBai
//  Created Date:   2022/1/4 4:35 PM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "NSArray+Custom.h"

@implementation NSArray (Custom)

- (NSArray *)randomElement {
    NSMutableArray * arr = [NSMutableArray arrayWithArray:self];
    for (int i = 0; i<arr.count; i++) {
        int newIndex = (int)arc4random_uniform((int)arr.count - i) + i;
        if (newIndex != i) {
            id temp = arr[i];
            arr[i] = arr[newIndex];
            arr[newIndex] = temp;
        }
    }
    return [arr copy];
}

- (CGFloat)maxNum {
    __block CGFloat max = CGFLOAT_MIN;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj floatValue] > max) {
            max = [obj floatValue];
        }
    }];
    return max;
}

- (CGFloat)minNum {
    __block CGFloat min = CGFLOAT_MAX;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj floatValue] < min) {
            min = [obj floatValue];
        }
    }];
    return min;
}

- (CGFloat)sumNum {
    __block CGFloat sum = 0;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        sum += [obj floatValue];
    }];
    return sum;
}

- (CGFloat)avgNum {
    return [self sumNum] / self.count;
}

@end
