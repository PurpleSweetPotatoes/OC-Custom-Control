// *******************************************
//  File Name:      CellModel.m       
//  Author:         MrBai
//  Created Date:   2021/12/16 1:55 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import "CellModel.h"
#import <YYModel.h>
@interface CellModel ()

@end

@implementation CellModel

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    return [self yy_modelWithDictionary:dic];
}

+ (instancetype)modelWithJson:(id)json {
    return [self yy_modelWithJSON:json];
}

- (CGFloat)cellHeight {
    return 44;
}

@end
