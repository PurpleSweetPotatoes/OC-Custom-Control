// *******************************************
//  File Name:      NSArray+Custom.h       
//  Author:         MrBai
//  Created Date:   2022/1/4 4:35 PM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Custom)
- (NSArray *)randomElement;
- (CGFloat)maxNum;
- (CGFloat)minNum;
- (CGFloat)sumNum;
- (CGFloat)avgNum;
@end

NS_ASSUME_NONNULL_END
