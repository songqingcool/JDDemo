//
//  JDMailPerson.h
//  JDMail
//
//  Created by 公司 on 2019/2/28.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMailPerson : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *routingType;
@property (nonatomic, copy) NSString *mailboxType;

@end

NS_ASSUME_NONNULL_END
