// *******************************************
//  File Name:      BaseCell.h       
//  Author:         MrBai
//  Created Date:   2021/12/17 11:50 AM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "UIColor+Custom.h"
#import "UILabel+Custom.h"
#import "UIView+Custom.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface BaseCell : UITableViewCell

- (void)configUI;

- (void)configInfo:(id)model;

@end

NS_ASSUME_NONNULL_END
