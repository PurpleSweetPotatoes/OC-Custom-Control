// *******************************************
//  File Name:      BQScrollLabel.h
//  Author:         MrBai
//  Created Date:   2020/11/18 10:15 AM
//    
//  Copyright © 2020 Rainy
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollDirection_up,
    ScrollDirection_left,
};

@interface BQScrollLabel : UIView

+ (BQScrollLabel *)configInfos:(NSArray *)infos direction:(ScrollDirection)direction frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
