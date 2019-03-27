//
//  JDEditSendEmailController+SubViewLayout.m
//  JDMail
//
//  Created by 千阳 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDEditSendEmailController+TableViewDelegate.h"
#import "JDEmialAddressCell.h"
#import "JDEmailEditCell.h"
#import "HXCustomNavigationController.h"
#import "JDMailPerson.h"
#import "JDAttachmentTableViewCell.h"
#import "JDSendEmailModel.h"
#import "JDMailAttachment.h"
#import "JDAccountManager.h"
#import "JDAccount.h"

/*
 self.recipientsDic =  recipients;
 recipientArray = recipients[@"recipientArray"];
 ccRecipientArray = recipients[@"ccRecipientArray"];
 bCcRecipientArray = recipients[@"bCcRecipientArray"];
 */

@implementation JDEditSendEmailController (TableViewDelegate)

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.emailAddressTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        JDEmialAddressCell *cell = [[JDEmialAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JDEmialAddressCellIdentifier"];
        NSArray *titles = self.emailAddressTitle;
        
        cell.title = titles[indexPath.row];
    
        if([self.emailAddressTitle[indexPath.row] isEqualToString:@"收件人"])//收件人
        {
            if(self.model.emialSendType == EmailReply)
            {
                NSArray *toRecipients = [self recipientsEmailAdress:self.model.toRecipients];
                NSMutableArray *addressArray = [NSMutableArray arrayWithArray:toRecipients];
                [addressArray insertObject:self.model.from.emailAddress atIndex:0];//发件人人放在第一个
                [addressArray removeObject:[JDAccountManager shareManager].currentAccount.account];
                [cell loadEmailAdress:addressArray];
            }
        }
        else if([self.emailAddressTitle[indexPath.row] isEqualToString:@"抄送"])//抄送
        {
            NSMutableArray *recipientArray = [NSMutableArray arrayWithArray:self.model.ccRecipients];
            [recipientArray removeObject:[JDAccountManager shareManager].currentAccount.account];
            NSArray *addressArray = [self recipientsEmailAdress:recipientArray];
            [cell loadEmailAdress:addressArray];
        }
        else if([self.emailAddressTitle[indexPath.row] isEqualToString:@"密送"])//密送
        {
        }
        else if([self.emailAddressTitle[indexPath.row] isEqualToString:@"主题"])//主题
        {
            cell.subject = [self resetSubject:self.model.subject];
        }
        else if([self.emailAddressTitle[indexPath.row]isEqualToString:@"附件"])
        {
            JDAttachmentTableViewCell *attachmentCell = [tableView dequeueReusableCellWithIdentifier:@"JDAttachmentTableViewCellIdentifier" forIndexPath:indexPath];
            [attachmentCell reloadDataWithMailAttachmentArray:self.model.attachments];
            return attachmentCell;
        }
        else if([self.emailAddressTitle[indexPath.row]isEqualToString:@"body"])
        {
            JDEmailEditCell *editcell = [[JDEmailEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JDEmailEditCellIdentifier"];
            editcell.showPhotoController = ^(HXCustomNavigationController * _Nonnull nav) {
                [self showPhotosControl:nav];
            };
            editcell.contentDivHeight = ^(CGFloat height) {
                self.contentDivHeight = height;
                [tableView beginUpdates];
                [tableView endUpdates];
            };
            editcell.originalEmailHtml = self.model.body;
            if(self.model.attachments.count>0)
            {
                [editcell reloadAttachment:self.model.attachments];
    
            }
            return editcell;
         }
    return cell;
}

- (NSString *)resetSubject:(NSString *)subject
{
    NSString *result = subject;
    if(self.model.emialSendType == EmailReply)
    {
        result = [NSString stringWithFormat:@"Re:%@",result];
    }
    else if(self.model.emialSendType == EmailForwarding)
    {
        result = [NSString stringWithFormat:@"Fwd:%@",result];
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height =40;
     
    if([self.emailAddressTitle[indexPath.row] isEqualToString:@"收件人"])//收件人
    {
        
    }
    else if([self.emailAddressTitle[indexPath.row] isEqualToString:@"抄送"])//抄送
    {
    }
    else if([self.emailAddressTitle[indexPath.row] isEqualToString:@"密送"])//密送
    {
    }
    else if([self.emailAddressTitle[indexPath.row] isEqualToString:@"主题"])//主题
    {
    }
    else if([self.emailAddressTitle[indexPath.row]isEqualToString:@"附件"])
    {
        height = 100;
    }
    else if([self.emailAddressTitle[indexPath.row]isEqualToString:@"body"])
    {
        if(self.contentDivHeight == 0)
        {
            return self.view.frame.size.height-(40*4)-self.navigationController.navigationBar.frame.size.height-[[UIApplication sharedApplication] statusBarFrame].size.height;
        }
        else
            return self.contentDivHeight;
    }
    
    return height;
}

#pragma mark - UITableViewDelegate


- (void)showPhotosControl:(HXCustomNavigationController *)nav
{
    [self presentViewController:nav animated:YES completion:nil];
}


- (NSArray *)recipientsEmailAdress:(NSArray *)recipientArray
{
    NSMutableArray *result = [NSMutableArray new];
    NSArray *tmpArray = recipientArray;
    if(tmpArray && tmpArray.count)
    {
        for (JDMailPerson *person in tmpArray) {
            [result addObject:person.emailAddress];
        }
    }
    return result;
}

@end
