// *******************************************
//  File Name:      BQFMDBHelper.h       
//  Author:         MrBai
//  Created Date:   2019/11/5 11:32 AM
//    
//  Copyright © 2019 baiqiang
//  All rights reserved
// *******************************************
    

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - sqlite valueType

static NSString * const kFMDBTypeText = @"TEXT";
static NSString * const kFMDBTypeInt = @"INTEGER";
static NSString * const kFMDBTypeFloat = @"REAL";
static NSString * const kFMDBTypeBool = @"BLOB";


#pragma mark - sqlite model

///新建model继承自SqlModelm，通过BQFMDBHelper进行增删改查
@interface SqlModel : NSObject

@property (nonatomic, assign) NSInteger  keyId;

/*
 TEXT : 文本类型
 INTEGER : 数字类型
 REAL: 浮点类型
 BLOB: 二进制(对真假使用)
 */
+ (NSDictionary<NSString *,NSString *> *)propertyTypes;
@end


@class FMDatabase;

///快捷操作fmdb
@interface BQFMDBHelper : NSObject

@property (nonatomic, readonly, strong) FMDatabase * db;

+ (instancetype)database;

+ (instancetype)databaseWithPath:(NSString *)path;

- (BOOL)open;

- (BOOL)close;

#pragma mark - 表操作

- (BOOL)createTable:(Class)cls;

- (BOOL)clearTable:(Class)cls;

- (BOOL)deleteTable:(Class)cls;

#pragma mark - 表内操作

- (NSArray *)lookUpInfo:(Class)cls;

/// @param whereSql 查询条件: 例如 age = 18
- (NSArray *)lookUpInfo:(Class)cls where:(NSString *)whereSql;

- (BOOL)insertInfo:(SqlModel *)objc;

- (BOOL)updateInfo:(SqlModel *)objc;

- (BOOL)deleteInfo:(SqlModel *)objc;

/// 事务操作
/// @param action 返回操作结果
- (void)transactionAction:(BOOL(^)(void))action;

@end

NS_ASSUME_NONNULL_END
