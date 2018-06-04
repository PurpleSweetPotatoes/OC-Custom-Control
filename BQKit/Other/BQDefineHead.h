//
//  BQDefineHead.h
//  Test
//
//  Created by baiqiang on 16/9/29.
//  Copyright © 2016年 白强. All rights reserved.
//


/*!
 *  将前一个参数转为__weak类型的指针，第二个参数就是__weak型的
 */
#define TYWeakify(tgt,src) (__weak __typeof(src) tgt = src)
#define __WeakSelf (__weak typeof(self) weakSelf = self)

/** ---------------- 屏幕宽高 ---------------  */
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

/** ---------------- 颜色设置 ---------------  */
#define RandomColor ([UIColor randomColor])
#define RGBHexString(hexString) ([UIColor colorFromHexString:hexString])
#define RGBHex(hex) ([UIColor colorFromHex:hex])
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:((r)/255.0f) green:((g)/255.0f) blue:((b)/255.0f) alpha:(a)]
#define RGBColor(r, g, b) RGBAColor((r), (g), (b), 1.0f)

/** ---------------- APP版本号 ---------------  */
#define AppServion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

/** ---------------- 手机型号 ---------------  */
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define kNavHeight (iPhoneX ? 68 : 44)
#define kNavBottom (kNavHeight + 20)
#define kTabHeight (iPhoneX ? 83.f : 49.f)



/** ---------------- 输出调试 ---------------  */
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"文件名:%s 行数:%d 输出:%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif
