//
//  JDMailMessageBuilder.m
//  JDDemo
//
//  Created by 公司 on 2019/2/19.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDMailMessageBuilder.h"
#import "JDMailMessage.h"
#import "JDContactMessage.h"
#import "JDMailAttachment.h"

@implementation JDMailMessageBuilder

#pragma mark - soap请求拼接

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

#pragma mark - 获取文件夹层次结构
// 获取文件夹层次结构
- (NSString *)ewsSoapMessageGetFolderWithFolders:(NSArray *)folders
{
    NSString *bodyString = @"<m:GetFolder>";
    bodyString = [bodyString stringByAppendingString:@"<m:FolderShape>"];
    bodyString = [bodyString stringByAppendingString:@"<t:BaseShape>Default</t:BaseShape>"];
    bodyString = [bodyString stringByAppendingString:@"</m:FolderShape>"];
    bodyString = [bodyString stringByAppendingString:@"<m:FolderIds>"];
    for (NSString *folderString in folders) {
        NSString *xmlFolderString = [NSString stringWithFormat:@"<t:DistinguishedFolderId Id=\"%@\" />",folderString];
        bodyString = [bodyString stringByAppendingString:xmlFolderString];
    }
    bodyString = [bodyString stringByAppendingString:@"</m:FolderIds>"];
    bodyString = [bodyString stringByAppendingString:@"</m:GetFolder>"];
    return [self ewsSoapMessageWithBodyString:bodyString];
}

// 同步文件夹层次
- (NSString *)ewsSoapMessageSyncFolderHierarchyWithSyncState:(NSString *)syncState
{
    NSString *bodyString = @"<m:SyncFolderHierarchy>";
    bodyString = [bodyString stringByAppendingString:@"<m:FolderShape>"];
    bodyString = [bodyString stringByAppendingString:@"<t:BaseShape>AllProperties</t:BaseShape>"];
    bodyString = [bodyString stringByAppendingString:@"</m:FolderShape>"];
    bodyString = [bodyString stringByAppendingString:@"<m:SyncFolderId><t:DistinguishedFolderId Id=\"msgfolderroot\" /></m:SyncFolderId>"];
    if (syncState.length) {
        bodyString = [bodyString stringByAppendingFormat:@"<m:SyncState>%@</m:SyncState>",syncState];
    }
    bodyString = [bodyString stringByAppendingString:@"</m:SyncFolderHierarchy>"];
    return [self ewsSoapMessageWithBodyString:bodyString];
}

// 同步邮件夹中的项目
- (NSString *)ewsSoapMessageSyncFolderItemsWithFolderId:(NSString *)folderId
                                        folderChangeKey:(NSString *)folderChangeKey
                                  distinguishedFolderId:(NSString *)distinguishedFolderId
                                              syncState:(NSString *)syncState
                                     maxChangesReturned:(NSString *)maxChangesReturned
                                              syncScope:(NSString *)syncScope
{
    if (!((folderId.length != 0 && folderChangeKey.length != 0)|| distinguishedFolderId.length != 0) || maxChangesReturned.length == 0 || syncScope.length == 0) {
        return nil;
    }
    
    NSString *bodyString = @"<m:SyncFolderItems>";
    bodyString = [bodyString stringByAppendingString:@"<m:ItemShape>"];
    bodyString = [bodyString stringByAppendingString:@"<t:BaseShape>AllProperties</t:BaseShape>"];
    bodyString = [bodyString stringByAppendingString:@"</m:ItemShape>"];
    bodyString = [bodyString stringByAppendingString:@"<m:SyncFolderId>"];
    if (distinguishedFolderId.length) {
        bodyString = [bodyString stringByAppendingFormat:@"<t:DistinguishedFolderId Id=\"%@\" />", distinguishedFolderId];
    }else{
        bodyString = [bodyString stringByAppendingFormat:@"<t:FolderId Id=\"%@\" ChangeKey=\"%@\" />", folderId, folderChangeKey];
    }
    bodyString = [bodyString stringByAppendingString:@"</m:SyncFolderId>"];
    if (syncState.length) {
        bodyString = [bodyString stringByAppendingFormat:@"<m:SyncState>%@</m:SyncState>",syncState];
    }
    bodyString = [bodyString stringByAppendingFormat:@"<m:MaxChangesReturned>%@</m:MaxChangesReturned>",maxChangesReturned];
    bodyString = [bodyString stringByAppendingFormat:@"<m:SyncScope>%@</m:SyncScope>",syncScope];
    bodyString = [bodyString stringByAppendingString:@"</m:SyncFolderItems>"];
    return [self ewsSoapMessageWithBodyString:bodyString];
}

#pragma mark - 发送邮件
// 新建电子邮件
- (NSString *)ewsSoapMessageCreateItemWithMessage:(JDMailMessage *)message
{
    // 收件人不能为空
    if (message.toRecipients.count == 0) {
        return nil;
    }
    
    NSString *bodyString = [NSString stringWithFormat:@"<m:CreateItem MessageDisposition=\"%@\">",message.messageDisposition];
    // 
    NSString *savedItemFolderString = [NSString stringWithFormat:@"<m:SavedItemFolderId><t:DistinguishedFolderId Id=\"%@\" /></m:SavedItemFolderId>",message.distinguishedFolderId];
    bodyString = [bodyString stringByAppendingString:savedItemFolderString];
    
    bodyString = [bodyString stringByAppendingString:@"<m:Items><t:Message>"];
    // 主题
    if (message.subject.length) {
        NSString *subject = [NSString stringWithFormat:@"<t:Subject>%@</t:Subject>",message.subject];
        bodyString = [bodyString stringByAppendingString:subject];
    }
    // body
    if (message.body.length) {
        NSString *body = [NSString stringWithFormat:@"<t:Body BodyType=\"%@\">%@</t:Body>",message.bodyType,message.body];
        bodyString = [bodyString stringByAppendingString:body];
    }
    //附件
//    if(message.emailAttachmentArray.count>0)
//    {
//        bodyString = [bodyString stringByAppendingString:@"<t:Attachments>"];
//        for (JDMailAttachment *attachment in message.emailAttachmentArray) {
//            bodyString = [bodyString stringByAppendingString:@"<t:FileAttachment>"];
//            bodyString = [bodyString stringByAppendingFormat:@"<t:Name>%@</t:Name>",attachment.name];
//            bodyString = [bodyString stringByAppendingFormat:@"<t:IsInline>%@</t:IsInline>", attachment.isInline ?@"ture":@"false"];
//            bodyString = [bodyString stringByAppendingFormat:@"<t:Content>%@</t:Content>",attachment.content];
//            bodyString = [bodyString stringByAppendingString:@"</t:FileAttachment></t:Attachments>"];
//        }
//    }
    // 收件人
    if (message.toRecipients.count) {
        NSString *toRecipientsString = @"<t:ToRecipients>";
        for (NSString *toString in message.toRecipients) {
            NSString *toRecipientString = [NSString stringWithFormat:@"<t:Mailbox><t:EmailAddress>%@</t:EmailAddress></t:Mailbox>",toString];
            toRecipientsString = [toRecipientsString stringByAppendingString:toRecipientString];
        }
        toRecipientsString = [toRecipientsString stringByAppendingString:@"</t:ToRecipients>"];
        bodyString = [bodyString stringByAppendingString:toRecipientsString];
    }
    // 抄送人
    if (message.ccRecipients.count) {
        NSString *ccRecipientsString = @"<t:CcRecipients>";
        for (NSString *ccString in message.ccRecipients) {
            NSString *ccRecipientString = [NSString stringWithFormat:@"<t:Mailbox><t:EmailAddress>%@</t:EmailAddress></t:Mailbox>",ccString];
            ccRecipientsString = [ccRecipientsString stringByAppendingString:ccRecipientString];
        }
        ccRecipientsString = [ccRecipientsString stringByAppendingString:@"</t:CcRecipients>"];
        bodyString = [bodyString stringByAppendingString:ccRecipientsString];
    }
    // 密送人
    if (message.bccRecipients.count) {
        NSString *bccRecipientsString = @"<t:BccRecipients>";
        for (NSString *bccString in message.bccRecipients) {
            NSString *bccRecipientString = [NSString stringWithFormat:@"<t:Mailbox><t:EmailAddress>%@</t:EmailAddress></t:Mailbox>",bccString];
            bccRecipientsString = [bccRecipientsString stringByAppendingString:bccRecipientString];
        }
        bccRecipientsString = [bccRecipientsString stringByAppendingString:@"</t:BccRecipients>"];
        bodyString = [bodyString stringByAppendingString:bccRecipientsString];
    }
    
    bodyString = [bodyString stringByAppendingString:@"</t:Message></m:Items></m:CreateItem>"];
    
    return [self ewsSoapMessageWithBodyString:bodyString];
}

#pragma mark - 回复，转发电子邮件
///回复电子邮件
- (NSString *)ewsSoapMessageReplyAll:(JDMailMessage *)message
{
     NSString *bodyString = [NSString stringWithFormat:@"<m:CreateItem MessageDisposition=\"%@\">",message.messageDisposition];
    /*
     <m:Items>
     <t:ReplyAllToItem>
     <t:ReferenceItemId Id="AAMkADE4="
     ChangeKey="CQAAABYA" />
     <t:NewBodyContent BodyType="HTML">This is the message body of the email reply.</t:NewBodyContent>
     </t:ReplyAllToItem>
     </m:Items>
     </m:CreateItem>
     */
    bodyString = [bodyString stringByAppendingString:@"<m:Items><t:ReplyAllToItem>"];
    bodyString = [bodyString stringByAppendingFormat:@"<t:ReferenceItemId Id=\"%@\" ChangeKey=\"%@\"/>",message.emailItemId,message.changeKey];
    bodyString = [bodyString stringByAppendingFormat:@"<t:NewBodyContent BodyType=\"%@\">%@</t:NewBodyContent>",message.bodyType,message.body];
    bodyString = [bodyString stringByAppendingString:@"</t:ReplyAllToItem></m:Items></m:CreateItem>"];
    return [self ewsSoapMessageWithBodyString:bodyString];;
}

///转发电子邮件
- (NSString *)ewsSoapMessageForwardEmail:(JDMailMessage *)message
{
    /*
     <t:ReferenceItemId Id="AAAMkADE="
     ChangeKey="CQAAABYA" />
     <t:NewBodyContent BodyType="HTML">This is the message body of the forwarded email.</t:NewBodyContent>
     </t:ForwardItem>
     */
    NSString *bodyString = [NSString stringWithFormat:@"<m:CreateItem MessageDisposition=\"%@\">",message.messageDisposition];
    bodyString = [bodyString stringByAppendingString:@"<m:Items><t:ForwardItem>"];
    if (message.toRecipients.count) {
        NSString *toRecipientsString = @"<t:ToRecipients>";
        for (NSString *toString in message.toRecipients) {
            NSString *toRecipientString = [NSString stringWithFormat:@"<t:Mailbox><t:EmailAddress>%@</t:EmailAddress></t:Mailbox>",toString];
            toRecipientsString = [toRecipientsString stringByAppendingString:toRecipientString];
        }
        toRecipientsString = [toRecipientsString stringByAppendingString:@"</t:ToRecipients>"];
        bodyString = [bodyString stringByAppendingString:toRecipientsString];
    }
    bodyString = [bodyString stringByAppendingFormat:@"<t:ReferenceItemId Id=\"%@\" ChangeKey=\"%@\"/>",message.emailItemId,message.changeKey];
    bodyString = [bodyString stringByAppendingFormat:@"<t:NewBodyContent BodyType=\"%@\">%@</t:NewBodyContent>",message.bodyType,message.body];
    bodyString = [bodyString stringByAppendingString:@"</t:ForwardItem></m:Items></m:CreateItem>"];
   
    return [self ewsSoapMessageWithBodyString:bodyString];;
}

// 查找某个文件夹下的电子邮件列表
- (NSString *)ewsSoapMessageFindItemWithFolder:(NSString *)folder maxEntriesReturned:(NSString *)maxEntriesReturned offset:(NSString *)offset
{
    NSString *bodyString = @"<m:FindItem Traversal=\"Shallow\">";
    bodyString = [bodyString stringByAppendingString:@"<m:ItemShape>"];
    bodyString = [bodyString stringByAppendingString:@"<t:BaseShape>AllProperties</t:BaseShape>"];
    bodyString = [bodyString stringByAppendingString:@"<t:IncludeMimeContent>true</t:IncludeMimeContent>"];
    bodyString = [bodyString stringByAppendingString:@"</m:ItemShape>"];
    NSString *indexedPageItemString = [NSString stringWithFormat:@"<m:IndexedPageItemView MaxEntriesReturned=\"%@\" BasePoint=\"Beginning\" Offset=\"%@\" />",maxEntriesReturned,offset];
    bodyString = [bodyString stringByAppendingString:indexedPageItemString];
    bodyString = [bodyString stringByAppendingString:@"<m:SortOrder><t:FieldOrder Order=\"Descending\"><t:FieldURI FieldURI=\"item:DateTimeCreated\"/></t:FieldOrder></m:SortOrder>"];
    bodyString = [bodyString stringByAppendingString:@"<m:ParentFolderIds>"];
    NSString *xmlFolderString = [NSString stringWithFormat:@"<t:DistinguishedFolderId Id=\"%@\" />",folder];
    bodyString = [bodyString stringByAppendingString:xmlFolderString];
    bodyString = [bodyString stringByAppendingString:@"</m:ParentFolderIds>"];
    bodyString = [bodyString stringByAppendingString:@"</m:FindItem>"];
    return [self ewsSoapMessageWithBodyString:bodyString];
}

// 查找某几个电子邮件
- (NSString *)ewsSoapMessageGetItemWithItems:(NSArray *)items includeMimeContent:(NSString *)includeMimeContent
{
    NSString *bodyString = @"<m:GetItem>";
    bodyString = [bodyString stringByAppendingString:@"<m:ItemShape>"];
    bodyString = [bodyString stringByAppendingString:@"<t:BaseShape>AllProperties</t:BaseShape>"];
    bodyString = [bodyString stringByAppendingFormat:@"<t:IncludeMimeContent>%@</t:IncludeMimeContent>",includeMimeContent];
    bodyString = [bodyString stringByAppendingString:@"<t:AdditionalProperties><t:FieldURI FieldURI=\"item:Attachments\"></t:FieldURI><t:FieldURI FieldURI=\"item:HasAttachments\"></t:FieldURI></t:AdditionalProperties>"];
    bodyString = [bodyString stringByAppendingString:@"</m:ItemShape>"];
    bodyString = [bodyString stringByAppendingString:@"<m:ItemIds>"];
    for (NSDictionary *dict in items) {
        NSString *itemId = [dict objectForKey:@"ItemId"];
        NSString *changeKey = [dict objectForKey:@"ChangeKey"];
        NSString *xmlFolderString = [NSString stringWithFormat:@"<t:ItemId Id=\"%@\" ChangeKey=\"%@\" />",itemId,changeKey];
        bodyString = [bodyString stringByAppendingString:xmlFolderString];
    }
    bodyString = [bodyString stringByAppendingString:@"</m:ItemIds>"];
    bodyString = [bodyString stringByAppendingString:@"</m:GetItem>"];
    return [self ewsSoapMessageWithBodyString:bodyString];
}

///删除邮件
- (NSString *)ewsSoapMessageDeleteEmailsByItems:(NSArray *)ItemIds
{
    NSString *bodyString = @"<m:DeleteItem DeleteType=\"MoveToDeletedItems\">";
    bodyString = [bodyString stringByAppendingString:@"<m:ItemIds>"];
    for (NSString *itemId in ItemIds) {
        bodyString = [bodyString stringByAppendingFormat:@"<t:ItemId Id=\"%@\"/>",itemId];
    }
    bodyString = [bodyString stringByAppendingString:@"</m:ItemIds>"];
     bodyString = [bodyString stringByAppendingString:@"</m:DeleteItem>"];
    return [self ewsSoapMessageWithBodyString:bodyString];
}

- (NSString *)ewsSoapMessageEmailAttachment:(NSArray *)attachmentIds
{
    /*
     <m:GetAttachment>
     <m:AttachmentIds>
     <t:AttachmentId Id="5zTzlqU=" />
     </m:AttachmentIds>
     </m:GetAttachment>
     */
    NSString *bodyString = @"<m:GetAttachment><m:ItemShape>default</m:ItemShape>";
    bodyString = [bodyString stringByAppendingString:@"<t:AdditionalProperties><t:FieldURI FieldURI=\"item:Attachments\"></t:FieldURI><t:FieldURI FieldURI=\"item:HasAttachments\"></t:FieldURI></t:AdditionalProperties><m:AttachmentIds>"];
    if(attachmentIds.count>0) {
        for (NSString *itemId in attachmentIds) {
            bodyString = [bodyString stringByAppendingFormat:@"<t:AttachmentId Id=\"%@\"/>",itemId];
        }
    }
    bodyString = [bodyString stringByAppendingString:@"</m:AttachmentIds></m:GetAttachment>"];
    return [self ewsSoapMessageWithBodyString:bodyString];
}

#pragma mark - 联系人
// 新建联系人
- (NSString *)ewsSoapMessageContactCreateItemWithMessage:(JDContactMessage *)message
{
    NSString *bodyString = @"<m:CreateItem>";
    // 
    NSString *savedItemFolderString = [NSString stringWithFormat:@"<m:SavedItemFolderId><t:DistinguishedFolderId Id=\"%@\" /></m:SavedItemFolderId>",message.distinguishedFolderId];
    bodyString = [bodyString stringByAppendingString:savedItemFolderString];
    bodyString = [bodyString stringByAppendingString:@"<m:Items><t:Contact>"];
    //
    if (message.fileAs.length) {
        NSString *fileAs = [NSString stringWithFormat:@"<t:FileAs>%@</t:FileAs>",message.fileAs];
        bodyString = [bodyString stringByAppendingString:fileAs];
    }
    //
    if (message.givenName.length) {
        NSString *givenName = [NSString stringWithFormat:@"<t:GivenName>%@</t:GivenName>",message.givenName];
        bodyString = [bodyString stringByAppendingString:givenName];
    }
    if (message.surname.length) {
        NSString *surname = [NSString stringWithFormat:@"<t:Surname>%@</t:Surname>",message.surname];
        bodyString = [bodyString stringByAppendingString:surname];
    }
    //
    if (message.companyName.length) {
        NSString *companyName = [NSString stringWithFormat:@"<t:CompanyName>%@</t:CompanyName>",message.companyName];
        bodyString = [bodyString stringByAppendingString:companyName];
    }
    //
    if (message.jobTitle.length) {
        NSString *jobTitle = [NSString stringWithFormat:@"<t:JobTitle>%@</t:JobTitle>",message.jobTitle];
        bodyString = [bodyString stringByAppendingString:jobTitle];
    }
    //
    if (message.emailAddresses.count) {
        NSString *emailAddressesString = @"<t:EmailAddresses>";
        for (NSString *emailAddress in message.emailAddresses) {
            NSString *emailAddressString = [NSString stringWithFormat:@"<t:Entry Key=\"EmailAddress1\">%@</t:Entry>",emailAddress];
            emailAddressesString = [emailAddressesString stringByAppendingString:emailAddressString];
        }
        emailAddressesString = [emailAddressesString stringByAppendingString:@"</t:EmailAddresses>"];
        bodyString = [bodyString stringByAppendingString:emailAddressesString];
    }
    //
    if (message.phoneNumbers.count) {
        NSString *phoneNumbersString = @"<t:PhoneNumbers>";
        for (NSString *phoneNumber in message.phoneNumbers) {
            NSString *phoneNumberString = [NSString stringWithFormat:@"<t:Entry Key=\"BusinessPhone\">%@</t:Entry>",phoneNumber];
            phoneNumbersString = [phoneNumbersString stringByAppendingString:phoneNumberString];
        }
        phoneNumbersString = [phoneNumbersString stringByAppendingString:@"</t:PhoneNumbers>"];
        bodyString = [bodyString stringByAppendingString:phoneNumbersString];
    }
    bodyString = [bodyString stringByAppendingString:@"</t:Contact></m:Items></m:CreateItem>"];
    return [self ewsSoapMessageWithBodyString:bodyString];
}

@end
