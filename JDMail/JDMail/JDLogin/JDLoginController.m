//
//  JDLoginController.m
//  JDMail
//
//  Created by 公司 on 2019/2/22.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDLoginController.h"
#import <Masonry/Masonry.h>
#import "JDLoginTextFeildCell.h"
#import "JDLoginButtonCell.h"
#import "JDAccount.h"
#import "JDAccountManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "JDNetworkManager.h"
#import "JDMailMessageBuilder.h"
#import "GDataXMLNode.h"

@interface JDLoginController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JDAccount *account;

@end

@implementation JDLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"添加账户";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.finishBlock) {
        
    }else{
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemDidClicked:)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    
    [self.dataArray removeAllObjects];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:@"账号" forKey:@"title"];
    [dict1 setValue:@"电子邮件地址" forKey:@"placeholder"];
    [self.dataArray addObject:dict1];
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setValue:@"密码" forKey:@"title"];
    [dict2 setValue:@"密码" forKey:@"placeholder"];
    [self.dataArray addObject:dict2];
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setValue:@"描述" forKey:@"title"];
    [dict3 setValue:@"描述" forKey:@"placeholder"];
    [self.dataArray addObject:dict3];
//    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
//    [dict4 setValue:@"服务器" forKey:@"title"];
//    [dict4 setValue:@"服务器" forKey:@"placeholder"];
//    [self.dataArray addObject:dict4];
//    NSMutableDictionary *dict5 = [NSMutableDictionary dictionary];
//    [dict5 setValue:@"域" forKey:@"title"];
//    [dict5 setValue:@"域" forKey:@"placeholder"];
//    [self.dataArray addObject:dict5];
    NSMutableDictionary *dict6 = [NSMutableDictionary dictionary];
    [dict6 setValue:@"用户名" forKey:@"title"];
    [dict6 setValue:@"用户名" forKey:@"placeholder"];
    [self.dataArray addObject:dict6];
    [self.tableView reloadData];
}

- (void)leftBarButtonItemDidClicked:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40.0;
    }else {
        return 50.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *model = [self.dataArray objectAtIndex:indexPath.row];
        JDLoginTextFeildCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDLoginTextFeildCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak JDLoginController *weakSelf = self;
        cell.textBlock = ^(NSString *value, NSString *key) {
            __strong JDLoginController *strongSelf = weakSelf;
            if ([key isEqualToString:@"账号"]) {
                strongSelf.account.account = value;
            }else if ([key isEqualToString:@"密码"]) {
                strongSelf.account.password = value;
            }else if ([key isEqualToString:@"描述"]) {
                strongSelf.account.nickName = value;
            }else if ([key isEqualToString:@"服务器"]) {
                strongSelf.account.server = value;
            }else if ([key isEqualToString:@"域"]) {
                strongSelf.account.domain = value;
            }else if ([key isEqualToString:@"用户名"]) {
                strongSelf.account.userName = value;
            }
        };
        [cell reloadWithModel:model];
        return cell;
    }else{
        JDLoginButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDLoginButtonCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak JDLoginController *weakSelf = self;
        cell.loginBlock = ^{
            __strong JDLoginController *strongSelf = weakSelf;
            [strongSelf login];
        };
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)login
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[JDLoginTextFeildCell class]]) {
            JDLoginTextFeildCell *tempCell = (JDLoginTextFeildCell *)cell;
            [tempCell.textField resignFirstResponder];
        }
    }
    // 调整网络会话
    [[JDNetworkManager shareManager] registerSoapManagerWithAccount:self.account.account userName:self.account.userName password:self.account.password];
    NSString *account = self.account.account;
    NSString *syncFolderString = [[JDMailMessageBuilder new] ewsSoapMessageSyncFolderHierarchyWithSyncState:@""];
    __weak JDLoginController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[JDNetworkManager shareManager] POSTWithAccount:account httpBodyString:syncFolderString success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        __strong JDLoginController *strongSelf = weakSelf;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *soapBody = [[rootElement elementsForName:@"s:Body"] firstObject];
        GDataXMLElement *syncFolderHierarchyResponse = [[soapBody elementsForName:@"m:SyncFolderHierarchyResponse"] firstObject];
        GDataXMLElement *responseMessages = [[syncFolderHierarchyResponse elementsForName:@"m:ResponseMessages"] firstObject];
        GDataXMLElement *syncFolderHierarchyResponseMessage = [[responseMessages elementsForName:@"m:SyncFolderHierarchyResponseMessage"] firstObject];
        GDataXMLElement *responseCode = [[syncFolderHierarchyResponseMessage elementsForName:@"m:ResponseCode"] firstObject];
        if ([[responseCode stringValue] isEqualToString:@"NoError"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                // 登录成功操作
                strongSelf.account.avatar = @"http://pic.rmb.bdstatic.com/2b3a53eb722575ba7ffd3f5fcc2bcc67.jpeg@wm_2,t_55m+5a625Y+3L0HmiJHkuLrlm77ni4I=,fc_ffffff,ff_U2ltSGVp,sz_13,x_9,y_9";
                [[JDAccountManager shareManager] addNewAccount:strongSelf.account];
                [[JDAccountManager shareManager] changeCurrentAccount:strongSelf.account];
                if (strongSelf.finishBlock) {
                    strongSelf.finishBlock();
                }else{
                    [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JDNetworkManager shareManager] unregisterSoapManagerWithAccount:account];
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        __strong JDLoginController *strongSelf = weakSelf;
        NSLog(@"失败%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[JDNetworkManager shareManager] unregisterSoapManagerWithAccount:account];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        });
    }];
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
        [_tableView registerClass:[JDLoginTextFeildCell class] forCellReuseIdentifier:@"JDLoginTextFeildCell"];
        [_tableView registerClass:[JDLoginButtonCell class] forCellReuseIdentifier:@"JDLoginButtonCell"];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (JDAccount *)account
{
    if (!_account) {
        _account = [[JDAccount alloc] init];
    }
    return _account;
}

@end
