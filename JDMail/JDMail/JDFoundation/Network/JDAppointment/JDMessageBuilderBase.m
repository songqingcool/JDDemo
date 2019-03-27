
//
//  JDMessageBuilderBase.m
//  JDMail
//
//  Created by 千阳 on 2019/3/20.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDMessageBuilderBase.h"

@implementation JDMessageBuilderBase

- (NSString *)ewsSoapMessageWithSoapHeader:(NSString *)soapHeader soapBody:(NSString *)soapBody
{
    NSString *retString = @"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:m=\"http://schemas.microsoft.com/exchange/services/2006/messages\" xmlns:t=\"http://schemas.microsoft.com/exchange/services/2006/types\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">";
    retString = [retString stringByAppendingString:soapHeader];
    retString = [retString stringByAppendingString:soapBody];
    retString = [retString stringByAppendingString:@"</soap:Envelope>"];
    return retString;
}

- (NSString *)ewsSoapMessageWithBodyString:(NSString *)bodyString
{
    NSString *soapHeaderString = [self ewsDefaultSoapHeader];
    NSString *soapBodyString = [self ewsSoapBodyWithBodyString:bodyString];
    return [self ewsSoapMessageWithSoapHeader:soapHeaderString soapBody:soapBodyString];
}

#pragma mark - soap Header拼接

- (NSString *)ewsSoapHeaderWithVersion:(NSString *)version
{
    NSString *retString = [NSString stringWithFormat:@"<soap:Header><t:RequestServerVersion Version=\"%@\" /></soap:Header>",version];
    return retString;
}

- (NSString *)ewsDefaultSoapHeader
{
    return [self ewsSoapHeaderWithVersion:@"Exchange2013_SP1"];
}

#pragma mark - soap Body拼接

- (NSString *)ewsSoapBodyWithBodyString:(NSString *)bodyString
{
    NSString *retString = @"<soap:Body>";
    retString = [retString stringByAppendingString:bodyString];
    retString = [retString stringByAppendingString:@"</soap:Body>"];
    return retString;
}


@end
