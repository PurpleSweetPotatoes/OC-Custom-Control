// *******************************************
//  File Name:      CellModel.h       
//  Author:         MrBai
//  Created Date:   2021/12/16 1:55 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellModel : NSObject

@property (nonatomic, assign) CGFloat cellHeight;

+ (instancetype)modelWithDic:(NSDictionary *)dic;

+ (instancetype)modelWithJson:(id)json;

@end

NS_ASSUME_NONNULL_END
