//
//  JDAttachmentManager.h
//  JDMail
//
//  Created by 千阳 on 2019/3/6.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDAttachmentManager : NSObject

+ (instancetype)shareManager;

- (void)getAttachments:(NSArray *)attachmentIds success:(void(^)(NSArray *attachments))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
