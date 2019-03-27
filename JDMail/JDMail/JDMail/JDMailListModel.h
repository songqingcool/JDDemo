//
//  JDMailListModel.h
//  JDMail
//
//  Created by 公司 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JDMailPerson;

@interface JDMailListModel : NSObject

//
@property (nonatomic, copy) NSString *itemId;
//
@property (nonatomic, copy) NSString *changeKey;
//
@property (nonatomic, copy) NSString *parentFolderId;
//
@property (nonatomic, copy) NSString *parentChangeKey;
//
@property (nonatomic, copy) NSString *itemClass;
// 主题
@property (nonatomic, copy) NSString *subject;
//
@property (nonatomic, copy) NSString *sensitivity;
//
@property (nonatomic, copy) NSString *dateTimeReceived;
//
@property (nonatomic, copy) NSString *size;
//
@property (nonatomic, copy) NSString *importance;
//
@property (nonatomic, copy) NSString *inReplyTo;
@property (nonatomic, copy) NSString *isSubmitted;
@property (nonatomic, copy) NSString *isDraft;
@property (nonatomic, copy) NSString *isFromMe;
@property (nonatomic, copy) NSString *isResend;
@property (nonatomic, copy) NSString *isUnmodified;
@property (nonatomic, copy) NSString *dateTimeSent;
@property (nonatomic, copy) NSString *dateTimeCreated;
@property (nonatomic, copy) NSString *reminderIsSet;
@property (nonatomic, copy) NSString *displayTo;
@property (nonatomic, copy) NSString *hasAttachments;
@property (nonatomic, copy) NSString *culture;
@property (nonatomic, copy) NSString *flagStatus;
@property (nonatomic, strong) JDMailPerson *from;
@property (nonatomic, copy) NSString *isRead;

#pragma mark - 详情页数据
// Best  Text  HTML
@property (nonatomic, copy) NSString *bodyType;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *bodyString;

@property (nonatomic, strong) NSArray *toRecipients;
@property (nonatomic, strong) NSArray *ccRecipients;
@property (nonatomic, strong) NSArray *attachments;

@end

NS_ASSUME_NONNULL_END
