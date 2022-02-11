// *******************************************
//  File Name:      BQUserDefault.h       
//  Author:         MrBai
//  Created Date:   2022/2/11 10:11 AM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 本地UserDefault封装，属性为key，建议使用NSString，清除key只需将属性置为nil即可
@interface BQUserDefault : NSObject

@property (nonatomic, class, readonly, nonnull) BQUserDefault * share;

@end

NS_ASSUME_NONNULL_END
