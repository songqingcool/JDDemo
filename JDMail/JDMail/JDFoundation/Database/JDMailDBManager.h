//
//  JDMailDBManager.h
//  JDMail
//
//  Created by 千阳 on 2019/3/14.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMailDBManager : NSObject

+ (instancetype)shareManager;

- (void)registerEmailDBWithCurrentAccount:(NSString *)account;

#pragma mark - Folder

- (BOOL)insertFolderWithAccount:(NSString *)account
                    folderArray:(NSArray *)folderArray;

- (BOOL)deleteFolderWithAccount:(NSString *)account
                    folderArray:(NSArray *)folderArray;

- (NSArray *)queryFolderWithAccount:(NSString *)account;

- (NSString *)queryFolderSyncStateWithAccount:(NSString *)account
                                     folderId:(NSString *)folderId;

- (BOOL)updateFolderSyncState:(NSString *)syncState
                      account:(NSString *)account
                     folderId:(NSString *)folderId;

#pragma mark - Mail

- (BOOL)insertEmailItemWithAccount:(NSString *)account
                          folderId:(NSString *)folderId
                             items:(NSArray *)items;

- (BOOL)deleteEmailItemWithAccount:(NSString *)account
                          folderId:(NSString *)folderId
                             items:(NSArray *)items;

- (NSArray *)queryEmailItemWithAccount:(NSString *)account
                              folderId:(NSString *)folderId
                      lastReceivedTime:(NSString *)lastReceivedTime
                              pageSize:(NSString *)pageSize;

#pragma mark - MailContent

- (BOOL)insertEmailContentWithAccount:(NSString *)account
                             folderId:(NSString *)folderId
                                items:(NSArray *)items;

- (BOOL)deleteEmailContentWithAccount:(NSString *)account
                             folderId:(NSString *)folderId
                                items:(NSArray *)items;

@end

NS_ASSUME_NONNULL_END
