//
//  JDEditSendEmailController+SubViewLayout.h
//  JDMail
//
//  Created by 千阳 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDEditSendEmailController.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDEditSendEmailController (TableViewDelegate)<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

///收件人地址
@property(nonatomic,strong)UILabel *recipientLabel;
@property(nonatomic,strong)UITextField *recipientAddressText;
///抄送地址
@property(nonatomic,strong)UILabel *ccRecipienLabel;
@property(nonatomic,strong)UITextField *ccRecipienAddressText;
///密送地址
@property(nonatomic,strong)UILabel *bCcRecipienLabel;
@property(nonatomic,strong)UITextField *bCcRecipienAddressText;
///主题
@property(nonatomic,strong)UILabel *subjectLabel;
@property(nonatomic,strong)UITextField *subjectText;

@end

NS_ASSUME_NONNULL_END
