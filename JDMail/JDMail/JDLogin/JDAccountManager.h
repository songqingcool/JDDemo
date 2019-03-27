//
//  JDAccountManager.h
//  JDMail
//
//  Created by 公司 on 2019/2/22.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JDAccount;

@interface JDAccountManager : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *accountsArray;
// 当前账号
@property (nonatomic, strong, readonly) JDAccount *currentAccount;

/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager;

// 重新加载本地的账号
- (void)reloadLocalAccounts;
// 更改当前账号
- (void)changeCurrentAccount:(JDAccount *)account;
// 添加新账号
- (void)addNewAccount:(JDAccount *)account;

@end

NS_ASSUME_NONNULL_END
