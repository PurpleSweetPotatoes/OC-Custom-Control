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



@end

