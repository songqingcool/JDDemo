
//
//  JDAttachmentManager.m
//  JDMail
//
//  Created by 千阳 on 2019/3/6.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDAttachmentManager.h"
#import "JDMailAttachment.h"
#import "JDNetworkManager.h"
#import "GDataXMLNode.h"
#import "JDMailMessageBuilder.h"
#import "JDAccountManager.h"
#import "JDAccount.h"

@implementation JDAttachmentManager

+ (instancetype)shareManager
{
    static JDAttachmentManager * attachmentManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        attachmentManager = [[JDAttachmentManager alloc] init];
    });
    return attachmentManager;
}

-(void)getAttachments:(NSArray *)attachmentIds success:(void(^)(NSArray *attachments))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableArray *attachmentArray = [NSMutableArray new];
    if(attachmentIds.count)
    {
        for (JDMailAttachment *attachment in attachmentIds) {
            
            [attachmentArray addObject:attachment.attachmentId];
            
        }
        
        NSString *getAttachmentXml = [[JDMailMessageBuilder new] ewsSoapMessageEmailAttachment:attachmentArray];
        
        [[JDNetworkManager shareManager] POSTWithAccount:[JDAccountManager shareManager].currentAccount.account httpBodyString:getAttachmentXml success:^(NSURLSessionDataTask *task, NSData *responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableArray *attachments = [NSMutableArray new];
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
                GDataXMLElement *rootElement = [document rootElement];
                GDataXMLElement *soapBody = [[rootElement elementsForName:@"s:Body"] firstObject];
                GDataXMLElement *getItemResponse = [[soapBody elementsForName:@"m:GetAttachmentResponse"] firstObject];
                GDataXMLElement *responseMessages = [[getItemResponse elementsForName:@"m:ResponseMessages"] firstObject];
                
                NSArray *responseGetAttachmentResponseMessageArray = [responseMessages elementsForName:@"m:GetAttachmentResponseMessage"];
                
                for (GDataXMLElement *element in responseGetAttachmentResponseMessageArray) {
                    GDataXMLElement *responseCode = [[element elementsForName:@"m:ResponseCode"] firstObject];
                    if([[responseCode stringValue] isEqualToString:@"NoError"])
                    {
                        GDataXMLElement *Attachments = [[element elementsForName:@"m:Attachments"] firstObject];
                        GDataXMLElement *FileAttachment = [[Attachments elementsForName:@"t:FileAttachment"] firstObject];
                        NSString *conttent = [[[FileAttachment elementsForName:@"t:Content"] firstObject] stringValue];
                        GDataXMLElement *AttachmentId =  [[FileAttachment elementsForName:@"t:AttachmentId"] firstObject];
                        GDataXMLNode *attachmentIdNode = [AttachmentId attributeForName:@"Id"];
                        NSString *attachmentId = [attachmentIdNode stringValue];
                        
                        JDMailAttachment *attachment = [self fillAttachment:attachmentIds content:conttent withId:attachmentId];
                        
                        [attachments addObject:attachment];
                        
                    }
                    else
                        continue;
                    
                }
                
                success(attachments);
                
            });
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            failure(task,error);
            
        }];
    }
}

- (JDMailAttachment *)fillAttachment:(NSArray *)attachments content:(NSString *)content withId:(NSString *)attachmentId
{
    JDMailAttachment *result = nil;
    if(attachments.count)
    {
        for (JDMailAttachment *attachment in attachments) {
            
            if([attachment.attachmentId isEqualToString:attachmentId])
            {
                attachment.content = content;
                result = attachment;
                break;
            }
        }
    }
    return result;
}

@end
