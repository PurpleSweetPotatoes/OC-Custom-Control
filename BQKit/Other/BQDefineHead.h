//
//  BQDefineHead.h
//  Test
//
//  Created by baiqiang on 16/9/29.
//  Copyright © 2016年 白强. All rights reserved.
//
typedef void(^VoidBlock)(void);

/*  弱引用和强引用 */
#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __weak typeof(weakSelf) strongSelf = weakSelf;

/** ---------------- 屏幕宽高 ---------------  */
#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)


/** ---------------- 手机型号 ---------------  */

#define IS_PAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) && !IS_PAD : NO)

#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !IS_PAD : NO)

#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) &&!IS_PAD : NO)

#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !IS_PAD : NO)

#define IS_IPHONE_11 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !IS_PAD : NO)
#define IS_IPHONE_11Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IS_PAD : NO)
#define IS_IPHONE_11ProMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !IS_PAD : NO)

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
