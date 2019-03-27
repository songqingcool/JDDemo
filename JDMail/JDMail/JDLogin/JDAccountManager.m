//
//  JDAccountManager.m
//  JDMail
//
//  Created by 公司 on 2019/2/22.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDAccountManager.h"
#import "JDAccount.h"
#import "JDNetworkManager.h"
#import "JDAppDBManager.h"
#import "JDMailDBManager.h"

@interface JDAccountManager ()

@end

@implementation JDAccountManager

@synthesize accountsArray=_accountsArray;
@synthesize currentAccount=_currentAccount;

/**
 *  单例方法
 *
 *  @return 实例对象
 */

+ (instancetype)shareManager {
    static JDAccountManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reloadLocalAccounts];
        if (self.accountsArray.count) {
            [self changeCurrentAccount:self.accountsArray.firstObject];
        }
    }
    return self;
}

// 重新加载本地的账号
- (void)reloadLocalAccounts
{
    NSArray *accountList = [[JDAppDBManager shareManager] queryAllAccount];
    [self.accountsArray addObjectsFromArray:accountList];
}

// 更改当前账号
- (void)changeCurrentAccount:(JDAccount *)account
{
    _currentAccount = account;
    // 调整网络会话
    [[JDNetworkManager shareManager] registerSoapManagerWithAccount:account.account userName:account.userName password:account.password];
    // 切换邮件数据库
    [[JDMailDBManager shareManager] registerEmailDBWithCurrentAccount:account.account];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentAccountDidChanage" object:nil];
}

- (void)addNewAccount:(JDAccount *)account
{
    if (!account) {
        return;
    }
    
    [self.accountsArray addObject:account];
    [[JDAppDBManager shareManager] insertOrReplaceAccount:account];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountDidChanage" object:nil];
}

#pragma mark - Getter

- (NSMutableArray *)accountsArray
{
    if (!_accountsArray) {
        _accountsArray = [NSMutableArray array];
    }
    return _accountsArray;
}

@end
