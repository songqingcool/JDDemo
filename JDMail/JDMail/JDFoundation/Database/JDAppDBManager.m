//
//  JDAppDBManager.m
//  JDMail
//
//  Created by 公司 on 2019/3/1.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDAppDBManager.h"
#import <FMDB/FMDB.h>
#import "JDAccount.h"

@interface JDAppDBManager ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation JDAppDBManager

/**
 *  单例方法
 *
 *  @return 实例对象
 */

+ (instancetype)shareManager {
    static JDAppDBManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/app_1.1.db"];
        self.queue = [FMDatabaseQueue databaseQueueWithPath:path password:@"123456"];
        [self createTable];
    }
    return self;
}

- (void)dealloc
{
    [self.queue close];
    self.queue = nil;
}

- (NSString *)sqlString:(NSString *)string
{
    if (string.length == 0) {
        return @"";
    }
    
    NSString *tempString = [string stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    return tempString;
}

- (BOOL)createTable
{
    __block BOOL result = NO;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isExists = [db tableExists:@"Account"];
        if (isExists) {
            result = YES;
        }else{
            NSString *sql = @"CREATE TABLE IF NOT EXISTS Account(account TEXT PRIMARY KEY, password TEXT, nickName TEXT, avatar TEXT, server TEXT, domain TEXT, userName TEXT, folderSyncState TEXT DEFAULT '')";
            result = [db executeUpdate:sql];
            // 执行失败回滚
            if (!result) {
                *rollback = YES;
            }
        }
    }];
    return result;
}

- (BOOL)insertOrReplaceAccount:(JDAccount *)account
{
    __block BOOL result = NO;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO Account (account, password, nickName, avatar, server, domain, userName) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", [self sqlString:account.account], [self sqlString:account.password], [self sqlString:account.nickName], [self sqlString:account.avatar], [self sqlString:account.server], [self sqlString:account.domain], [self sqlString:account.userName]];
        result = [db executeUpdate:sql];
    }];
    return result;
}

- (BOOL)updatefolderSyncState:(NSString *)syncState account:(NSString *)account
{
    __block BOOL result = NO;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE Account SET folderSyncState = '%@' WHERE account = '%@'", [self sqlString:syncState], [self sqlString:account]];
        result = [db executeUpdate:sql];
    }];
    return result;
}

- (BOOL)deleteAccount:(NSString *)account
{
    __block BOOL result = NO;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM Account WHERE account = '%@'", [self sqlString:account]];
        result = [db executeUpdate:sql];
    }];
    return result;
}

- (NSArray *)queryAllAccount
{
    __block NSArray *retArray = nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Account"];
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *tempArray = [NSMutableArray array];
        while ([set next]) {
            JDAccount *account = [[JDAccount alloc] init];
            account.account = [set stringForColumn:@"account"];
            account.password = [set stringForColumn:@"password"];
            account.nickName = [set stringForColumn:@"nickName"];
            account.avatar = [set stringForColumn:@"avatar"];
            account.server = [set stringForColumn:@"server"];
            account.domain = [set stringForColumn:@"domain"];
            account.userName = [set stringForColumn:@"userName"];
            [tempArray addObject:account];
        }
        [set close];
        retArray = tempArray;
    }];
    return retArray;
}

- (NSString *)queryfolderSyncStateWithAccount:(NSString *)account
{
    __block NSArray *retArray = nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT account,folderSyncState FROM Account WHERE account='%@'",account];
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *tempArray = [NSMutableArray array];
        while ([set next]) {
            NSString *folderSyncState = [set stringForColumn:@"folderSyncState"];
            if (folderSyncState) {
                [tempArray addObject:folderSyncState];
            }
        }
        [set close];
        retArray = tempArray;
    }];
    return retArray.firstObject;
}

- (NSArray *)queryAllfolderSyncState
{
    __block NSArray *retArray = nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT account,folderSyncState FROM Account"];
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *tempArray = [NSMutableArray array];
        while ([set next]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSString *account = [set stringForColumn:@"account"];
            [dict setValue:account forKey:@"account"];
            NSString *folderSyncState = [set stringForColumn:@"folderSyncState"];
            [dict setValue:folderSyncState forKey:@"folderSyncState"];
            [tempArray addObject:dict];
        }
        [set close];
        retArray = tempArray;
    }];
    return retArray.firstObject;
}

@end
