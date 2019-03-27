//
//  JDAppDBManager.h
//  JDMail
//
//  Created by 公司 on 2019/3/1.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JDAccount;

@interface JDAppDBManager : NSObject

/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager;

- (BOOL)insertOrReplaceAccount:(JDAccount *)account;

- (BOOL)updatefolderSyncState:(NSString *)syncState account:(NSString *)account;

- (BOOL)deleteAccount:(NSString *)account;

- (NSArray *)queryAllAccount;

- (NSString *)queryfolderSyncStateWithAccount:(NSString *)account;

- (NSArray *)queryAllfolderSyncState;

@end

NS_ASSUME_NONNULL_END
