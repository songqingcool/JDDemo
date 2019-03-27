//
//  JDMailMessageBuilder.h
//  JDDemo
//
//  Created by 公司 on 2019/2/19.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JDMailMessage;
@class JDContactMessage;


@interface JDMailMessageBuilder : NSObject

#pragma mark - soap请求拼接
- (NSString *)ewsSoapMessageWithSoapHeader:(NSString *)soapHeader soapBody:(NSString *)soapBody;
- (NSString *)ewsSoapMessageWithBodyString:(NSString *)bodyString;

#pragma mark - soap Header拼接
- (NSString *)ewsSoapHeaderWithVersion:(NSString *)version;

- (NSString *)ewsDefaultSoapHeader;

#pragma mark - soap Body拼接
- (NSString *)ewsSoapBodyWithBodyString:(NSString *)bodyString;

#pragma mark - 获取文件夹层次结构
// 获取文件夹层次结构   inbox drafts sentitems deleteditems junkemail
- (NSString *)ewsSoapMessageGetFolderWithFolders:(NSArray *)folders;

// 同步文件夹层次
- (NSString *)ewsSoapMessageSyncFolderHierarchyWithSyncState:(NSString *)syncState;

// 同步邮件夹中的项目
- (NSString *)ewsSoapMessageSyncFolderItemsWithFolderId:(NSString *)folderId
                                        folderChangeKey:(NSString *)folderChangeKey
                                  distinguishedFolderId:(NSString *)distinguishedFolderId
                                              syncState:(NSString *)syncState
                                     maxChangesReturned:(NSString *)maxChangesReturned
                                              syncScope:(NSString *)syncScope;

#pragma mark - 发送邮件

/// 新建电子邮件
- (NSString *)ewsSoapMessageCreateItemWithMessage:(JDMailMessage *)message;

///回复电子邮件
- (NSString *)ewsSoapMessageReplyAll:(JDMailMessage *)message;

///转发电子邮件
- (NSString *)ewsSoapMessageForwardEmail:(JDMailMessage *)message;

// 查找某个文件夹下的电子邮件列表
- (NSString *)ewsSoapMessageFindItemWithFolder:(NSString *)folder maxEntriesReturned:(NSString *)maxEntriesReturned offset:(NSString *)offset;

// 查找某几个电子邮件
- (NSString *)ewsSoapMessageGetItemWithItems:(NSArray *)items includeMimeContent:(NSString *)includeMimeContent;

///通过邮件ID删除邮件
- (NSString *)ewsSoapMessageDeleteEmailsByItems:(NSArray *)ItemIds;

#pragma mark  - 附件
///获取附件信息
- (NSString *)ewsSoapMessageEmailAttachment:(NSArray *)attachmentIds;

#pragma mark - 联系人
// 新建联系人
- (NSString *)ewsSoapMessageContactCreateItemWithMessage:(JDContactMessage *)message;

#pragma mark - 日历
///创建约会
- (NSString *)ewsSoapMessageCreateAppoinment;
 
@end

NS_ASSUME_NONNULL_END
