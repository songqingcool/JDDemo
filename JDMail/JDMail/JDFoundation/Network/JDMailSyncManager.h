//
//  JDMailSyncManager.h
//  JDMail
//
//  Created by 公司 on 2019/3/13.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMailSyncManager : NSObject

/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager;

- (void)syncFolderHierarchyWithAccount:(NSString *)account
                             syncState:(NSString *)syncState
                               success:(void (^)(void))success
                               failure:(void (^)(NSError *error))failure;

- (void)syncFolderItemsWithAccount:(NSString *)account
                          folderId:(NSString *)folderId
                   folderChangeKey:(NSString *)folderChangeKey
                         syncState:(NSString *)syncState
                           success:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure;

- (void)updateFolderItemContentWithAccount:(NSString *)account
                                  folderId:(NSString *)folderId
                                     items:(NSArray *)items
                                   success:(void (^)(void))success
                                   failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
