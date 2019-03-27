
//
//  JDAppointmentBuilder.m
//  JDMail
//
//  Created by 千阳 on 2019/3/20.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDAppointmentMessageBuilder.h"

@implementation JDAppointmentMessageBuilder

- (NSString *)ewsSoapMessageWithSoapHeader:(NSString *)soapHeader soapBody:(NSString *)soapBody
{
   NSString *message = [super ewsSoapMessageWithSoapHeader:soapHeader soapBody:soapBody];
    return message;
}

@end
