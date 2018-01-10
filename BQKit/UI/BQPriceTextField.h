//
//  BQPriceTextField.h
//  Test-demo
//
//  Created by baiqiang on 2018/1/10.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 价格输入框 */
@interface BQPriceTextField : UITextField

/**  精度(小数点后位数)，默认为2 */
@property (nonatomic, assign) NSInteger precision;

@end
