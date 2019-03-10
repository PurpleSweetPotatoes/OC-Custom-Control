//
//  BQRemoteMsgView.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/2.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQDefineHead.h"

@interface BQRemoteMsgView : UIView
/**
 应用内展示远程推送消息内容
 
 @param title 标题
 @param content 内容
 */
+ (void)showRemoteMsgWithTitle:(NSString *)title
                       content:(NSString *)content
                        handle:(VoidBlock)handle;
@end
