//
//  NSString+Custom.h
//  TianyaTest
//
//  Created by MrBai on 2017/11/17.
//  Copyright © 2017年 MrBai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Conversion)

#pragma mark - Base64Code
/**  base64编码 */
- (NSString *)base64String;

/**  base64Url编码 */
- (NSString *)base64UrlEncodedString;

/**  base64解码 */
- (NSString *)decodeBase64String;

/**  base64Url解码 */
- (NSString *)decodeBase64UrlEncodedString;

#pragma mark - MD5
/**  @return 32个字符的MD5散列字符串 */
- (NSString *)md5String;

#pragma mark - AES加密
/**  @return AES128加密字符串 */
- (NSString *)aes128EncryptWithKey:(NSString *)key;

/**  @return AES256加密字符串 */
- (NSString *)aes256EncryptWithKey:(NSString *)key;

/**  @return AES128解密数据 */
- (NSData *)aes128DencryptWithKey:(NSString *)key;

/**  @return AES256解密数据 */
- (NSData *)aes256DencryptWithKey:(NSString *)key;

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

@end


/// Utilities for NSStrings containing HTML
@interface NSString (GTMNSStringHTMLAdditions)

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

@end


@interface NSString (LoginChecking)

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

@end
