//
//  JDEditSendEmailController.m
//  JDMail
//
//  Created by 千阳 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDEditSendEmailController.h"
#import <Masonry/Masonry.h>
#import "JDEmialAddressCell.h"
#import "JDEmailEditCell.h"
#import "JDNetworkManager.h"
#import "JDMailMessageBuilder.h"
#import "JDMailMessage.h"
#import "GTMNSString+HTML.h"
#import "JDMailPerson.h"
#import "JDSendEmailModel.h"
#import "JDAttachmentTableViewCell.h"
#import "JDMailAttachment.h"
#import "JDAccountManager.h"
#import "JDAccount.h"

@interface JDEditSendEmailController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation JDEditSendEmailController
{
    NSArray *recipientArray,*ccRecipientArray,*bCcRecipientArray;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.contentDivHeight = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *cookieArr = [cookieJar cookies];
//    for(NSHTTPCookie *cookie in cookieArr) {
//        NSLog(@"cookie －> %@", cookie);
//        if ([cookie.name isEqualToString:@"X-OWA-CANARY"]) {
//            X-OWA-CANARY: {Canary-Token}
     //img src = “https://mail.jd.com/owa/service.svc/s/GetFileAttachment?id=AAMkAGU5OGM1MGExLTNiMjctNGU4OC05MWEzLWNiNzEwOTBjMTgxNQBGAAAAAADZ7cGB7pNLQI0me5WS%2BmtHBwDZx8lOkRUVRpucrmKOql39AAAAC339AAAwXlHR%2FcaXT7vl0rt2YXrEAAAasli9AAABEgAQAGZdvBHpgd5HgguyBS%2FFE5I%3D&X-OWA-CANARY=q12_fOvYh0KJIrN8F0sBCFBZmrXjodYI-GZyWxwrRB-xqfeYeDpMLk--3jU1AY-DMk6y9neG5hI.&isImagePreview=True”
    
//        }
//        //存储之后删除cookies
//        [cookieJar deleteCookie:cookie];
//    }
    
    
    self.title = @"新建邮件";
    
    self.emailAddressTitle = [NSMutableArray new];
    [self.emailAddressTitle addObject:@"收件人"];
    [self.emailAddressTitle addObject:@"抄送"];
    [self.emailAddressTitle addObject:@"密件抄送"];
    [self.emailAddressTitle addObject:@"主题"];
    [self.emailAddressTitle addObject:@"body"];
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendEmail)];
    [self loadRecipients];
    
// 待完善+++++++++++。　如果是附件 则停顿1秒插入一行附件栏
    JDMailAttachment *mailAttachment = nil;
    for (JDMailAttachment *attachment in self.model.attachments) {
        
        if(!attachment.isInline)
        {
            mailAttachment = attachment;
        }
    }
    if(mailAttachment)
    {
        [self performSelector:@selector(insertAttachment) withObject:nil afterDelay:1];
    }
    
}

- (void)insertAttachment
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [self.emailAddressTitle insertObject:@"附件" atIndex:4];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
}

- (void)loadRecipients
{
    if(recipientArray && recipientArray.count>0)
    {
        NSString *toRecipient = @"";
        for (JDMailPerson *person in recipientArray) {
            toRecipient = [toRecipient stringByAppendingFormat:@"%@;",person.emailAddress];
        }
        self.recipientAddressText.text = toRecipient;
    }
    if(ccRecipientArray && ccRecipientArray.count >0)
    {
         NSString *toccRecipient = @"";
        for (JDMailPerson *person in ccRecipientArray) {
            toccRecipient = [toccRecipient stringByAppendingFormat:@"%@;",person.emailAddress];
        }
          self.ccRecipienAddressText.text = toccRecipient;
    }
    if(bCcRecipientArray && bCcRecipientArray.count)
    {
        NSString *tobCcRecipient = @"";
        for (JDMailPerson *person in bCcRecipientArray) {
            tobCcRecipient = [tobCcRecipient stringByAppendingFormat:@"%@;",person.emailAddress];
        }
        self.bCcRecipientAddressText.text = tobCcRecipient;
    }
}

- (void)updateViewConstraints
{
    [self tableViewConstraints];
    [super updateViewConstraints];
}

- (void)tableViewConstraints
{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
    }];
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JDEmialAddressCell class] forCellReuseIdentifier:@"JDEmialAddressCellIdentifier"];
        [_tableView registerClass:[JDEmailEditCell class] forCellReuseIdentifier:@"JDEmailEditCellIdentifier"];
        [_tableView registerClass:[JDAttachmentTableViewCell class] forCellReuseIdentifier:@"JDAttachmentTableViewCellIdentifier"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -GetEmailItems
-(UITableViewCell *)getTableCell:(NSInteger)index
{
    NSArray *cells = [self.tableView visibleCells];
    if(cells.count>index)
        return cells[index];
    return nil;
}

- (void)sendEmail
{
    JDEmialAddressCell *toRecipientsCell = (JDEmialAddressCell*)[self getTableCell:0];
    JDEmialAddressCell *ccRecipientsCell = (JDEmialAddressCell*)[self getTableCell:1];
    JDEmialAddressCell *bccRecipientsCell = (JDEmialAddressCell*)[self getTableCell:2];
    JDEmialAddressCell *subjectsCell = (JDEmialAddressCell*)[self getTableCell:3];
    JDEmailEditCell *bodyCell = (JDEmailEditCell *)[self getTableCell:4];
    
    NSArray *toRecipients = toRecipientsCell.recipients;
    NSArray *ccRecipients = ccRecipientsCell.recipients;
    NSArray *bccRecipients = ccRecipientsCell.recipients;
    NSString *subject = subjectsCell.subject;
    NSString *body = bodyCell.emailContentHtml;
    
    body = [body gtm_stringByEscapingForHTML];
    
    
    JDMailMessage *mess = [JDMailMessage new];
    mess.messageDisposition = @"SendAndSaveCopy";
    mess.distinguishedFolderId = @"sentitems";
    mess.toRecipients = toRecipients;
    mess.ccRecipients = ccRecipients;
    mess.bccRecipients = bccRecipients;
    mess.subject = subject;
    mess.bodyType = @"HTML";
    mess.body = body;
    
    
    
    NSString *message = @"";
    if(self.model.emialSendType == EmailSendNormal)
    {
        message = [[JDMailMessageBuilder new] ewsSoapMessageCreateItemWithMessage:mess];
    }
    else if(self.model.emialSendType == EmailForwarding)
    {
        mess.emailItemId = self.model.emailItemId;
        mess.changeKey = self.model.changeKey;
        message = [[JDMailMessageBuilder new] ewsSoapMessageForwardEmail:mess];
    }
    else if(self.model.emialSendType == EmailReply)
    {
        mess.emailItemId = self.model.emailItemId;
        mess.changeKey = self.model.changeKey;
        message = [[JDMailMessageBuilder new] ewsSoapMessageReplyAll:mess];
    }
    [[JDNetworkManager shareManager] POSTWithAccount:[JDAccountManager shareManager].currentAccount.account httpBodyString:message success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        
        NSLog(@"send success :%@",task.response.description);
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示信息" message:@"邮件发送失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertVC addAction:okAction];
        
        [self presentViewController:alertVC animated:YES completion:^{
            
        }];
        NSLog(@"send fail :%@",error.description);
        
    }];
}


- (void)dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
