
//
//  JDMailDBManager.m
//  JDMail
//
//  Created by 千阳 on 2019/3/14.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDMailDBManager.h"
#import <FMDB/FMDB.h>
#import "JDMailFolder.h"
#import "JDMailListModel.h"
#import "JDMailPerson.h"
#import "JDMailAttachment.h"

@interface JDMailDBManager ()

@property (nonatomic, strong) NSMutableDictionary *queueDict;

@end

@implementation JDMailDBManager

+ (instancetype)shareManager
{
    static JDMailDBManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JDMailDBManager alloc] init];
    });
    return instance;
}

- (NSMutableDictionary *)queueDict
{
    if (!_queueDict) {
        _queueDict = [NSMutableDictionary dictionary];
    }
    return _queueDict;
}

- (void)dealloc
{
    for (FMDatabaseQueue *queue in self.queueDict.allValues) {
        [queue close];
    }
    _queueDict = nil;
}

- (NSString *)sqlString:(NSString *)string
{
    if (string.length == 0) {
        return @"";
    }
    
    NSString *tempString = [string stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    return tempString;
}

- (void)registerEmailDBWithCurrentAccount:(NSString *)account
{
    if (!account) {
        return;
    }
    
    FMDatabaseQueue *queue = [self.queueDict objectForKey:account];
    if (!queue) {
        NSString *folderPath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/%@",account];
        [self creatFolder:folderPath];
        NSString *path = [folderPath stringByAppendingPathComponent:@"Email_1.1.db"];
        // queue = [FMDatabaseQueue databaseQueueWithPath:path password:@"123456789"];
        queue = [FMDatabaseQueue databaseQueueWithPath:path];
        NSLog(@"JDMailDBManager DatabasePath:%@",path);
        [self.queueDict setValue:queue forKey:account];
        [self createFolderTableWithAccount:account];
        [self createEmailItemTableWithAccount:account];
        [self createEmailContentTableWithAccount:account];
    }
}

- (void)creatFolder:(NSString *)folderPath
{
    BOOL isDir = NO;
    BOOL dirIsExist = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDir];
    if(!(dirIsExist && isDir)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - Folder

- (BOOL)createFolderTableWithAccount:(NSString *)account
{
    __block BOOL result = NO;
    if (!account) {
        return result;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return result;
    }
    
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL isExists = [db tableExists:@"Folder"];
        if (isExists) {
            result = YES;
        }else{
            NSString *sql = @"CREATE TABLE IF NOT EXISTS Folder (folderId TEXT PRIMARY KEY,changeKey text,parentFolderId text,parentChangeKey text,folderClass text,displayName text,totalCount text,childFolderCount text,unreadCount text,syncState text)";
            result = [db executeUpdate:sql];
            // 执行失败回滚
            if (!result) {
                *rollback = YES;
            }
        }
    }];
    return result;
}

- (BOOL)insertFolderWithAccount:(NSString *)account
                    folderArray:(NSArray *)folderArray
{
    __block BOOL result = NO;
    if (!account) {
        return result;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return result;
    }
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (JDMailFolder *folder in folderArray) {
            NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO Folder (folderId,changeKey,parentFolderId,parentChangeKey,folderClass,displayName,totalCount,childFolderCount,unreadCount) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",folder.folderId,
                             folder.changeKey,
                             folder.parentFolderId,
                             folder.parentChangeKey,
                             folder.folderClass,
                             [self sqlString:folder.displayName],
                             folder.totalCount,
                             folder.childFolderCount,
                             folder.unreadCount];
            result = [db executeUpdate:sql];
            // 执行失败回滚
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    return result;
}

- (BOOL)deleteFolderWithAccount:(NSString *)account
                    folderArray:(NSArray *)folderArray
{
    __block BOOL result = NO;
    if (!account) {
        return result;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return result;
    }
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (JDMailFolder *folder in folderArray) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM Folder WHERE folderId='%@'",folder.folderId];
            result = [db executeUpdate:sql];
            // 执行失败回滚
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    return result;
}

- (NSArray *)queryFolderWithAccount:(NSString *)account
{
    __block NSArray *retArray = nil;
    if (!account) {
        return retArray;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return retArray;
    }
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT * FROM Folder";
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *tempArray = [NSMutableArray array];
        while ([set next]) {
            JDMailFolder *folder = [[JDMailFolder alloc] init];
            folder.folderId = [set stringForColumn:@"folderId"];
            folder.changeKey = [set stringForColumn:@"changeKey"];
            folder.parentFolderId = [set stringForColumn:@"parentFolderId"];
            folder.parentChangeKey = [set stringForColumn:@"parentChangeKey"];
            folder.folderClass = [set stringForColumn:@"folderClass"];
            folder.displayName = [set stringForColumn:@"displayName"];
            folder.totalCount = [set stringForColumn:@"totalCount"];
            folder.childFolderCount = [set stringForColumn:@"childFolderCount"];
            folder.unreadCount = [set stringForColumn:@"unreadCount"];
            [tempArray addObject:folder];
        }
        [set close];
        retArray = tempArray;
    }];
    return retArray;
}

- (NSString *)queryFolderSyncStateWithAccount:(NSString *)account
                                     folderId:(NSString *)folderId
{
    __block NSArray *retArray = nil;
    if (!account) {
        return nil;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return nil;
    }
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT syncState FROM Folder WHERE folderId = '%@'",folderId];
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *tempArray = [NSMutableArray array];
        while ([set next]) {
            NSString *syncState = [set stringForColumn:@"syncState"];
            if (syncState) {
                [tempArray addObject:syncState];
            }
        }
        [set close];
        retArray = tempArray;
    }];
    return retArray.firstObject;
}

- (BOOL)updateFolderSyncState:(NSString *)syncState
                      account:(NSString *)account
                     folderId:(NSString *)folderId
{
    __block BOOL result = NO;
    if (!account || !folderId) {
        return result;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return result;
    }
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE Folder SET syncState='%@' WHERE folderId='%@'",syncState,folderId];
        result = [db executeUpdate:sql];
        // 执行失败回滚
        if (!result) {
            *rollback = YES;
        }
    }];
    return result;
}

#pragma mark - Mail

- (BOOL)createEmailItemTableWithAccount:(NSString *)account
{
    __block BOOL result = NO;
    if (!account) {
        return result;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return result;
    }
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSArray *list = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        for (NSString *number in list) {
            BOOL isExists = [db tableExists:[NSString stringWithFormat:@"EmailItem_%@",number]];
            if (isExists) {
                result = YES;
                continue ;
            }else{
                NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS EmailItem_%@ (itemId TEXT PRIMARY KEY,changeKey text,parentFolderId text,parentChangeKey text,itemClass text,subject text,sensitivity text,dateTimeReceived text,size text,importance text,inReplyTo text,isSubmitted text,isDraft text,isResend text,isFromMe text,isUnmodified text,dateTimeSent text,dateTimeCreated text,reminderIsSet text,displayTo text,hasAttachments text,culture text,flagStatus text,from_name text,from_emailAddress text,from_routingType text,from_mailboxType text,isRead text)",number];
                result = [db executeUpdate:sql];
                // 执行失败回滚
                if (!result) {
                    *rollback = YES;
                    break;
                }
            }
        }
    }];
    return result;
}

- (BOOL)insertEmailItemWithAccount:(NSString *)account
                          folderId:(NSString *)folderId
                             items:(NSArray *)items
{
    __block BOOL result = NO;
    if (!account) {
        return result;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return result;
    }
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (JDMailListModel *model in items) {
            NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO EmailItem_%@ (itemId,changeKey,parentFolderId,parentChangeKey,itemClass,subject,sensitivity,dateTimeReceived,size,importance,inReplyTo,isSubmitted,isDraft,isResend,isFromMe,isUnmodified,dateTimeSent,dateTimeCreated,reminderIsSet,displayTo,hasAttachments,culture,flagStatus,from_name,from_emailAddress,from_routingType,from_mailboxType,isRead) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@(folderId.hash%10).stringValue,model.itemId,
                             model.changeKey,
                             model.parentFolderId,
                             model.parentChangeKey,
                             model.itemClass,
                             [self sqlString:model.subject],
                             model.sensitivity,
                             model.dateTimeReceived,
                             model.size,
                             model.importance,
                             [self sqlString:model.inReplyTo],
                             model.isSubmitted,
                             model.isDraft,
                             model.isResend,
                             model.isFromMe,
                             model.isUnmodified,
                             model.dateTimeSent,
                             model.dateTimeCreated,
                             model.reminderIsSet,
                             [self sqlString:model.displayTo],
                             model.hasAttachments,
                             model.culture,
                             model.flagStatus,
                             [self sqlString:model.from.name],
                             [self sqlString:model.from.emailAddress],
                             model.from.routingType,
                             model.from.mailboxType,
                             model.isRead];
            result = [db executeUpdate:sql];
            // 执行失败回滚
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    return result;
}

- (BOOL)deleteEmailItemWithAccount:(NSString *)account
                          folderId:(NSString *)folderId
                             items:(NSArray *)items
{
    __block BOOL result = NO;
    if (!account) {
        return result;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return result;
    }
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (JDMailListModel *model in items) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM EmailItem_%@ WHERE itemId='%@'",@(folderId.hash%10).stringValue, model.itemId];
            result = [db executeUpdate:sql];
            // 执行失败回滚
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    return result;
}

- (NSArray *)queryEmailItemWithAccount:(NSString *)account
                              folderId:(NSString *)folderId
                      lastReceivedTime:(NSString *)lastReceivedTime
                              pageSize:(NSString *)pageSize
{
    __block NSArray *retArray = nil;
    if (!account) {
        return retArray;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return retArray;
    }
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = nil;
        NSString *itemTableName = [NSString stringWithFormat:@"EmailItem_%@",@(folderId.hash%10).stringValue];
        NSString *contentTableName = [NSString stringWithFormat:@"EmailContent_%@",@(folderId.hash%10).stringValue];
        if (lastReceivedTime.length) {
            sql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM %@ INNER JOIN %@ ON %@.itemId=%@.itemId AND %@.parentFolderId=%@.parentFolderId) WHERE parentFolderId='%@' AND dateTimeReceived<'%@' ORDER BY dateTimeReceived DESC LIMIT %@",itemTableName,contentTableName,itemTableName,contentTableName,itemTableName,contentTableName, folderId,lastReceivedTime,pageSize];
        }else{
            sql = [NSString stringWithFormat:@"SELECT * FROM (SELECT * FROM %@ INNER JOIN %@ ON %@.itemId=%@.itemId AND %@.parentFolderId=%@.parentFolderId) WHERE parentFolderId='%@' ORDER BY dateTimeReceived DESC LIMIT %@",itemTableName,contentTableName,itemTableName,contentTableName,itemTableName,contentTableName, folderId,pageSize];
        }
        FMResultSet *set = [db executeQuery:sql];
        NSMutableArray *tempArray = [NSMutableArray array];
        while ([set next]) {
            JDMailListModel *mail = [[JDMailListModel alloc] init];
            mail.itemId = [set stringForColumn:@"itemId"];
            mail.changeKey = [set stringForColumn:@"changeKey"];
            mail.parentFolderId = [set stringForColumn:@"parentFolderId"];
            mail.parentChangeKey = [set stringForColumn:@"parentChangeKey"];
            mail.itemClass = [set stringForColumn:@"itemClass"];
            mail.subject = [set stringForColumn:@"subject"];
            mail.sensitivity = [set stringForColumn:@"sensitivity"];
            mail.dateTimeReceived = [set stringForColumn:@"dateTimeReceived"];
            mail.size = [set stringForColumn:@"size"];
            mail.importance = [set stringForColumn:@"importance"];
            mail.inReplyTo = [set stringForColumn:@"inReplyTo"];
            mail.isSubmitted = [set stringForColumn:@"isSubmitted"];
            mail.isDraft = [set stringForColumn:@"isDraft"];
            mail.isResend = [set stringForColumn:@"isResend"];
            mail.isFromMe = [set stringForColumn:@"isFromMe"];
            mail.isUnmodified = [set stringForColumn:@"isUnmodified"];
            mail.dateTimeSent = [set stringForColumn:@"dateTimeSent"];
            mail.dateTimeCreated = [set stringForColumn:@"dateTimeCreated"];
            mail.reminderIsSet = [set stringForColumn:@"reminderIsSet"];
            mail.displayTo = [set stringForColumn:@"displayTo"];
            mail.hasAttachments = [set stringForColumn:@"hasAttachments"];
            mail.culture = [set stringForColumn:@"culture"];
            mail.flagStatus = [set stringForColumn:@"flagStatus"];
            JDMailPerson *person = [[JDMailPerson alloc] init];
            person.emailAddress = [set stringForColumn:@"from_emailAddress"];
            person.name = [set stringForColumn:@"from_name"];
            person.routingType = [set stringForColumn:@"from_routingType"];
            person.mailboxType = [set stringForColumn:@"from_mailboxType"];
            mail.from = person;
            mail.isRead = [set stringForColumn:@"isRead"];
            mail.bodyType = [set stringForColumn:@"bodyType"];
            mail.body = [set stringForColumn:@"body"];
            mail.bodyString = [set stringForColumn:@"bodyString"];
            NSString *toRecipients = [set stringForColumn:@"toRecipients"];
            NSData *toData = [toRecipients dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *toArray = [NSJSONSerialization JSONObjectWithData:toData options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *toList = [NSMutableArray array];
            for (NSDictionary *dict in toArray) {
                JDMailPerson *person = [[JDMailPerson alloc] init];
                person.name = [dict objectForKey:@"name"];
                person.emailAddress = [dict objectForKey:@"emailAddress"];
                person.routingType = [dict objectForKey:@"routingType"];
                person.mailboxType = [dict objectForKey:@"mailboxType"];
                [toList addObject:person];
            }
            mail.toRecipients = toList;
            NSString *ccRecipients = [set stringForColumn:@"ccRecipients"];
            NSData *ccData = [ccRecipients dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *ccArray = [NSJSONSerialization JSONObjectWithData:ccData options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *ccList = [NSMutableArray array];
            for (NSDictionary *dict in ccArray) {
                JDMailPerson *person = [[JDMailPerson alloc] init];
                person.name = [dict objectForKey:@"name"];
                person.emailAddress = [dict objectForKey:@"emailAddress"];
                person.routingType = [dict objectForKey:@"routingType"];
                person.mailboxType = [dict objectForKey:@"mailboxType"];
                [ccList addObject:person];
            }
            mail.ccRecipients = ccList;

            NSString *attachments = [set stringForColumn:@"attachments"];
            NSData *attachmentsData = [attachments dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *attachmentArray = [NSJSONSerialization JSONObjectWithData:attachmentsData options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *attachmentList = [NSMutableArray array];
            for (NSDictionary *dict in attachmentArray) {
                JDMailAttachment *attachment = [[JDMailAttachment alloc] init];
                attachment.attachmentId = [dict objectForKey:@"attachmentId"];
                attachment.name = [dict objectForKey:@"name"];
                attachment.contentType = [dict objectForKey:@"contentType"];
                attachment.contentId = [dict objectForKey:@"contentId"];
                attachment.isInline = [dict objectForKey:@"isInline"];
                attachment.size = [dict objectForKey:@"size"];
                [attachmentList addObject:attachment];
            }
            mail.attachments = attachmentList;
            [tempArray addObject:mail];
        }
        [set close];
        retArray = tempArray;
    }];
    return retArray;
}

#pragma mark - MailContent

- (BOOL)createEmailContentTableWithAccount:(NSString *)account
{
    __block BOOL result = NO;
    if (!account) {
        return result;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return result;
    }
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSArray *list = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        for (NSString *number in list) {
            BOOL isExists = [db tableExists:[NSString stringWithFormat:@"EmailContent_%@",number]];
            if (isExists) {
                result = YES;
                continue ;
            }else{
                NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS EmailContent_%@ (itemId TEXT PRIMARY KEY,changeKey text,parentFolderId text,parentChangeKey text,bodyType text,body text,bodyString text,toRecipients text,ccRecipients text,attachments text)",number];
                result = [db executeUpdate:sql];
                // 执行失败回滚
                if (!result) {
                    *rollback = YES;
                    break;
                }
            }
        }
    }];
    return result;
}

- (BOOL)insertEmailContentWithAccount:(NSString *)account
                             folderId:(NSString *)folderId
                                items:(NSArray *)items
{
    __block BOOL result = NO;
    if (!account) {
        return result;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return result;
    }
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (JDMailListModel *model in items) {
            NSMutableArray *toArray = [NSMutableArray array];
            for (JDMailPerson *toRecipient in model.toRecipients) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:toRecipient.emailAddress forKey:@"emailAddress"];
                [dict setValue:toRecipient.name forKey:@"name"];
                [dict setValue:toRecipient.routingType forKey:@"routingType"];
                [dict setValue:toRecipient.mailboxType forKey:@"mailboxType"];
                [toArray addObject:dict];
            }
            NSData *toData = [NSJSONSerialization dataWithJSONObject:toArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *toString = [[NSString alloc] initWithData:toData encoding:NSUTF8StringEncoding];
            
            NSMutableArray *ccArray = [NSMutableArray array];
            for (JDMailPerson *ccRecipient in model.ccRecipients) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:ccRecipient.emailAddress forKey:@"emailAddress"];
                [dict setValue:ccRecipient.name forKey:@"name"];
                [dict setValue:ccRecipient.routingType forKey:@"routingType"];
                [dict setValue:ccRecipient.mailboxType forKey:@"mailboxType"];
                [ccArray addObject:dict];
            }
            NSData *ccData = [NSJSONSerialization dataWithJSONObject:ccArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *ccString = [[NSString alloc] initWithData:ccData encoding:NSUTF8StringEncoding];
            
            NSMutableArray *attachmentArray = [NSMutableArray array];
            for (JDMailAttachment *attachment in model.attachments) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:attachment.attachmentId forKey:@"attachmentId"];
                [dict setValue:attachment.name forKey:@"name"];
                [dict setValue:attachment.contentType forKey:@"contentType"];
                [dict setValue:attachment.contentId forKey:@"contentId"];
                [dict setValue:attachment.isInline forKey:@"isInline"];
                [dict setValue:attachment.size forKey:@"size"];
                [attachmentArray addObject:dict];
            }
            NSData *attachmentsData = [NSJSONSerialization dataWithJSONObject:attachmentArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *attachmenString = [[NSString alloc] initWithData:attachmentsData encoding:NSUTF8StringEncoding];
            NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO EmailContent_%@ (itemId,changeKey,parentFolderId,parentChangeKey,bodyType,body,bodyString,toRecipients,ccRecipients,attachments) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@(folderId.hash%10).stringValue,model.itemId,
                             model.changeKey,
                             model.parentFolderId,
                             model.parentChangeKey,
                             model.bodyType,
                             [self sqlString:model.body],
                             [self sqlString:model.bodyString],
                             [self sqlString:toString],
                             [self sqlString:ccString],
                             [self sqlString:attachmenString]];
            result = [db executeUpdate:sql];
            // 执行失败回滚
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    return result;
}

- (BOOL)deleteEmailContentWithAccount:(NSString *)account
                             folderId:(NSString *)folderId
                                items:(NSArray *)items
{
    __block BOOL result = NO;
    if (!account) {
        return result;
    }
    FMDatabaseQueue *dbQueue = [self.queueDict objectForKey:account];
    if (!dbQueue) {
        return result;
    }
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (JDMailListModel *model in items) {
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM EmailContent_%@ WHERE itemId='%@'",@(folderId.hash%10).stringValue, model.itemId];
            result = [db executeUpdate:sql];
            // 执行失败回滚
            if (!result) {
                *rollback = YES;
                break;
            }
        }
    }];
    return result;
}

@end
