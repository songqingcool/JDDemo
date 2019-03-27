//
//  JDAccount.h
//  JDMail
//
//  Created by 公司 on 2019/2/22.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDAccount : NSObject

// 昵称
@property (nonatomic, copy) NSString *nickName;
// 头像
@property (nonatomic, copy) NSString *avatar;
// 账号
@property (nonatomic, copy) NSString *account;
// 密码
@property (nonatomic, copy) NSString *password;
// 服务器
@property (nonatomic, copy) NSString *server;
// 域
@property (nonatomic, copy) NSString *domain;
// 用户名
@property (nonatomic, copy) NSString *userName;

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

@end

NS_ASSUME_NONNULL_END
