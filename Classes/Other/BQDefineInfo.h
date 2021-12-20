// *******************************************
//  File Name:      BQDefineInfo.h       
//  Author:         MrBai
//  Created Date:   2021/12/14 2:35 PM
//    
//  Copyright © 2021 ___ORGANIZATIONNAME___
//  All rights reserved
// *******************************************
    

#ifndef BQDefineInfo_h
#define BQDefineInfo_h


#import <UIKit/UIKit.h>

#pragma mark - *** BlockType

typedef void(^VoidBlock)(void);
typedef void(^StringBlock)(NSString * str);
typedef void(^ImgBlock)(UIImage * img);

#pragma mark - *** DefineInfo

/** ---------------- 安全线程回调  ---------------- */
#define MainQueueSafe(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
/** ---------------- 弱引用和强引用  ---------------- */
#define WeakSelf __weak typeof(self) weakSelf = self
#define StrongSelf __weak typeof(weakSelf) strongSelf = weakSelf

/** ---------------- 屏幕宽高 ---------------  */
#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)

/** ---------------- 输出调试 ---------------  */
#ifdef DEBUG
#define NSLog(format, ...) fprintf(stderr,"%s(%d) %s\n",[[NSString stringWithUTF8String:__FUNCTION__] UTF8String], __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif

#pragma mark - C 函数

static inline NSString* currentTimeStr() {
    static NSDateFormatter * dateForamt;
    if (dateForamt == nil) {
        dateForamt = [[NSDateFormatter alloc] init];
        [dateForamt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString * dateStr = [dateForamt stringFromDate:[NSDate date]];
    return dateStr;
}

#endif /* BQDefineInfo_h */
