//
//  BQSearchView.h
//  tianyaTest
//
//  Created by baiqiang on 2019/2/24.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BQSearchView : UITextField

@property (nonatomic, strong) UIColor * placeHolderColor;

- (void)configLeftImg:(NSString *)imgName;
- (void)configRightImg:(NSString *)imgName;

// use this method textFeild will con't edit
- (void)addTapAction:(void(^)(BQSearchView * searchView))handler;
- (void)removeTapAction;

@end

NS_ASSUME_NONNULL_END
