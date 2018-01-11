//
//  BQAddressBookManager.h
//  Test-demo
//
//  Created by baiqiang on 2018/1/11.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

/*
 需要在info.plist文件中添加 Privacy - Contacts Usage Description字段
 */

@interface BQAddressBook : NSObject

/**
 加载通讯录数据,iOS9后由于异步读取会多次调用AddressBooksBlock

 @param AddressBooksBlock 回调方法
 */
+ (void)loadAddressBooksInfo:(void(^)(NSArray *phionArr))AddressBooksBlock;


/**
 验证权限，第一次会请求授权
 */
+ (void)requestAccessAddressBookCompletionHandler:(void(^)(BOOL granted, NSError * resion))handler;

@end
