// *******************************************
//  File Name:      NSMutableArray+Custom.m       
//  Author:         MrBai
//  Created Date:   2020/1/2 3:48 PM
//    
//  Copyright © 2020 MrBai
//  All rights reserved
// *******************************************
    

#import "NSMutableArray+Custom.h"

#import "NSObject+Custom.h"

@implementation NSMutableArray (Custom)

- (void)randomElement {
    for (int i = 0; i<self.count; i++) {
        int newIndex = (int)arc4random_uniform((int)self.count - i) + i;
        if (newIndex != i) {
            id temp = self[i];
            self[i] = self[newIndex];
            self[newIndex] = temp;
        }
    }
}

@end

@implementation NSArray (Carsh)

+ (void)load {
    Class arrI = NSClassFromString(@"__NSArrayI");
    Class arrM =NSClassFromString(@"__NSArrayM");
    
    [arrI exchangeMethod:@selector(objectAtIndex:) with:@selector(bqI_objectAtIndex:)];
    [arrI exchangeMethod:@selector(objectAtIndexedSubscript:) with:@selector(bqI_objectAtIndexedSubscript:)];
    
    [arrM exchangeMethod:@selector(objectAtIndex:) with:@selector(bqM_objectAtIndex:)];
    [arrM exchangeMethod:@selector(objectAtIndexedSubscript:) with:@selector(bqM_objectAtIndexedSubscript:)];
}

- (id)bqM_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count) {
        return nil;
    } else {
        return [self bqM_objectAtIndexedSubscript:idx];
    }
}

- (id)bqM_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    } else {
        return [self bqM_objectAtIndex:index];
    }
}

- (id)bqI_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count) {
        return nil;
    } else {
        return [self bqI_objectAtIndexedSubscript:idx];
    }
}

- (id)bqI_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    } else {
        return [self bqI_objectAtIndex:index];
    }
}

@end

