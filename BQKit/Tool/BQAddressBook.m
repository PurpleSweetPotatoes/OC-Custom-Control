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
    if (@available(iOS 9.0, *)) {
        CNContactStore *contactStore = [[CNContactStore alloc] init]; // 创建通讯录
        // 请求授权
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:handler];
    } else {
        CFErrorRef *error = nil;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(nil, error);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            handler(granted, (__bridge NSError *)error);
        });
    }
}

+ (void)loadAddressBooksInfo:(void(^)(NSArray *phionArr))AddressBooksBlock {
    
    if (@available(iOS 9.0, *)) {
        [self loadNewAddressBooks:AddressBooksBlock];
    } else {
        [self loadOldAddressBooks:AddressBooksBlock];
    }

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

+ (void)loadOldAddressBooks:(void (^)(NSArray *))AddressBooksBlock {
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        [self copyAddressBook:addressBook withAddressBooks:AddressBooksBlock];
    } else {
        //没有获取通讯录权限
        AddressBooksBlock(nil);
    }
}

+ (void)copyAddressBook:(ABAddressBookRef)addressBook withAddressBooks:(void (^)(NSArray *))AddressBooksBlock
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    //创建储存数据数组
    NSMutableArray *phoneArray = [NSMutableArray array];
    
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSString * firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString * lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString * name = [NSString stringWithFormat:@"%@%@",firstName, lastName];
        /*
         
         //读取middlename
         NSString *middlename = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
         //读取prefix前缀
         NSString *prefix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
         //读取suffix后缀
         NSString *suffix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
         //读取nickname呢称
         NSString *nickname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
         //读取firstname拼音音标
         NSString *firstnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
         //读取lastname拼音音标
         NSString *lastnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
         //读取middlename拼音音标
         NSString *middlenamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
         //读取organization公司
         NSString *organization = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
         //读取jobtitle工作
         NSString *jobtitle = (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
         //读取department部门
         NSString *department = (__bridge NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
         //读取birthday生日
         NSDate *birthday = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
         //读取note备忘录
         NSString *note = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
         //第一次添加该条记录的时间
         NSString *firstknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
         NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
         //最后一次修改該条记录的时间
         NSString *lastknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
         NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
         
         //获取email多值
         ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
         int emailcount = ABMultiValueGetCount(email);
         for (int x = 0; x < emailcount; x++)
         {
         //获取email Label
         NSString* emailLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
         //获取email值
         NSString* emailContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(email, x);
         }
         //读取地址多值
         ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
         int count = ABMultiValueGetCount(address);
         
         for(int j = 0; j < count; j++)
         {
         //获取地址Label
         NSString* addressLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, j);
         //获取該label下的地址6属性
         NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
         NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
         NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
         NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
         NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
         NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
         NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
         }
         
         //获取dates多值
         ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
         int datescount = ABMultiValueGetCount(dates);
         for (int y = 0; y < datescount; y++)
         {
         //获取dates Label
         NSString* datesLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
         //获取dates值
         NSString* datesContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(dates, y);
         }
         //获取kind值
         CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
         if (recordType == kABPersonKindOrganization) {
         // it's a company
         NSLog(@"it's a company\n");
         } else {
         // it's a person, resource, or room
         NSLog(@"it's a person, resource, or room\n");
         }
         
         
         //获取IM多值
         ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
         for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
         {
         //获取IM Label
         NSString* instantMessageLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
         //获取該label下的2属性
         NSDictionary* instantMessageContent =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
         NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
         
         NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
         }
         
         //获取URL多值
         ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
         for (int m = 0; m < ABMultiValueGetCount(url); m++)
         {
         //获取电话Label
         NSString * urlLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
         //获取該Label下的电话值
         NSString * urlContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(url,m);
         }
         
         //读取照片
         NSData *image = (__bridge NSData*)ABPersonCopyImageData(person);
         */
        
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k < ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            
            NSDictionary * dict = @{@"name" : name,
                                    @"phone" : personPhone};
            [phoneArray addObject:dict];
        }
        
    }
    
    AddressBooksBlock(phoneArray);
}

@end
