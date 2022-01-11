// *******************************************
//  File Name:      BQLinearLayout.h       
//  Author:         MrBai
//  Created Date:   2022/1/4 2:42 PM
//    
//  Copyright © 2022 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BQLinearLayoutDelegate <NSObject>
/// 加载元素属性 进行调整
- (void)didLoadLayoutAttributes:(NSArray *)attributes layout:(UICollectionViewLayout *)layout;
@end

@interface BQLinearLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<BQLinearLayoutDelegate>  delegate;
/// 默认为 YES
@property (nonatomic, assign) BOOL  scorllReset; 
@end

NS_ASSUME_NONNULL_END
