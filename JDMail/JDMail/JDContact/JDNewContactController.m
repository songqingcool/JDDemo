//
//  JDNewContactController.m
//  JDMail
//
//  Created by 公司 on 2019/3/6.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDNewContactController.h"
#import <Masonry/Masonry.h>
#import "JDContactFieldCell.h"
#import "JDMailMessageBuilder.h"
#import "JDNetworkManager.h"
#import "JDContactMessage.h"
#import "MBProgressHUD+Extend.h"
#import "GDataXMLNode.h"
#import "JDAccountManager.h"
#import "JDAccount.h"

@interface JDNewContactController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *placeholderArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *emailArray;
@property (nonatomic, strong) NSMutableArray *phoneArray;

@end

@implementation JDNewContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"新建联系人";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonDidClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonDidClicked:)];
    
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    [self.tableView reloadData];
    [self.tableView setEditing:YES animated:YES];
}

- (void)cancelButtonDidClicked:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonDidClicked:(UIBarButtonItem *)sender
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[JDContactFieldCell class]]) {
            JDContactFieldCell *tempCell = (JDContactFieldCell *)cell;
            [tempCell.textField resignFirstResponder];
        }
    }
    
    NSMutableArray *emailList = [NSMutableArray array];
    for (NSString *email in self.emailArray) {
        if (email.length) {
            [emailList addObject:email];
        }
    }
    NSMutableArray *phoneList = [NSMutableArray array];
    for (NSString *phone in self.phoneArray) {
        if (phone.length) {
            [phoneList addObject:phone];
        }
    }
    JDContactMessage *message = [[JDContactMessage alloc] init];
    message.distinguishedFolderId = @"contacts";
    message.fileAs = @"SampleContact";
    message.surname = [self.dataArray objectAtIndex:0];
    message.givenName = [self.dataArray objectAtIndex:1];
    message.companyName = [self.dataArray objectAtIndex:2];
    message.jobTitle = [self.dataArray objectAtIndex:3];
    message.emailAddresses = emailList;
    message.phoneNumbers = phoneList;
    NSString *bodyString = [[JDMailMessageBuilder new] ewsSoapMessageContactCreateItemWithMessage:message];
    __weak JDNewContactController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[JDNetworkManager shareManager] POSTWithAccount:[JDAccountManager shareManager].currentAccount.account httpBodyString:bodyString success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        __strong JDNewContactController *strongSelf = weakSelf;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *soapBody = [[rootElement elementsForName:@"s:Body"] firstObject];
        GDataXMLElement *createItemResponse = [[soapBody elementsForName:@"m:CreateItemResponse"] firstObject];
        GDataXMLElement *responseMessages = [[createItemResponse elementsForName:@"m:ResponseMessages"] firstObject];
        GDataXMLElement *createItemResponseMessage = [[responseMessages elementsForName:@"m:CreateItemResponseMessage"] firstObject];
        GDataXMLElement *responseCode = [[createItemResponseMessage elementsForName:@"m:ResponseCode"] firstObject];
        if ([[responseCode stringValue] isEqualToString:@"NoError"]) {
            // 请求成功
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                [MBProgressHUD showHudWithText:@"创建联系人成功"];
                [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        }else{
            // 请求失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                [MBProgressHUD showHudWithText:@"创建联系人失败"];
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        __strong JDNewContactController *strongSelf = weakSelf;
        NSLog(@"失败%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [MBProgressHUD showHudWithText:@"创建联系人失败"];
        });
    }];
}

- (void)updateViewConstraints
{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.placeholderArray.count;
    }else if (section == 1) {
        return self.emailArray.count+1;
    }else {
        return self.phoneArray.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *placeholder = [self.placeholderArray objectAtIndex:indexPath.row];
        NSString *content = [self.dataArray objectAtIndex:indexPath.row];
        NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section,(long)indexPath.row];
        JDContactFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[JDContactFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        __weak JDNewContactController *weakSelf = self;
        cell.endEditBlock = ^(NSString *text) {
            __strong JDNewContactController *strongSelf = weakSelf;
            NSString *tempString = nil;
            if (text.length) {
                tempString = text;
            }else{
                tempString = @"";
            }
            [strongSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:tempString];
        };
        cell.placeholder = placeholder;
        cell.content = content;
        return cell;
    }else if (indexPath.section == 1) {
        if (indexPath.row < self.emailArray.count) {
            NSString *content = [self.emailArray objectAtIndex:indexPath.row];
            NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section,(long)indexPath.row];
            JDContactFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[JDContactFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            __weak JDNewContactController *weakSelf = self;
            cell.endEditBlock = ^(NSString *text) {
                __strong JDNewContactController *strongSelf = weakSelf;
                NSString *tempString = nil;
                if (text.length) {
                    tempString = text;
                }else{
                    tempString = @"";
                }
                [strongSelf.emailArray replaceObjectAtIndex:indexPath.row withObject:tempString];
            };
            cell.placeholder = @"邮件";
            cell.content = content;
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.textLabel.text = @"邮件";
            return cell;
        }
    }else {
        if (indexPath.row < self.phoneArray.count) {
            NSString *content = [self.phoneArray objectAtIndex:indexPath.row];
            NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section,(long)indexPath.row];
            JDContactFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[JDContactFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            __weak JDNewContactController *weakSelf = self;
            cell.endEditBlock = ^(NSString *text) {
                __strong JDNewContactController *strongSelf = weakSelf;
                NSString *tempString = nil;
                if (text.length) {
                    tempString = text;
                }else{
                    tempString = @"";
                }
                [strongSelf.phoneArray replaceObjectAtIndex:indexPath.row withObject:tempString];
            };
            cell.placeholder = @"电话";
            cell.content = content;
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.textLabel.text = @"电话";
            return cell;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 || indexPath.section == 2) {
        return YES;
    }else{
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row < self.emailArray.count) {
            return UITableViewCellEditingStyleDelete;
        }else{
            return UITableViewCellEditingStyleInsert;
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row < self.phoneArray.count) {
            return UITableViewCellEditingStyleDelete;
        }else{
            return UITableViewCellEditingStyleInsert;
        }
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == self.emailArray.count) {
        [self.emailArray addObject:@""];
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.emailArray.count-1 inSection:1];
        [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
        JDContactFieldCell *cell = [self.tableView cellForRowAtIndexPath:index];
        [cell.textField becomeFirstResponder];
    }
    if (indexPath.section == 2 && indexPath.row == self.phoneArray.count) {
        [self.phoneArray addObject:@""];
        NSIndexPath *index = [NSIndexPath indexPathForRow:self.phoneArray.count-1 inSection:2];
        [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
        JDContactFieldCell *cell = [self.tableView cellForRowAtIndexPath:index];
        [cell.textField becomeFirstResponder];
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak JDNewContactController *weakself = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *index) {
        __strong JDNewContactController *strongSelf = weakself;
        if (indexPath.section == 1){
            [strongSelf.emailArray removeObjectAtIndex:index.row];
        }else if (indexPath.section == 2){
            [strongSelf.phoneArray removeObjectAtIndex:index.row];
        }
        [strongSelf.tableView reloadData];
    }];
    return @[deleteAction];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0))
{
    __weak JDNewContactController *weakself = self;
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction *action, __kindof UIView *sourceView, void (^completionHandler)(BOOL)) {
        __strong JDNewContactController *strongSelf = weakself;
        if (indexPath.section == 1){
            [strongSelf.emailArray removeObjectAtIndex:indexPath.row];
        }else if (indexPath.section == 2){
            [strongSelf.phoneArray removeObjectAtIndex:indexPath.row];
        }
        if(completionHandler) {
            completionHandler(YES);
        }
        [strongSelf.tableView reloadData];
    }];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    return config;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - getter/setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), 34.0)];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

- (NSMutableArray *)placeholderArray
{
    if (!_placeholderArray) {
        _placeholderArray = [NSMutableArray array];
        [_placeholderArray addObject:@"姓"];
        [_placeholderArray addObject:@"名"];
        [_placeholderArray addObject:@"公司"];
        [_placeholderArray addObject:@"职位"];
    }
    return _placeholderArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@""];
        [_dataArray addObject:@""];
        [_dataArray addObject:@""];
        [_dataArray addObject:@""];
    }
    return _dataArray;
}

- (NSMutableArray *)emailArray
{
    if (!_emailArray) {
        _emailArray = [NSMutableArray array];
    }
    return _emailArray;
}

- (NSMutableArray *)phoneArray
{
    if (!_phoneArray) {
        _phoneArray = [NSMutableArray array];
    }
    return _phoneArray;
}

@end
