//
//  JDEditSendEmailController.h
//  JDMail
//
//  Created by 千阳 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDSendEmailModel;


NS_ASSUME_NONNULL_BEGIN

@interface JDEditSendEmailController : UIViewController

@property(nonatomic,strong)UITableView *tableView;
///收件人地址
@property(nonatomic,strong)UILabel *recipientLabel;
@property(nonatomic,strong)UITextField *recipientAddressText;
///抄送地址
@property(nonatomic,strong)UILabel *ccRecipientLabel;
@property(nonatomic,strong)UITextField *ccRecipienAddressText;
///密送地址
@property(nonatomic,strong)UILabel *bCcRecipientLabel;
@property(nonatomic,strong)UITextField *bCcRecipientAddressText;
///主题
@property(nonatomic,strong)UILabel *subjectLabel;
@property(nonatomic,strong)UITextField *subjectText;

@property(nonatomic,assign)CGFloat contentDivHeight;
@property(nonatomic,assign)CGFloat originalEmailBodyHeight;

@property(nonatomic,strong)JDSendEmailModel *model;
@property(nonatomic,strong)NSMutableArray *emailAddressTitle;
@end

NS_ASSUME_NONNULL_END
