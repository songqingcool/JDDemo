//
//  JDMailMessage.h
//  JDMail
//
//  Created by 公司 on 2019/2/19.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMailMessage : NSObject

// SaveOnly  SendOnly  SendAndSaveCopy
@property (nonatomic, copy) NSString *messageDisposition;
// sentitems
@property (nonatomic, copy) NSString *distinguishedFolderId;
// 收件人
@property (nonatomic, strong) NSArray *toRecipients;
// 抄送
@property (nonatomic, strong) NSArray *ccRecipients;
// 密送
@property (nonatomic, strong) NSArray *bccRecipients;
// 主题
@property (nonatomic, copy) NSString *subject;
// Best  Text  HTML
@property (nonatomic, copy) NSString *bodyType;
@property (nonatomic, copy) NSString *body;


@property (nonatomic, copy) NSString *emailItemId;
@property (nonatomic, copy) NSString *changeKey;
///附件
@property (nonatomic, strong) NSArray *emailAttachmentArray;

@end

NS_ASSUME_NONNULL_END
