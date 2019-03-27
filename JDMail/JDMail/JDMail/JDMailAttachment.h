//
//  JDMailAttachment.h
//  JDMail
//
//  Created by 公司 on 2019/2/28.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMailAttachment : NSObject

@property (nonatomic, copy) NSString *attachmentId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, readonly, copy) NSString *sizeStr;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *isInline;

@end

NS_ASSUME_NONNULL_END
