// *******************************************
//  File Name:      BQFMDBHelper.m       
//  Author:         MrBai
//  Created Date:   2019/11/5 11:32 AM
//    
//  Copyright © 2019 baiqiang
//  All rights reserved
// *******************************************
    

#import "BQFMDBHelper.h"
#import <FMDB/FMDB.h>

@interface BQFMDBHelper ()
@property (nonatomic, strong) FMDatabase * db;
@end

static NSMutableDictionary * dbInfo;

@implementation BQFMDBHelper

- (void)dealloc {
    if (self.db.databasePath) {
        [self close];
        [dbInfo removeObjectForKey:self.db.databasePath];
    }
}

+ (instancetype)database {
    NSString * document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString * path = [document stringByAppendingPathComponent:@"BQData.db"];
    return [self databaseWithPath:path];
}

+ (instancetype)databaseWithPath:(NSString *)path {
    
    if (dbInfo == nil) {
        dbInfo = [NSMutableDictionary dictionary];
    } else if (dbInfo[path]){
        return dbInfo[path];
    }
    
    BQFMDBHelper * helper = [[BQFMDBHelper alloc] init];
    helper.db = [FMDatabase databaseWithPath:path];
    return helper;
}

- (BOOL)open {
    return [self.db open];
}

- (BOOL)close {
    return [self.db close];
}

#pragma mark - 表操作相关

- (BOOL)createTable:(Class)cls {

    if ([cls respondsToSelector:@selector(propertyTypes)]) {
        NSMutableString * sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_%@ (id INTEGER PRIMARY KEY AUTOINCREMENT", NSStringFromClass(cls)];
        NSDictionary * dic = [cls propertyTypes];
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            [sql appendString:[NSString stringWithFormat:@", %@ %@",key, obj]];
        }];
        [sql appendString:@")"];
        return [self.db executeUpdate:sql];
    }
    return NO;
}

- (BOOL)clearTable:(Class)cls {
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM t_%@", NSStringFromClass(cls)];
    return [self.db executeUpdate:sql];
}

- (BOOL)deleteTable:(Class)cls {
    NSString * sql = [NSString stringWithFormat:@"DROP TABLE t_%@", NSStringFromClass(cls)];
    return [self.db executeUpdate:sql];
}

#pragma mark - 表内操作

- (NSArray *)lookUpInfo:(Class)cls {
    return [self lookUpInfo:cls where:@""];
}

- (NSArray *)lookUpInfo:(Class)cls where:(NSString *)whereSql {

    NSString * query = [NSString stringWithFormat:@"SELECT * FROM t_%@",NSStringFromClass(cls)];
    if (whereSql.length > 0) {
        query = [NSString stringWithFormat:@"%@ WHERE %@",query, whereSql];
    }
    FMResultSet * result = [self.db executeQuery:query];
    NSDictionary * dic = [cls propertyTypes];
    NSMutableArray * arr = [NSMutableArray array];
    
    while ([result next]) {
        SqlModel * model = [[cls alloc] init];
        model.keyId = [result intForColumn:@"id"];
        for (NSString * key in dic.allKeys) {
            [model setValue:[result stringForColumn:key] forKey:key];
        }
        [arr addObject:model];
    }
    
    return arr;
}

- (BOOL)insertInfo:(SqlModel *)objc {
    Class cls = [objc class];
    NSDictionary * dic = [cls propertyTypes];
    NSArray * keyArr = dic.allKeys;
    NSMutableString * sql = [NSMutableString stringWithFormat:@"INSERT INTO t_%@ (%@) VALUES (", NSStringFromClass(cls), [keyArr componentsJoinedByString:@", "]];
    NSInteger i = 0;
    for (NSString * key in keyArr) {
        i+=1;
        NSString * lastStr = i == keyArr.count ? @")":@",";
        if ([dic[key] isEqualToString:kFMDBTypeText]) {
            [sql appendString:[NSString stringWithFormat:@"'%@'%@", [objc valueForKey:key], lastStr]];
        } else {
            [sql appendString:[NSString stringWithFormat:@"%@%@", [objc valueForKey:key], lastStr]];
        }
    }
    return [self.db executeUpdate:sql];
}

- (BOOL)updateInfo:(SqlModel *)objc {
    if (objc.keyId <= 0) return NO;
    
    Class cls = [objc class];
    NSDictionary * dic = [cls propertyTypes];
    NSMutableString * sql = [NSMutableString stringWithFormat:@"UPDATE t_%@ SET", NSStringFromClass(cls)];
    __block NSInteger i = dic.allKeys.count;
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull type, BOOL * _Nonnull stop) {
        i-=1;
        if ([type isEqualToString:kFMDBTypeText]) {
            [sql appendString:[NSString stringWithFormat:@" %@ = '%@'", key,[objc valueForKey:key]]];
        } else {
            [sql appendString:[NSString stringWithFormat:@" %@ = %@", key,[objc valueForKey:key]]];
        }
        if (i != 0) {
            [sql appendString:@","];
        }
    }];
    [sql appendString:[NSString stringWithFormat:@" WHERE id = %ld;", objc.keyId]];
    return [self.db executeUpdate:sql];
}

- (BOOL)deleteInfo:(SqlModel *)objc {
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM t_%@ WHERE id = %ld", NSStringFromClass([objc class]) ,objc.keyId];
    return [self.db executeUpdate:sql];
}

- (void)transactionAction:(BOOL (^)(void))action {
    [self.db beginTransaction];
    if (action()) {
        [self.db commit];
    } else {
        [self.db rollback];
    }
}

@end


@implementation SqlModel

+ (NSDictionary<NSString *,NSString *> *)propertyTypes { return  @{};};

- (instancetype)init {
    self = [super init];
    if (self) {
        self.keyId = 0;
    }
    return self;
}

@end
