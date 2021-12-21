// *******************************************
//  File Name:      ScanView.h       
//  Author:         MrBai
//  Created Date:   2021/12/21 4:30 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanView : UIView

@property (nonatomic, assign) CGRect  scanFrame;

- (instancetype)initWithFrame:(CGRect)frame
                    scanFrame:(CGRect)scanFrame;

@end

NS_ASSUME_NONNULL_END
