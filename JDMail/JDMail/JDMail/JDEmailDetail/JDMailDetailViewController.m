//
//  JDMailDetailViewController.m
//  JDMail
//
//  Created by 千阳 on 2019/2/26.
//  Copyright © 2019 公司. All rights reserved.
//

#define ReplyViewHeight 50

#import "JDMailDetailViewController.h"
#import "RecipientCell.h"
#import <Masonry/Masonry.h>
#import "UIView+Frame.h"
#import "EmailContentCell.h"
#import "JDEditSendEmailController.h"
#import "JDSendEmailModel.h"
#import "JDMailReplyView.h"
#import "JDMialDetailContactViewController.h"
#import "JDMailSyncManager.h"
#import "JDAccountManager.h"
#import "JDAccount.h"

@interface JDMailDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) JDMailReplyView *replyView;
@property(nonatomic, strong) JDMailListModel *currentModel;

@end

@implementation JDMailDetailViewController
{
    @private
    CGFloat emailContentHeight;
}

- (instancetype)initWithModel:(JDMailListModel *)model
{
    self = [super init];
    if(self) {
        self.currentModel = model;
        emailContentHeight = 200;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"邮件详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.replyView];
    [self.view setNeedsUpdateConstraints];
    
    // 更新详情数据库内容
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.currentModel.itemId forKey:@"ItemId"];
    [dict setValue:self.currentModel.changeKey forKey:@"ChangeKey"];
    [[JDMailSyncManager shareManager] updateFolderItemContentWithAccount:[JDAccountManager shareManager].currentAccount.account folderId:self.currentModel.parentFolderId items:@[dict] success:^{
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)updateViewConstraints
{
    [self tableViewConstraints];
    [self replyViewConstraints];
    [super updateViewConstraints];
}

- (void)tableViewConstraints
{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.replyView.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
    }];
}

- (UITableView *)tableView
{
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[RecipientCell class] forCellReuseIdentifier:@"RecipientCellIdentifier"];
        [_tableView registerClass:[EmailContentCell class] forCellReuseIdentifier:@"EmailContentCellIdentifier"];
    }
    return _tableView;
}

- (void)replyViewConstraints
{
    [self.replyView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(ReplyViewHeight);
    }];
}

- (JDMailReplyView *)replyView
{
    if(!_replyView) {
        _replyView = [[JDMailReplyView alloc] init];
        __weak JDMailDetailViewController *weakSelf = self;
        _replyView.replyAllBlock = ^{
            __strong JDMailDetailViewController *strongSelf = weakSelf;
            [strongSelf showSendEmailController:EmailReply];
        };
        _replyView.forwardingBlock = ^{
            __strong JDMailDetailViewController *strongSelf = weakSelf;
            NSLog(@"call 转发");
            [strongSelf showSendEmailController:EmailForwarding];
        };
        _replyView.moreBlock = ^{
            NSLog(@"call 更多");
        };
    }
  
    return _replyView;
}

- (void)showSendEmailController:(EmailSendType)sendType
{
    JDEditSendEmailController *sendEmialController = [[JDEditSendEmailController alloc]init];
    
    JDSendEmailModel *model = [[JDSendEmailModel alloc] init];
    model.emialSendType = sendType;
    model.subject = self.currentModel.subject;
    model.body = self.currentModel.body;
    model.toRecipients = self.currentModel.toRecipients;
    model.ccRecipients = self.currentModel.ccRecipients;
    model.emailItemId = self.currentModel.itemId;
    model.changeKey = self.currentModel.changeKey;
    model.attachments = self.currentModel.attachments;
    model.from = self.currentModel.from;

    sendEmialController.model = model;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendEmialController];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        return 50;
    }else{
////        CGFloat height = [self getHeightFromString:currentModel.subject withFixedWidth:self.view.width]+10;
////        CGFloat a = self.view.height - height - 50;
////        return a;
//        return 800;
        return emailContentHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self getHeightFromString:self.currentModel.subject withFixedWidth:self.view.width]+10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.currentModel) {
        NSMutableAttributedString *attributeString = [self sectionHeaderStringStyleWithText:self.currentModel.subject];
        
        CGFloat stringHeight = [self getHeightFromString:self.currentModel.subject withFixedWidth:self.view.width];
        CGRect viewRect = CGRectMake(0, 0, self.view.width, stringHeight+10);
        CGRect labelRect = CGRectMake(0, 5, self.view.width, stringHeight);
        UIView *sectionView = [[UIView alloc] initWithFrame:viewRect];
        sectionView.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
        label.numberOfLines = 10;
        label.attributedText = attributeString;
        label.backgroundColor = [UIColor clearColor];
        [sectionView addSubview:label];
        return sectionView;
    }
    return nil;
}

- (CGFloat)getHeightFromString:(NSString *)text withFixedWidth:(CGFloat)width
{
    NSMutableAttributedString *attributedString = [self sectionHeaderStringStyleWithText:text];
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat height = ceil(CGRectGetHeight(rect));
    return height;
}

- (NSMutableAttributedString *)sectionHeaderStringStyleWithText:(NSString *)text
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 10;
    style.firstLineHeadIndent = 20;
    style.lineSpacing = 3;
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, text.length)];
    return attributeString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RecipientCellIdentifier" forIndexPath:indexPath];
        //showOtherRecipients
        RecipientCell *recipientCell = (RecipientCell *)cell;
        recipientCell.showOtherRecipients = ^{
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:@[self.currentModel.from] forKey:@"from"];
            [dic setObject:self.currentModel.toRecipients forKey:@"recipient"];
            [dic setObject:self.currentModel.ccRecipients forKey:@"ccRecipient"];
            
            JDMialDetailContactViewController *detailContactVC = [[JDMialDetailContactViewController alloc] initWithContactDic:dic];
            [self.navigationController pushViewController:detailContactVC animated:YES];
        };
        [recipientCell reloadWithModel:self.currentModel];
    }else if(indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"EmailContentCellIdentifier" forIndexPath:indexPath];
        NSMutableDictionary *paraDic = [NSMutableDictionary new];
        [paraDic setValue:self.currentModel.body forKey:@"bodyHtml"];
        [paraDic setValue:self.currentModel.attachments forKey:@"attachments"];
        EmailContentCell * contentCell =(EmailContentCell *)cell;
        contentCell.emialHtmlBodyHeight = ^(CGFloat height) {
            self->emailContentHeight = height;
            [tableView beginUpdates];
            [tableView endUpdates];
        };
        [contentCell reloadWithParams:paraDic];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
