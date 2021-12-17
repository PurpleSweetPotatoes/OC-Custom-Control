// *******************************************
//  File Name:      VcModel.h       
//  Author:         MrBai
//  Created Date:   2021/12/16 2:02 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "CellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VcModel : CellModel
@property (nonatomic, copy) NSString * clsName;
@property (nonatomic, copy) NSString * titleName;
@property (nonatomic, copy) NSString * descStr;
- (UIViewController *)coverVc;
@end

NS_ASSUME_NONNULL_END
