//
//  JDMessageBuilderBase.h
//  JDMail
//
//  Created by 千阳 on 2019/3/20.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMessageBuilderBase : NSObject

- (NSString *)ewsSoapMessageWithSoapHeader:(NSString *)soapHeader soapBody:(NSString *)soapBody;

@end

NS_ASSUME_NONNULL_END
