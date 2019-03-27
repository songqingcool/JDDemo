//
//  JDSendEmailModel.h
//  JDMail
//
//  Created by 千阳 on 2019/3/1.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JDMailPerson;

typedef enum : NSUInteger {
    EmailSendNormal = 1,
    EmailReply = 2,
    EmailForwarding = 3,
} EmailSendType;

NS_ASSUME_NONNULL_BEGIN

@interface JDSendEmailModel : NSObject

@property(nonatomic,assign)EmailSendType emialSendType;
@property(nonatomic,copy)NSString *subject;
@property(nonatomic,copy)NSString *body;
@property (nonatomic, strong) NSArray *toRecipients;
@property (nonatomic, strong) NSArray *ccRecipients;
@property (nonatomic,strong)NSArray *attachments;
@property(nonatomic,strong)JDMailPerson *from;

@property (nonatomic,copy) NSString *emailItemId;
@property (nonatomic,copy)NSString *changeKey;

@end

NS_ASSUME_NONNULL_END
