//
//  BQAlertSheetView.h
//  TianyaTest
//
//  Created by MrBai on 2018/5/25.
//  Copyright © 2018年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQAlertSheetView : UIView


/**
 底部弹出窗口

 @param titles 标题
 @param callBlock 回调函数
 */
+ (void)showSheetViewWithTitles:(NSArray <NSString *>*)titles callBlock:(void(^)(NSInteger index,NSString * title))callBlock;
@end
