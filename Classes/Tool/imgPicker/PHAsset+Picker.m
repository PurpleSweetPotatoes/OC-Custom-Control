//
//  PHAsset+Picker.m
//  DrawingBoard
//
//  Created by baiqiang on 2019/3/22.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "PHAsset+Picker.h"

#import <objc/runtime.h>

@implementation PHAsset (Picker)

- (void)setSelected:(BOOL)selected {
    NSNumber * num = selected ? @(1):@(0);
    objc_setAssociatedObject(self, @selector(selected), num, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)selected {
    NSNumber * num = objc_getAssociatedObject(self, @selector(selected));
    return [num boolValue];
}

- (UIImage *)image {
   return objc_getAssociatedObject(self, @selector(image));
}

- (void)setImage:(UIImage *)image {
    objc_setAssociatedObject(self, @selector(image), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData *)data {
    return objc_getAssociatedObject(self, @selector(data));
}

- (void)setData:(NSData *)data {
    objc_setAssociatedObject(self, @selector(data), data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
