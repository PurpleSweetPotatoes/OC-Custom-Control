//
//  BQAddressBookManager.m
//  Test-demo
//
//  Created by baiqiang on 2018/1/11.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "BQAddressBook.h"

@implementation BQAddressBook

+ (void)requestAccessAddressBookCompletionHandler:(void(^)(BOOL granted, NSError * resion))handler {
    CNContactStore *contactStore = [[CNContactStore alloc] init]; // 创建通讯录
    // 请求授权
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:handler];
}

+ (void)loadAddressBooksInfo:(void(^)(NSArray *phoneArr))AddressBooksBlock {
    [self loadNewAddressBooks:AddressBooksBlock];
}

+ (void)loadNewAddressBooks:(void (^)(NSArray *))AddressBooksBlock {
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    // 2.判断授权状态,如果不是已经授权,则直接返回
    if (status != CNAuthorizationStatusAuthorized){
        AddressBooksBlock(nil);
        return;
    }
    
    //2.1创建储存数据数组
    NSMutableArray *phoneArray = [NSMutableArray array];
    
    // 3.创建通信录对象
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    // 4.创建获取通信录的请求对象
    // 4.1.拿到所有打算获取的属性对应的key
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    
    // 4.2.创建CNContactFetchRequest对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    request.sortOrder = CNContactSortOrderGivenName;
    
    
    // 5.遍历所有的联系人
    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        // 1.获取联系人的姓名
        NSString *lastname = contact.familyName;
        NSString *firstname = contact.givenName;
        NSString * name = [NSString stringWithFormat:@"%@%@",firstname,lastname];
        
        // 2.获取联系人的电话号码
        NSArray * phoneNums = contact.phoneNumbers;
        for (CNLabeledValue * labeledValue in phoneNums) {
            // 2.1.获取电话号码的KEY
//            NSString *phoneLabel = labeledValue.label;
            // 2.2.获取电话号码
            CNPhoneNumber * phoneNumer = labeledValue.value;
            NSString * phoneValue = phoneNumer.stringValue;
            
            NSDictionary * dict = @{@"name" : name,
                                    @"phone" : phoneValue};
            //储存数据
            [phoneArray addObject:dict];
        }
        
        AddressBooksBlock(phoneArray);
    }];
}


@end
