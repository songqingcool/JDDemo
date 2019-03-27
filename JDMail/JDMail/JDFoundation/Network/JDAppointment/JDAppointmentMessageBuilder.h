//
//  JDAppointmentBuilder.h
//  JDMail
//
//  Created by 千阳 on 2019/3/20.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDMessageBuilderBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDAppointmentMessageBuilder : JDMessageBuilderBase

- (NSString *)ewsSoapMessageWithSoapHeader:(NSString *)soapHeader soapBody:(NSString *)soapBody;

@end

NS_ASSUME_NONNULL_END
