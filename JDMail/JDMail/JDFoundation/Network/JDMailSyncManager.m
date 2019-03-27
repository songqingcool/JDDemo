//
//  JDMailSyncManager.m
//  JDMail
//
//  Created by 公司 on 2019/3/13.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDMailSyncManager.h"
#import "JDNetworkManager.h"
#import "GDataXMLNode.h"
#import "JDMailMessageBuilder.h"
#import "JDAppDBManager.h"
#import "JDMailDBManager.h"
#import "JDMailFolder.h"
#import "JDMailListModel.h"
#import "JDMailPerson.h"
#import "JDMailAttachment.h"
#import <UIKit/UIKit.h>

@interface JDMailSyncManager ()

@end

@implementation JDMailSyncManager

/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager
{
    static JDMailSyncManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JDMailSyncManager alloc] init];
    });
    return instance;
}

- (void)syncFolderHierarchyWithAccount:(NSString *)account
                             syncState:(NSString *)syncState
                               success:(void (^)(void))success
                               failure:(void (^)(NSError *error))failure
{
    NSString *syncFolderString = [[JDMailMessageBuilder new] ewsSoapMessageSyncFolderHierarchyWithSyncState:syncState];
    __weak JDMailSyncManager *weakSelf = self;
    [[JDNetworkManager shareManager] POSTWithAccount:account httpBodyString:syncFolderString success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        __strong JDMailSyncManager *strongSelf = weakSelf;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *soapBody = [[rootElement elementsForName:@"s:Body"] firstObject];
        GDataXMLElement *syncFolderHierarchyResponse = [[soapBody elementsForName:@"m:SyncFolderHierarchyResponse"] firstObject];
        GDataXMLElement *responseMessages = [[syncFolderHierarchyResponse elementsForName:@"m:ResponseMessages"] firstObject];
        GDataXMLElement *syncFolderHierarchyResponseMessage = [[responseMessages elementsForName:@"m:SyncFolderHierarchyResponseMessage"] firstObject];
        GDataXMLElement *responseCode = [[syncFolderHierarchyResponseMessage elementsForName:@"m:ResponseCode"] firstObject];
        if ([[responseCode stringValue] isEqualToString:@"NoError"]) {
            GDataXMLElement *changes = [[syncFolderHierarchyResponseMessage elementsForName:@"m:Changes"] firstObject];
            // 新增
            NSArray *creates = [changes elementsForName:@"t:Create"];
            NSMutableArray *createArray = [NSMutableArray array];
            for (GDataXMLElement *create in creates) {
                JDMailFolder *folder = [[JDMailFolder alloc] init];
                GDataXMLElement *folderElement = [[create elementsForName:@"t:Folder"] firstObject];
                if (!folderElement) {
                    continue ;
                }
                GDataXMLElement *folderIdElement = [[folderElement elementsForName:@"t:FolderId"] firstObject];
                GDataXMLNode *idNode = [folderIdElement attributeForName:@"Id"];
                GDataXMLNode *changeKeyNode = [folderIdElement attributeForName:@"ChangeKey"];
                folder.folderId = [idNode stringValue];
                folder.changeKey = [changeKeyNode stringValue];
                GDataXMLElement *parentFolderIdElement = [[folderElement elementsForName:@"t:ParentFolderId"] firstObject];
                GDataXMLNode *parentIdNode = [parentFolderIdElement attributeForName:@"Id"];
                GDataXMLNode *parentChangeKeyNode = [parentFolderIdElement attributeForName:@"ChangeKey"];
                folder.parentFolderId = [parentIdNode stringValue];
                folder.parentChangeKey = [parentChangeKeyNode stringValue];
                GDataXMLElement *folderClassElement = [[folderElement elementsForName:@"t:FolderClass"] firstObject];
                folder.folderClass = [folderClassElement stringValue];
                if (![[folderClassElement stringValue] hasPrefix:@"IPF.Note"]) {
                    continue ;
                }
                GDataXMLElement *displayNameElement = [[folderElement elementsForName:@"t:DisplayName"] firstObject];
                folder.displayName = [displayNameElement stringValue];
                GDataXMLElement *totalCountElement = [[folderElement elementsForName:@"t:TotalCount"] firstObject];
                folder.totalCount = [totalCountElement stringValue];
                GDataXMLElement *childFolderCountElement = [[folderElement elementsForName:@"t:ChildFolderCount"] firstObject];
                folder.childFolderCount = [childFolderCountElement stringValue];
                GDataXMLElement *unreadCountElement = [[folderElement elementsForName:@"t:UnreadCount"] firstObject];
                folder.unreadCount = [unreadCountElement stringValue];
                [createArray addObject:folder];
            }
            // 更新
            NSArray *updates = [changes elementsForName:@"t:Update"];
            NSMutableArray *updateArray = [NSMutableArray array];
            for (GDataXMLElement *update in updates) {
                JDMailFolder *folder = [[JDMailFolder alloc] init];
                GDataXMLElement *folderElement = [[update elementsForName:@"t:Folder"] firstObject];
                if (!folderElement) {
                    continue ;
                }
                GDataXMLElement *folderIdElement = [[folderElement elementsForName:@"t:FolderId"] firstObject];
                GDataXMLNode *idNode = [folderIdElement attributeForName:@"Id"];
                GDataXMLNode *changeKeyNode = [folderIdElement attributeForName:@"ChangeKey"];
                folder.folderId = [idNode stringValue];
                folder.changeKey = [changeKeyNode stringValue];
                GDataXMLElement *parentFolderIdElement = [[folderElement elementsForName:@"t:ParentFolderId"] firstObject];
                GDataXMLNode *parentIdNode = [parentFolderIdElement attributeForName:@"Id"];
                GDataXMLNode *parentChangeKeyNode = [parentFolderIdElement attributeForName:@"ChangeKey"];
                folder.parentFolderId = [parentIdNode stringValue];
                folder.parentChangeKey = [parentChangeKeyNode stringValue];
                GDataXMLElement *folderClassElement = [[folderElement elementsForName:@"t:FolderClass"] firstObject];
                folder.folderClass = [folderClassElement stringValue];
                if (![[folderClassElement stringValue] hasPrefix:@"IPF.Note"]) {
                    continue ;
                }
                GDataXMLElement *displayNameElement = [[folderElement elementsForName:@"t:DisplayName"] firstObject];
                folder.displayName = [displayNameElement stringValue];
                GDataXMLElement *totalCountElement = [[folderElement elementsForName:@"t:TotalCount"] firstObject];
                folder.totalCount = [totalCountElement stringValue];
                GDataXMLElement *childFolderCountElement = [[folderElement elementsForName:@"t:ChildFolderCount"] firstObject];
                folder.childFolderCount = [childFolderCountElement stringValue];
                GDataXMLElement *unreadCountElement = [[folderElement elementsForName:@"t:UnreadCount"] firstObject];
                folder.unreadCount = [unreadCountElement stringValue];
                [updateArray addObject:folder];
            }
            // 删除
            NSArray *deletes = [changes elementsForName:@"t:Delete"];
            NSMutableArray *deleteArray = [NSMutableArray array];
            for (GDataXMLElement *delete in deletes) {
                JDMailFolder *folder = [[JDMailFolder alloc] init];
                GDataXMLElement *folderIdElement = [[delete elementsForName:@"t:FolderId"] firstObject];
                GDataXMLNode *idNode = [folderIdElement attributeForName:@"Id"];
                GDataXMLNode *changeKeyNode = [folderIdElement attributeForName:@"ChangeKey"];
                folder.folderId = [idNode stringValue];
                folder.changeKey = [changeKeyNode stringValue];
                [deleteArray addObject:folder];
            }
            // 存储数据
            BOOL insertResult = NO;
            if (createArray.count) {
                insertResult = [[JDMailDBManager shareManager] insertFolderWithAccount:account folderArray:createArray];
            }else{
                insertResult = YES;
            }
            BOOL updateResult = NO;
            if (updateArray.count) {
                updateResult = [[JDMailDBManager shareManager] insertFolderWithAccount:account folderArray:updateArray];
            }else{
                updateResult = YES;
            }
            BOOL deleteResult = NO;
            if (deleteArray.count) {
                deleteResult = [[JDMailDBManager shareManager] deleteFolderWithAccount:account folderArray:deleteArray];
            }else{
                deleteResult = YES;
            }
            if (insertResult && updateResult && deleteResult) {
                GDataXMLElement *syncStateElement = [[syncFolderHierarchyResponseMessage elementsForName:@"m:SyncState"] firstObject];
                [[JDAppDBManager shareManager] updatefolderSyncState:[syncStateElement stringValue] account:account];
                GDataXMLElement *includesLastFolderInRange = [[syncFolderHierarchyResponseMessage elementsForName:@"m:IncludesLastFolderInRange"] firstObject];
                if ([[includesLastFolderInRange stringValue] isEqualToString:@"true"]) {
                    // 没有下一页
                    NSLog(@"%@文件夹同步完成",account);
                    if (success) {
                        success();
                    }
                }else{
                    // 有下一页
                    [strongSelf syncFolderHierarchyWithAccount:account syncState:[syncStateElement stringValue] success:success failure:failure];
                }
            }else{
                // 存储数据失败
                if (failure) {
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    [userInfo setValue:@"同步文件夹层次时数据库保存数据出错" forKey:@"msg"];
                    NSError *error = [NSError errorWithDomain:@"JD-Mail-Domain-Error" code:999 userInfo:userInfo];
                    failure(error);
                }
            }
        }else{
            if (failure) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:@"服务端报错" forKey:@"msg"];
                NSError *error = [NSError errorWithDomain:@"JD-Mail-Domain-Error" code:999 userInfo:userInfo];
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)syncFolderItemsWithAccount:(NSString *)account
                          folderId:(NSString *)folderId
                   folderChangeKey:(NSString *)folderChangeKey
                         syncState:(NSString *)syncState
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure
{
    NSString *syncFolderString = [[JDMailMessageBuilder new] ewsSoapMessageSyncFolderItemsWithFolderId:folderId folderChangeKey:folderChangeKey distinguishedFolderId:@"" syncState:syncState maxChangesReturned:@"20" syncScope:@"NormalItems"];
    __weak JDMailSyncManager *weakSelf = self;
    [[JDNetworkManager shareManager] POSTWithAccount:account httpBodyString:syncFolderString success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        __strong JDMailSyncManager *strongSelf = weakSelf;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *soapBody = [[rootElement elementsForName:@"s:Body"] firstObject];
        GDataXMLElement *syncFolderItemsResponse = [[soapBody elementsForName:@"m:SyncFolderItemsResponse"] firstObject];
        GDataXMLElement *responseMessages = [[syncFolderItemsResponse elementsForName:@"m:ResponseMessages"] firstObject];
        GDataXMLElement *syncFolderItemsResponseMessage = [[responseMessages elementsForName:@"m:SyncFolderItemsResponseMessage"] firstObject];
        GDataXMLElement *responseCode = [[syncFolderItemsResponseMessage elementsForName:@"m:ResponseCode"] firstObject];
        if ([[responseCode stringValue] isEqualToString:@"NoError"]) {
            GDataXMLElement *changes = [[syncFolderItemsResponseMessage elementsForName:@"m:Changes"] firstObject];
            // 新增
            NSArray *creates = [changes elementsForName:@"t:Create"];
            NSMutableArray *createArray = [NSMutableArray array];
            for (GDataXMLElement *create in creates) {
                JDMailListModel *model = [[JDMailListModel alloc] init];
                GDataXMLElement *message = nil;
                GDataXMLElement *messageElement = [[create elementsForName:@"t:Message"] firstObject];
                GDataXMLElement *meetingRequest = [[create elementsForName:@"t:MeetingRequest"] firstObject];
                if (messageElement) {
                    message = messageElement;
                }
                if (meetingRequest) {
                    message = meetingRequest;
                }
                if (!message) {
                    continue;
                }
                GDataXMLElement *itemIdElement = [[message elementsForName:@"t:ItemId"] firstObject];
                GDataXMLNode *idNode = [itemIdElement attributeForName:@"Id"];
                GDataXMLNode *changeKeyNode = [itemIdElement attributeForName:@"ChangeKey"];
                model.itemId = [idNode stringValue];
                model.changeKey = [changeKeyNode stringValue];
                GDataXMLElement *parentFolderIdElement = [[message elementsForName:@"t:ParentFolderId"] firstObject];
                GDataXMLNode *parentIdNode = [parentFolderIdElement attributeForName:@"Id"];
                GDataXMLNode *parentChangeKeyNode = [parentFolderIdElement attributeForName:@"ChangeKey"];
                model.parentFolderId = [parentIdNode stringValue];
                model.parentChangeKey = [parentChangeKeyNode stringValue];
                GDataXMLElement *itemClassElement = [[message elementsForName:@"t:ItemClass"] firstObject];
                model.itemClass = [itemClassElement stringValue];
                GDataXMLElement *subjectElement = [[message elementsForName:@"t:Subject"] firstObject];
                model.subject = [subjectElement stringValue];
                GDataXMLElement *sensitivityElement = [[message elementsForName:@"t:Sensitivity"] firstObject];
                model.sensitivity = [sensitivityElement stringValue];
                GDataXMLElement *dateTimeReceivedElement = [[message elementsForName:@"t:DateTimeReceived"] firstObject];
                model.dateTimeReceived = [dateTimeReceivedElement stringValue];
                GDataXMLElement *sizeElement = [[message elementsForName:@"t:Size"] firstObject];
                model.size = [sizeElement stringValue];
                GDataXMLElement *importanceElement = [[message elementsForName:@"t:Importance"] firstObject];
                model.importance = [importanceElement stringValue];
                GDataXMLElement *inReplyToElement = [[message elementsForName:@"t:InReplyTo"] firstObject];
                model.inReplyTo = [inReplyToElement stringValue];
                GDataXMLElement *isSubmittedElement = [[message elementsForName:@"t:IsSubmitted"] firstObject];
                model.isSubmitted = [isSubmittedElement stringValue];
                GDataXMLElement *isDraftElement = [[message elementsForName:@"t:IsDraft"] firstObject];
                model.isDraft = [isDraftElement stringValue];
                GDataXMLElement *isFromMeElement = [[message elementsForName:@"t:IsFromMe"] firstObject];
                model.isFromMe = [isFromMeElement stringValue];
                GDataXMLElement *isResendElement = [[message elementsForName:@"t:IsResend"] firstObject];
                model.isResend = [isResendElement stringValue];
                GDataXMLElement *isUnmodifiedElement = [[message elementsForName:@"t:IsUnmodified"] firstObject];
                model.isUnmodified = [isUnmodifiedElement stringValue];
                GDataXMLElement *dateTimeSentElement = [[message elementsForName:@"t:DateTimeSent"] firstObject];
                model.dateTimeSent = [dateTimeSentElement stringValue];
                GDataXMLElement *dateTimeCreatedElement = [[message elementsForName:@"t:DateTimeCreated"] firstObject];
                model.dateTimeCreated = [dateTimeCreatedElement stringValue];
                GDataXMLElement *reminderIsSetElement = [[message elementsForName:@"t:ReminderIsSet"] firstObject];
                model.reminderIsSet = [reminderIsSetElement stringValue];
                GDataXMLElement *displayToElement = [[message elementsForName:@"t:DisplayTo"] firstObject];
                model.displayTo = [displayToElement stringValue];
                GDataXMLElement *hasAttachmentsElement = [[message elementsForName:@"t:HasAttachments"] firstObject];
                model.hasAttachments = [hasAttachmentsElement stringValue];
                GDataXMLElement *cultureElement = [[message elementsForName:@"t:Culture"] firstObject];
                model.culture = [cultureElement stringValue];
                GDataXMLElement *flagElement = [[message elementsForName:@"t:Flag"] firstObject];
                GDataXMLElement *flagStatusElement = [[flagElement elementsForName:@"t:FlagStatus"] firstObject];
                model.flagStatus = [flagStatusElement stringValue];
                GDataXMLElement *fromElement = [[message elementsForName:@"t:From"] firstObject];
                GDataXMLElement *mailboxElement = [[fromElement elementsForName:@"t:Mailbox"] firstObject];
                GDataXMLElement *nameElement = [[mailboxElement elementsForName:@"t:Name"] firstObject];
                GDataXMLElement *emailAddressElement = [[mailboxElement elementsForName:@"t:EmailAddress"] firstObject];
                GDataXMLElement *routingTypeElement = [[mailboxElement elementsForName:@"t:RoutingType"] firstObject];
                GDataXMLElement *mailboxTypeElement = [[mailboxElement elementsForName:@"t:MailboxType"] firstObject];
                JDMailPerson *person = [[JDMailPerson alloc] init];
                person.emailAddress = [emailAddressElement stringValue];
                person.name = [nameElement stringValue];
                person.routingType = [routingTypeElement stringValue];
                person.mailboxType = [mailboxTypeElement stringValue];
                model.from = person;
                GDataXMLElement *isReadElement = [[message elementsForName:@"t:IsRead"] firstObject];
                model.isRead = [isReadElement stringValue];
                [createArray addObject:model];
            }
            // 更新
            NSArray *updates = [changes elementsForName:@"t:Update"];
            NSMutableArray *updateArray = [NSMutableArray array];
            for (GDataXMLElement *update in updates) {
                JDMailListModel *model = [[JDMailListModel alloc] init];
                GDataXMLElement *message = nil;
                GDataXMLElement *messageElement = [[update elementsForName:@"t:Message"] firstObject];
                GDataXMLElement *meetingRequest = [[update elementsForName:@"t:MeetingRequest"] firstObject];
                if (messageElement) {
                    message = messageElement;
                }
                if (meetingRequest) {
                    message = meetingRequest;
                }
                if (!message) {
                    continue;
                }
                GDataXMLElement *itemIdElement = [[message elementsForName:@"t:ItemId"] firstObject];
                GDataXMLNode *idNode = [itemIdElement attributeForName:@"Id"];
                GDataXMLNode *changeKeyNode = [itemIdElement attributeForName:@"ChangeKey"];
                model.itemId = [idNode stringValue];
                model.changeKey = [changeKeyNode stringValue];
                GDataXMLElement *parentFolderIdElement = [[message elementsForName:@"t:ParentFolderId"] firstObject];
                GDataXMLNode *parentIdNode = [parentFolderIdElement attributeForName:@"Id"];
                GDataXMLNode *parentChangeKeyNode = [parentFolderIdElement attributeForName:@"ChangeKey"];
                model.parentFolderId = [parentIdNode stringValue];
                model.parentChangeKey = [parentChangeKeyNode stringValue];
                GDataXMLElement *itemClassElement = [[message elementsForName:@"t:ItemClass"] firstObject];
                model.itemClass = [itemClassElement stringValue];
                GDataXMLElement *subjectElement = [[message elementsForName:@"t:Subject"] firstObject];
                model.subject = [subjectElement stringValue];
                GDataXMLElement *sensitivityElement = [[message elementsForName:@"t:Sensitivity"] firstObject];
                model.sensitivity = [sensitivityElement stringValue];
                GDataXMLElement *dateTimeReceivedElement = [[message elementsForName:@"t:DateTimeReceived"] firstObject];
                model.dateTimeReceived = [dateTimeReceivedElement stringValue];
                GDataXMLElement *sizeElement = [[message elementsForName:@"t:Size"] firstObject];
                model.size = [sizeElement stringValue];
                GDataXMLElement *importanceElement = [[message elementsForName:@"t:Importance"] firstObject];
                model.importance = [importanceElement stringValue];
                GDataXMLElement *dateTimeSentElement = [[message elementsForName:@"t:DateTimeSent"] firstObject];
                model.dateTimeSent = [dateTimeSentElement stringValue];
                GDataXMLElement *dateTimeCreatedElement = [[message elementsForName:@"t:DateTimeCreated"] firstObject];
                model.dateTimeCreated = [dateTimeCreatedElement stringValue];
                GDataXMLElement *hasAttachmentsElement = [[message elementsForName:@"t:HasAttachments"] firstObject];
                model.hasAttachments = [hasAttachmentsElement stringValue];
                GDataXMLElement *flagElement = [[message elementsForName:@"t:Flag"] firstObject];
                GDataXMLElement *flagStatusElement = [[flagElement elementsForName:@"t:FlagStatus"] firstObject];
                model.flagStatus = [flagStatusElement stringValue];
                GDataXMLElement *fromElement = [[message elementsForName:@"t:From"] firstObject];
                GDataXMLElement *mailboxElement = [[fromElement elementsForName:@"t:Mailbox"] firstObject];
                GDataXMLElement *nameElement = [[mailboxElement elementsForName:@"t:Name"] firstObject];
                GDataXMLElement *emailAddressElement = [[mailboxElement elementsForName:@"t:EmailAddress"] firstObject];
                GDataXMLElement *routingTypeElement = [[mailboxElement elementsForName:@"t:RoutingType"] firstObject];
                GDataXMLElement *mailboxTypeElement = [[mailboxElement elementsForName:@"t:MailboxType"] firstObject];
                JDMailPerson *person = [[JDMailPerson alloc] init];
                person.emailAddress = [emailAddressElement stringValue];
                person.name = [nameElement stringValue];
                person.routingType = [routingTypeElement stringValue];
                person.mailboxType = [mailboxTypeElement stringValue];
                model.from = person;
                GDataXMLElement *isReadElement = [[message elementsForName:@"t:IsRead"] firstObject];
                model.isRead = [isReadElement stringValue];
                [updateArray addObject:model];
            }
            // 删除
            NSArray *deletes = [changes elementsForName:@"t:Delete"];
            NSMutableArray *deleteArray = [NSMutableArray array];
            for (GDataXMLElement *delete in deletes) {
                JDMailListModel *model = [[JDMailListModel alloc] init];
                GDataXMLElement *itemIdElement = [[delete elementsForName:@"t:ItemId"] firstObject];
                GDataXMLNode *idNode = [itemIdElement attributeForName:@"Id"];
                GDataXMLNode *changeKeyNode = [itemIdElement attributeForName:@"ChangeKey"];
                model.itemId = [idNode stringValue];
                model.changeKey = [changeKeyNode stringValue];
                [deleteArray addObject:model];
            }
            // 存储数据
            BOOL insertResult = NO;
            if (createArray.count) {
                insertResult = [[JDMailDBManager shareManager] insertEmailItemWithAccount:account folderId:folderId items:createArray];
            }else{
                insertResult = YES;
            }
            BOOL updateResult = NO;
            if (updateArray.count) {
                updateResult = [[JDMailDBManager shareManager] insertEmailItemWithAccount:account folderId:folderId items:updateArray];
            }else{
                updateResult = YES;
            }
            BOOL deleteResult = NO;
            if (deleteArray.count) {
                deleteResult = [[JDMailDBManager shareManager] deleteEmailItemWithAccount:account folderId:folderId items:deleteArray];
            }else{
                deleteResult = YES;
            }
            if (insertResult && updateResult && deleteResult) {
                GDataXMLElement *syncStateElement = [[syncFolderItemsResponseMessage elementsForName:@"m:SyncState"] firstObject];
                [[JDMailDBManager shareManager] updateFolderSyncState:[syncStateElement stringValue] account:account folderId:folderId];
                GDataXMLElement *includesLastItemInRange = [[syncFolderItemsResponseMessage elementsForName:@"m:IncludesLastItemInRange"] firstObject];
                BOOL includesLastItem = [[includesLastItemInRange stringValue] isEqualToString:@"true"];
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:createArray];
                [tempArray addObjectsFromArray:updateArray];
                if (tempArray.count) {
                    // 加载邮件详情
                    [strongSelf loadFolderItemContentWithAccount:account folderId:folderId folderChangeKey:folderChangeKey syncState:[syncStateElement stringValue] includesLastItem:includesLastItem items:tempArray success:success failure:failure];
                }else{
                    if (includesLastItem) {
                        // 没有下一页
                        NSLog(@"%@文件夹项目同步完成",account);
                        if (success) {
                            success();
                        }
                    }else{
                        // 有下一页
                        [strongSelf syncFolderItemsWithAccount:account folderId:folderId folderChangeKey:folderChangeKey syncState:[syncStateElement stringValue] success:success failure:failure];
                    }
                }
            }else{
                // 存储数据失败
                if (failure) {
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    [userInfo setValue:@"同步文件夹项目时数据库保存数据出错" forKey:@"msg"];
                    NSError *error = [NSError errorWithDomain:@"JD-Mail-Domain-Error" code:999 userInfo:userInfo];
                    failure(error);
                }
            }
        }else{
            // 请求失败
            if (failure) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:@"服务端报错" forKey:@"msg"];
                NSError *error = [NSError errorWithDomain:@"JD-Mail-Domain-Error" code:999 userInfo:userInfo];
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)loadFolderItemContentWithAccount:(NSString *)account
                                folderId:(NSString *)folderId
                         folderChangeKey:(NSString *)folderChangeKey
                               syncState:(NSString *)syncState
                        includesLastItem:(BOOL)includesLastItem
                                   items:(NSArray *)items
                                 success:(void (^)(void))success
                                 failure:(void (^)(NSError *error))failure
{
    NSMutableArray *tempList = [NSMutableArray array];
    for (JDMailListModel *model in items) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:model.itemId forKey:@"ItemId"];
        [dict setValue:model.changeKey forKey:@"ChangeKey"];
        [tempList addObject:dict];
    }
    
    NSString *getItemsString = [[JDMailMessageBuilder new] ewsSoapMessageGetItemWithItems:tempList includeMimeContent:@"false"];
    __weak JDMailSyncManager *weakSelf = self;
    [[JDNetworkManager shareManager] POSTWithAccount:account httpBodyString:getItemsString success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        __strong JDMailSyncManager *strongSelf = weakSelf;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *soapBody = [[rootElement elementsForName:@"s:Body"] firstObject];
        GDataXMLElement *getItemResponse = [[soapBody elementsForName:@"m:GetItemResponse"] firstObject];
        GDataXMLElement *responseMessages = [[getItemResponse elementsForName:@"m:ResponseMessages"] firstObject];
        NSArray *getItemResponseMessage = [responseMessages elementsForName:@"m:GetItemResponseMessage"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (GDataXMLElement *itemResponseMessage in getItemResponseMessage) {
            GDataXMLElement *responseCode = [[itemResponseMessage elementsForName:@"m:ResponseCode"] firstObject];
            if ([[responseCode stringValue] isEqualToString:@"NoError"]) {
                JDMailListModel *model = [[JDMailListModel alloc] init];
                GDataXMLElement *items = [[itemResponseMessage elementsForName:@"m:Items"] firstObject];
                GDataXMLElement *message = nil;
                GDataXMLElement *messageElement = [[items elementsForName:@"t:Message"] firstObject];
                GDataXMLElement *meetingRequest = [[items elementsForName:@"t:MeetingRequest"] firstObject];
                if (messageElement) {
                    message = messageElement;
                }
                if (meetingRequest) {
                    message = meetingRequest;
                }
                if (!message) {
                    continue;
                }
                GDataXMLElement *itemIdElement = [[message elementsForName:@"t:ItemId"] firstObject];
                GDataXMLNode *idNode = [itemIdElement attributeForName:@"Id"];
                GDataXMLNode *changeKeyNode = [itemIdElement attributeForName:@"ChangeKey"];
                NSString *itemId = [idNode stringValue];
                NSString *changeKey = [changeKeyNode stringValue];
                GDataXMLElement *parentFolderIdElement = [[message elementsForName:@"t:ParentFolderId"] firstObject];
                GDataXMLNode *parentIdNode = [parentFolderIdElement attributeForName:@"Id"];
                GDataXMLNode *parentChangeKeyNode = [parentFolderIdElement attributeForName:@"ChangeKey"];
                // Body
                GDataXMLElement *bodyElement = [[message elementsForName:@"t:Body"] firstObject];
                GDataXMLNode *bodyTypeNode = [bodyElement attributeForName:@"BodyType"];
                NSString *body = [bodyElement stringValue];
                NSString *bodyType = [bodyTypeNode stringValue];
                NSString *bodyString = nil;
                if ([bodyType.uppercaseString isEqualToString:@"HTML"]) {
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[body dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    NSString *tempString = [attributedString.string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    tempString = [tempString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bodyString = tempString;
                }else{
                    bodyString = body;
                }
                // ToRecipients
                GDataXMLElement *toElement = [[message elementsForName:@"t:ToRecipients"] firstObject];
                NSArray *toList = [toElement elementsForName:@"t:Mailbox"];
                NSMutableArray *toRecipients = [NSMutableArray array];
                for (GDataXMLElement *mailboxElement in toList) {
                    GDataXMLElement *nameElement = [[mailboxElement elementsForName:@"t:Name"] firstObject];
                    GDataXMLElement *emailAddressElement = [[mailboxElement elementsForName:@"t:EmailAddress"] firstObject];
                    GDataXMLElement *routingTypeElement = [[mailboxElement elementsForName:@"t:RoutingType"] firstObject];
                    GDataXMLElement *mailboxTypeElement = [[mailboxElement elementsForName:@"t:MailboxType"] firstObject];
                    JDMailPerson *person = [[JDMailPerson alloc] init];
                    person.emailAddress = [emailAddressElement stringValue];
                    person.name = [nameElement stringValue];
                    person.routingType = [routingTypeElement stringValue];
                    person.mailboxType = [mailboxTypeElement stringValue];
                    [toRecipients addObject:person];
                }
                // CcRecipients
                GDataXMLElement *ccElement = [[message elementsForName:@"t:CcRecipients"] firstObject];
                NSArray *ccList = [ccElement elementsForName:@"t:Mailbox"];
                NSMutableArray *ccRecipients = [NSMutableArray array];
                for (GDataXMLElement *mailboxElement in ccList) {
                    GDataXMLElement *nameElement = [[mailboxElement elementsForName:@"t:Name"] firstObject];
                    GDataXMLElement *emailAddressElement = [[mailboxElement elementsForName:@"t:EmailAddress"] firstObject];
                    GDataXMLElement *routingTypeElement = [[mailboxElement elementsForName:@"t:RoutingType"] firstObject];
                    GDataXMLElement *mailboxTypeElement = [[mailboxElement elementsForName:@"t:MailboxType"] firstObject];
                    JDMailPerson *person = [[JDMailPerson alloc] init];
                    person.emailAddress = [emailAddressElement stringValue];
                    person.name = [nameElement stringValue];
                    person.routingType = [routingTypeElement stringValue];
                    person.mailboxType = [mailboxTypeElement stringValue];
                    [ccRecipients addObject:person];
                }
                // Attachments
                GDataXMLElement *attachmentsElement = [[message elementsForName:@"t:Attachments"] firstObject];
                NSArray *attachmentList = [attachmentsElement elementsForName:@"t:FileAttachment"];
                NSMutableArray *attachments = [NSMutableArray array];
                for (GDataXMLElement *FileAttachmentElement in attachmentList) {
                    GDataXMLElement *attachmentIdElement = [[FileAttachmentElement elementsForName:@"t:AttachmentId"] firstObject];
                    GDataXMLNode *idNode = [attachmentIdElement attributeForName:@"Id"];
                    GDataXMLElement *nameElement = [[FileAttachmentElement elementsForName:@"t:Name"] firstObject];
                    GDataXMLElement *contentTypeElement = [[FileAttachmentElement elementsForName:@"t:ContentType"] firstObject];
                    GDataXMLElement *contentIdElement = [[FileAttachmentElement elementsForName:@"t:ContentId"] firstObject];
                    GDataXMLElement *contentIsInline = [[FileAttachmentElement elementsForName:@"t:IsInline"] firstObject];
                    GDataXMLElement *contentSize = [[FileAttachmentElement elementsForName:@"t:Size"] firstObject];
                    JDMailAttachment *attachment = [[JDMailAttachment alloc] init];
                    attachment.attachmentId = [idNode stringValue];
                    attachment.name = [nameElement stringValue];
                    attachment.contentType = [contentTypeElement stringValue];
                    attachment.contentId = [contentIdElement stringValue];
                    attachment.isInline = [contentIsInline stringValue];
                    attachment.size = [contentSize stringValue];
                    [attachments addObject:attachment];
                }
                // 一一赋值
                model.itemId = itemId;
                model.changeKey = changeKey;
                model.parentFolderId = [parentIdNode stringValue];
                model.parentChangeKey = [parentChangeKeyNode stringValue];
                model.body = body;
                model.bodyType = bodyType;
                model.bodyString = bodyString;
                model.toRecipients = toRecipients;
                model.ccRecipients = ccRecipients;
                model.attachments = attachments;
                [tempArray addObject:model];
            }
        }
        [[JDMailDBManager shareManager] insertEmailContentWithAccount:account folderId:folderId items:tempArray];
        if (includesLastItem) {
            // 没有下一页
            NSLog(@"%@文件夹项目同步完成",account);
            if (success) {
                success();
            }
        }else{
            // 有下一页
            [strongSelf syncFolderItemsWithAccount:account folderId:folderId folderChangeKey:folderChangeKey syncState:syncState success:success failure:failure];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        __strong JDMailSyncManager *strongSelf = weakSelf;
        NSLog(@"失败%@",error);
        if (includesLastItem) {
            // 没有下一页
            NSLog(@"%@文件夹项目同步完成",account);
            if (success) {
                success();
            }
        }else{
            // 有下一页
            [strongSelf syncFolderItemsWithAccount:account folderId:folderId folderChangeKey:folderChangeKey syncState:syncState success:success failure:failure];
        }
    }];
}

- (void)updateFolderItemContentWithAccount:(NSString *)account
                                  folderId:(NSString *)folderId
                                     items:(NSArray *)items
                                   success:(void (^)(void))success
                                   failure:(void (^)(NSError *error))failure
{
    NSString *getItemsString = [[JDMailMessageBuilder new] ewsSoapMessageGetItemWithItems:items includeMimeContent:@"false"];
    [[JDNetworkManager shareManager] POSTWithAccount:account httpBodyString:getItemsString success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *soapBody = [[rootElement elementsForName:@"s:Body"] firstObject];
        GDataXMLElement *getItemResponse = [[soapBody elementsForName:@"m:GetItemResponse"] firstObject];
        GDataXMLElement *responseMessages = [[getItemResponse elementsForName:@"m:ResponseMessages"] firstObject];
        NSArray *getItemResponseMessage = [responseMessages elementsForName:@"m:GetItemResponseMessage"];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (GDataXMLElement *itemResponseMessage in getItemResponseMessage) {
            GDataXMLElement *responseCode = [[itemResponseMessage elementsForName:@"m:ResponseCode"] firstObject];
            if ([[responseCode stringValue] isEqualToString:@"NoError"]) {
                JDMailListModel *model = [[JDMailListModel alloc] init];
                GDataXMLElement *items = [[itemResponseMessage elementsForName:@"m:Items"] firstObject];
                GDataXMLElement *message = nil;
                GDataXMLElement *messageElement = [[items elementsForName:@"t:Message"] firstObject];
                GDataXMLElement *meetingRequest = [[items elementsForName:@"t:MeetingRequest"] firstObject];
                if (messageElement) {
                    message = messageElement;
                }
                if (meetingRequest) {
                    message = meetingRequest;
                }
                if (!message) {
                    continue;
                }
                GDataXMLElement *itemIdElement = [[message elementsForName:@"t:ItemId"] firstObject];
                GDataXMLNode *idNode = [itemIdElement attributeForName:@"Id"];
                GDataXMLNode *changeKeyNode = [itemIdElement attributeForName:@"ChangeKey"];
                NSString *itemId = [idNode stringValue];
                NSString *changeKey = [changeKeyNode stringValue];
                GDataXMLElement *parentFolderIdElement = [[message elementsForName:@"t:ParentFolderId"] firstObject];
                GDataXMLNode *parentIdNode = [parentFolderIdElement attributeForName:@"Id"];
                GDataXMLNode *parentChangeKeyNode = [parentFolderIdElement attributeForName:@"ChangeKey"];
                // Body
                GDataXMLElement *bodyElement = [[message elementsForName:@"t:Body"] firstObject];
                GDataXMLNode *bodyTypeNode = [bodyElement attributeForName:@"BodyType"];
                NSString *body = [bodyElement stringValue];
                NSString *bodyType = [bodyTypeNode stringValue];
                NSString *bodyString = nil;
                if ([bodyType.uppercaseString isEqualToString:@"HTML"]) {
                    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[body dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                    NSString *tempString = [attributedString.string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                    tempString = [tempString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                    bodyString = tempString;
                }else{
                    bodyString = body;
                }
                // ToRecipients
                GDataXMLElement *toElement = [[message elementsForName:@"t:ToRecipients"] firstObject];
                NSArray *toList = [toElement elementsForName:@"t:Mailbox"];
                NSMutableArray *toRecipients = [NSMutableArray array];
                for (GDataXMLElement *mailboxElement in toList) {
                    GDataXMLElement *nameElement = [[mailboxElement elementsForName:@"t:Name"] firstObject];
                    GDataXMLElement *emailAddressElement = [[mailboxElement elementsForName:@"t:EmailAddress"] firstObject];
                    GDataXMLElement *routingTypeElement = [[mailboxElement elementsForName:@"t:RoutingType"] firstObject];
                    GDataXMLElement *mailboxTypeElement = [[mailboxElement elementsForName:@"t:MailboxType"] firstObject];
                    JDMailPerson *person = [[JDMailPerson alloc] init];
                    person.emailAddress = [emailAddressElement stringValue];
                    person.name = [nameElement stringValue];
                    person.routingType = [routingTypeElement stringValue];
                    person.mailboxType = [mailboxTypeElement stringValue];
                    [toRecipients addObject:person];
                }
                // CcRecipients
                GDataXMLElement *ccElement = [[message elementsForName:@"t:CcRecipients"] firstObject];
                NSArray *ccList = [ccElement elementsForName:@"t:Mailbox"];
                NSMutableArray *ccRecipients = [NSMutableArray array];
                for (GDataXMLElement *mailboxElement in ccList) {
                    GDataXMLElement *nameElement = [[mailboxElement elementsForName:@"t:Name"] firstObject];
                    GDataXMLElement *emailAddressElement = [[mailboxElement elementsForName:@"t:EmailAddress"] firstObject];
                    GDataXMLElement *routingTypeElement = [[mailboxElement elementsForName:@"t:RoutingType"] firstObject];
                    GDataXMLElement *mailboxTypeElement = [[mailboxElement elementsForName:@"t:MailboxType"] firstObject];
                    JDMailPerson *person = [[JDMailPerson alloc] init];
                    person.emailAddress = [emailAddressElement stringValue];
                    person.name = [nameElement stringValue];
                    person.routingType = [routingTypeElement stringValue];
                    person.mailboxType = [mailboxTypeElement stringValue];
                    [ccRecipients addObject:person];
                }
                // Attachments
                GDataXMLElement *attachmentsElement = [[message elementsForName:@"t:Attachments"] firstObject];
                NSArray *attachmentList = [attachmentsElement elementsForName:@"t:FileAttachment"];
                NSMutableArray *attachments = [NSMutableArray array];
                for (GDataXMLElement *FileAttachmentElement in attachmentList) {
                    GDataXMLElement *attachmentIdElement = [[FileAttachmentElement elementsForName:@"t:AttachmentId"] firstObject];
                    GDataXMLNode *idNode = [attachmentIdElement attributeForName:@"Id"];
                    GDataXMLElement *nameElement = [[FileAttachmentElement elementsForName:@"t:Name"] firstObject];
                    GDataXMLElement *contentTypeElement = [[FileAttachmentElement elementsForName:@"t:ContentType"] firstObject];
                    GDataXMLElement *contentIdElement = [[FileAttachmentElement elementsForName:@"t:ContentId"] firstObject];
                    GDataXMLElement *contentIsInline = [[FileAttachmentElement elementsForName:@"t:IsInline"] firstObject];
                    GDataXMLElement *contentSize = [[FileAttachmentElement elementsForName:@"t:Size"] firstObject];
                    JDMailAttachment *attachment = [[JDMailAttachment alloc] init];
                    attachment.attachmentId = [idNode stringValue];
                    attachment.name = [nameElement stringValue];
                    attachment.contentType = [contentTypeElement stringValue];
                    attachment.contentId = [contentIdElement stringValue];
                    attachment.isInline = [contentIsInline stringValue];
                    attachment.size = [contentSize stringValue];
                    [attachments addObject:attachment];
                }
                // 一一赋值
                model.itemId = itemId;
                model.changeKey = changeKey;
                model.parentFolderId = [parentIdNode stringValue];
                model.parentChangeKey = [parentChangeKeyNode stringValue];
                model.body = body;
                model.bodyType = bodyType;
                model.bodyString = bodyString;
                model.toRecipients = toRecipients;
                model.ccRecipients = ccRecipients;
                model.attachments = attachments;
                [tempArray addObject:model];
            }
        }
        [[JDMailDBManager shareManager] insertEmailContentWithAccount:account folderId:folderId items:tempArray];
        NSLog(@"%@文件夹项目同步完成",account);
        if (success) {
            success();
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"失败%@",error);
        if (failure) {
            failure(error);
        }
    }];
}

@end
