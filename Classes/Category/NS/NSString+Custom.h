//
//  NSString+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Custom)

- (id)jsonToObjc;

#pragma mark - Base64Code
/**  base64编码 */
- (NSString *)base64String;

/**  data to base64编码字符串 */
+ (NSString *)base64StringFromData:(NSData *)data;

/**  base64Url编码 */
- (NSString *)base64UrlEncodedString;

/**  base64解码 */
- (NSString *)decodeBase64String;

/**  base64Url解码 */
- (NSString *)decodeBase64UrlEncodedString;

#pragma mark - MD5
/**  @return 32个字符的MD5散列字符串 */
- (NSString *)md5String;

#pragma mark - AES加密解密

// iv为偏移量，只有CBC模式加密才有便宜，传入iv值默认为CBC模式

/**  @return AES128加密字符串 */
- (NSString *)aes128EncryptWithKey:(NSString *)key iv:(NSString *)iv;

/**  @return AES256加密字符串 */
- (NSString *)aes256EncryptWithKey:(NSString *)key iv:(NSString *)iv;

/**  @return AES128解密数据 */
- (NSString *)aes128DencryptWithKey:(NSString *)key iv:(NSString *)iv;

/**  @return AES256解密数据 */
- (NSString *)aes256DencryptWithKey:(NSString *)key iv:(NSString *)iv;

#pragma mark - 散列函数
/**  @return 32个字符的SHA1散列字符串 */
- (NSString *)sha1String;

/**  @return 64个字符的SHA256散列字符串 */
- (NSString *)sha256String;

/**  @return 128个字符的SHA512散列字符串 */
- (NSString *)sha512String;

#pragma mark - HMAC 散列函数
/**  @return 32个字符的HMAC SHA256散列字符串 */
- (NSString *)hmacMD5StringWithKey:(NSString *)key;

/**  @return 40个字符的HMAC SHA256散列字符串 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**  @return 64个字符的HMAC SHA256散列字符串 */
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**  @return 128个字符的HMAC SHA256散列字符串 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

#pragma mark - 文件散列函数
/**  @return 32个字符的MD5散列字符串 */
- (NSString *)fileMD5Hash;

/**  @return 40个字符的SHA1散列字符串 */
- (NSString *)fileSHA1Hash;

/**  @return 64个字符的SHA256散列字符串 */
- (NSString *)fileSHA256Hash;

/**  @return 128个字符的SHA512散列字符串 */
- (NSString *)fileSHA512Hash;

#pragma mark - NSStrings containing HTML

/// Get a string where internal characters that need escaping for HTML are escaped
//
///  For example, '&' become '&amp;'. This will only cover characters from table
///  A.2.2 of http://www.w3.org/TR/xhtml1/dtds.html#a_dtd_Special_characters
///  which is what you want for a unicode encoded webpage. If you have a ascii
///  or non-encoded webpage, please use stringByEscapingAsciiHTML which will
///  encode all characters.
///
/// For obvious reasons this call is only safe once.
//
//  Returns:
//    Autoreleased NSString
//
- (NSString *)gtm_stringByEscapingForHTML;

/// Get a string where internal characters that need escaping for HTML are escaped
//
///  For example, '&' become '&amp;'
///  All non-mapped characters (unicode that don't have a &keyword; mapping)
///  will be converted to the appropriate &#xxx; value. If your webpage is
///  unicode encoded (UTF16 or UTF8) use stringByEscapingHTML instead as it is
///  faster, and produces less bloated and more readable HTML (as long as you
///  are using a unicode compliant HTML reader).
///
/// For obvious reasons this call is only safe once.
//
//  Returns:
//    Autoreleased NSString
//
- (NSString *)gtm_stringByEscapingForAsciiHTML;

/// Get a string where internal characters that are escaped for HTML are unescaped
//
///  For example, '&amp;' becomes '&'
///  Handles &#32; and &#x32; cases as well
///
//  Returns:
//    Autoreleased NSString
//
- (NSString *)gtm_stringByUnescapingFromHTML;

/// 过滤html标签
- (NSString *)filterHtml;

#pragma mark - 正则验证

/**  是否为QQ账号 */
- (BOOL)isQQ;

/**  是否为电话号码 */
- (BOOL)isPhoneNumber;

/**  是否为IP地址 */
- (BOOL)isIPAddress;

/**  是否为邮箱 */
- (BOOL)isMailbox;

/**  是否为身份证 */
- (BOOL)isCardId;

/**  是否符合密码(无空格和中文字符) */
- (BOOL)isPassWord;

/**  是否含有中文 */
- (BOOL)hasChineseCode;

/**  是否含有unicode编码 */
- (BOOL)hasUnicode;

/** string字面转化为Data */
- (NSMutableData*)convertBytesToData;


/// 删除对应字符串
/// @param regular 正则规则
- (NSString *)deleteCharset:(NSString *)regular;

#pragma mark - url编码解码

/** url编码*/
- (NSString *)urlEncoded;

/** url解码*/
- (NSString *)urlDecoded;

/** url参数(get)*/
- (NSDictionary *)urlGetParams;

/** 字符串转字典*/
- (NSDictionary *)jsonDic;

/** 字符串反转*/
- (NSString *)reverse;
@end

