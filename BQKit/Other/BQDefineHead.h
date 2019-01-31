//
//  BQDefineHead.h
//  Test
//
//  Created by baiqiang on 16/9/29.
//  Copyright © 2016年 白强. All rights reserved.
//


/*  弱引用和强引用 */
#define WeakSelf __weak typeof(self) weakSelf = self
#define StrongSelf __weak typeof(weakSelf) strongSelf = weakSelf

/** ---------------- 屏幕宽高 ---------------  */
#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)

/** ---------------- 颜色设置 ---------------  */
#define RandomColor ([UIColor randomColor])
#define RGBHexString(hexString) ([UIColor colorFromHexString:hexString])
#define RGBHex(hex) ([UIColor colorFromHex:hex])
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:((r)/255.0f) green:((g)/255.0f) blue:((b)/255.0f) alpha:(a)]
#define RGBColor(r, g, b) RGBAColor((r), (g), (b), 1.0f)

/** ---------------- APP版本号 ---------------  */
#define AppServion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

/** ---------------- 手机型号 ---------------  */

#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) &&!isPad : NO)

#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define ISIPHONEX_OVER (IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES)

#define KStatuHeight (ISIPHONEX_OVER ? 44.0 : 20.0)
#define KNavBottom (ISIPHONEX_OVER ? 88.0 : 64.0)
#define KTabHeight (ISIPHONEX_OVER ? 83.0 : 49.0)

/** ---------------- 输出调试 ---------------  */
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif
