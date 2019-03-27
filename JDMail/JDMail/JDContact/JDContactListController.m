//
//  JDContactListController.m
//  JDMail
//
//  Created by 公司 on 2018/12/24.
//  Copyright © 2018 公司. All rights reserved.
//

#import "JDContactListController.h"
#import <Masonry/Masonry.h>
#import "JDContactCell.h"
#import "JDContactHeaderView.h"
#import "JDMailMessageBuilder.h"
#import "JDNetworkManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "GDataXMLNode.h"
#import <MJRefresh/MJRefresh.h>
#import "JDContactListMode.h"
#import "JDContactName.h"
#import "JDContactPhone.h"
#import "JDNewContactController.h"
#import "JDContactDetailController.h"
#import "JDAccountManager.h"
#import "JDAccount.h"

@interface JDContactListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MJRefreshGifHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshBackGifFooter *refreshFooter;
@property (nonatomic, strong) JDContactHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JDContactListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"联系人";
    
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    [self.tableView reloadData];
    [self headerRefreshDidTrigger];
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

- (void)headerRefreshDidTrigger
{
    NSString *findItemString = [[JDMailMessageBuilder new] ewsSoapMessageFindItemWithFolder:@"contacts" maxEntriesReturned:@"20" offset:@"0"];
    __weak JDContactListController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[JDNetworkManager shareManager] POSTWithAccount:[JDAccountManager shareManager].currentAccount.account httpBodyString:findItemString success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        __strong JDContactListController *strongSelf = weakSelf;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *soapBody = [[rootElement elementsForName:@"s:Body"] firstObject];
        GDataXMLElement *findItemResponse = [[soapBody elementsForName:@"m:FindItemResponse"] firstObject];
        GDataXMLElement *responseMessages = [[findItemResponse elementsForName:@"m:ResponseMessages"] firstObject];
        GDataXMLElement *findItemResponseMessage = [[responseMessages elementsForName:@"m:FindItemResponseMessage"] firstObject];
        GDataXMLElement *responseCode = [[findItemResponseMessage elementsForName:@"m:ResponseCode"] firstObject];
        if ([[responseCode stringValue] isEqualToString:@"NoError"]) {
            GDataXMLElement *rootFolder = [[findItemResponseMessage elementsForName:@"m:RootFolder"] firstObject];
            GDataXMLNode *includesLastItemInRange = [rootFolder attributeForName:@"IncludesLastItemInRange"];
            BOOL hasNextPage = NO;
            if ([[includesLastItemInRange stringValue] isEqualToString:@"false"]) {
                hasNextPage = YES;
            }
            GDataXMLElement *items = [[rootFolder elementsForName:@"t:Items"] firstObject];
            NSArray *contacts = [items elementsForName:@"t:Contact"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (GDataXMLElement *contact in contacts) {
                JDContactListMode *model = [[JDContactListMode alloc] init];
                GDataXMLElement *itemIdElement = [[contact elementsForName:@"t:ItemId"] firstObject];
                GDataXMLNode *idNode = [itemIdElement attributeForName:@"Id"];
                GDataXMLNode *changeKeyNode = [itemIdElement attributeForName:@"ChangeKey"];
                model.itemId = [idNode stringValue];
                model.changeKey = [changeKeyNode stringValue];
                GDataXMLElement *hasAttachmentsElement = [[contact elementsForName:@"t:HasAttachments"] firstObject];
                model.hasAttachments = [hasAttachmentsElement stringValue];
                GDataXMLElement *cultureElement = [[contact elementsForName:@"t:Culture"] firstObject];
                model.culture = [cultureElement stringValue];
                GDataXMLElement *fileAsElement = [[contact elementsForName:@"t:FileAs"] firstObject];
                model.fileAs = [fileAsElement stringValue];
                GDataXMLElement *displayNameElement = [[contact elementsForName:@"t:DisplayName"] firstObject];
                model.displayName = [displayNameElement stringValue];
                GDataXMLElement *givenNameElement = [[contact elementsForName:@"t:GivenName"] firstObject];
                model.givenName = [givenNameElement stringValue];
                GDataXMLElement *surnameElement = [[contact elementsForName:@"t:Surname"] firstObject];
                model.surname = [surnameElement stringValue];
                GDataXMLElement *completeNameElement = [[contact elementsForName:@"t:CompleteName"] firstObject];
                GDataXMLElement *firstNameElement = [[completeNameElement elementsForName:@"t:FirstName"] firstObject];
                GDataXMLElement *lastNameElement = [[completeNameElement elementsForName:@"t:LastName"] firstObject];
                GDataXMLElement *fullNameElement = [[completeNameElement elementsForName:@"t:FullName"] firstObject];
                JDContactName *completeName = [[JDContactName alloc] init];
                completeName.firstName = [firstNameElement stringValue];
                completeName.lastName = [lastNameElement stringValue];
                completeName.fullName = [fullNameElement stringValue];
                model.completeName = completeName;
                // EmailAddresses
                GDataXMLElement *emailAddressesElement = [[contact elementsForName:@"t:EmailAddresses"] firstObject];
                NSArray *emailList = [emailAddressesElement elementsForName:@"t:Entry"];
                NSMutableArray *emailAddresses = [NSMutableArray array];
                for (GDataXMLElement *entryElement in emailList) {
                    GDataXMLNode *keyNode = [entryElement attributeForName:@"Key"];
                    JDContactPhone *email = [[JDContactPhone alloc] init];
                    email.entry = [entryElement stringValue];
                    email.key = [keyNode stringValue];
                    [emailAddresses addObject:email];
                }
                model.emailAddresses = emailAddresses;
                // PhoneNumbers
                GDataXMLElement *phoneNumbersElement = [[contact elementsForName:@"t:PhoneNumbers"] firstObject];
                NSArray *phoneList = [phoneNumbersElement elementsForName:@"t:Entry"];
                NSMutableArray *phoneNumbers = [NSMutableArray array];
                for (GDataXMLElement *entryElement in phoneList) {
                    GDataXMLNode *keyNode = [entryElement attributeForName:@"Key"];
                    JDContactPhone *phone = [[JDContactPhone alloc] init];
                    phone.entry = [entryElement stringValue];
                    phone.key = [keyNode stringValue];
                    [phoneNumbers addObject:phone];
                }
                model.phoneNumbers = phoneNumbers;
                [tempArray addObject:model];
            }
            // 请求成功
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.refreshHeader endRefreshing];
                if (hasNextPage) {
                    [strongSelf.refreshFooter endRefreshing];
                }else {
                    [strongSelf.refreshFooter endRefreshingWithNoMoreData];
                }
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                [strongSelf.dataArray removeAllObjects];
                [strongSelf.dataArray addObjectsFromArray:tempArray];
                [strongSelf.tableView reloadData];
            });
        }else{
            // 请求失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.refreshHeader endRefreshing];
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        __strong JDContactListController *strongSelf = weakSelf;
        NSLog(@"失败%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.refreshHeader endRefreshing];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        });
    }];
}

- (void)footerRefreshDidTrigger
{
    NSString *findItemString = [[JDMailMessageBuilder new] ewsSoapMessageFindItemWithFolder:@"contacts" maxEntriesReturned:@"20" offset:@(self.dataArray.count).stringValue];
    __weak JDContactListController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[JDNetworkManager shareManager] POSTWithAccount:[JDAccountManager shareManager].currentAccount.account httpBodyString:findItemString success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        __strong JDContactListController *strongSelf = weakSelf;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *soapBody = [[rootElement elementsForName:@"s:Body"] firstObject];
        GDataXMLElement *findItemResponse = [[soapBody elementsForName:@"m:FindItemResponse"] firstObject];
        GDataXMLElement *responseMessages = [[findItemResponse elementsForName:@"m:ResponseMessages"] firstObject];
        GDataXMLElement *findItemResponseMessage = [[responseMessages elementsForName:@"m:FindItemResponseMessage"] firstObject];
        GDataXMLElement *responseCode = [[findItemResponseMessage elementsForName:@"m:ResponseCode"] firstObject];
        if ([[responseCode stringValue] isEqualToString:@"NoError"]) {
            GDataXMLElement *rootFolder = [[findItemResponseMessage elementsForName:@"m:RootFolder"] firstObject];
            GDataXMLNode *includesLastItemInRange = [rootFolder attributeForName:@"IncludesLastItemInRange"];
            BOOL hasNextPage = NO;
            if ([[includesLastItemInRange stringValue] isEqualToString:@"false"]) {
                hasNextPage = YES;
            }
            GDataXMLElement *items = [[rootFolder elementsForName:@"t:Items"] firstObject];
            NSArray *contacts = [items elementsForName:@"t:Contact"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (GDataXMLElement *contact in contacts) {
                JDContactListMode *model = [[JDContactListMode alloc] init];
                GDataXMLElement *itemIdElement = [[contact elementsForName:@"t:ItemId"] firstObject];
                GDataXMLNode *idNode = [itemIdElement attributeForName:@"Id"];
                GDataXMLNode *changeKeyNode = [itemIdElement attributeForName:@"ChangeKey"];
                model.itemId = [idNode stringValue];
                model.changeKey = [changeKeyNode stringValue];
                GDataXMLElement *hasAttachmentsElement = [[contact elementsForName:@"t:HasAttachments"] firstObject];
                model.hasAttachments = [hasAttachmentsElement stringValue];
                GDataXMLElement *cultureElement = [[contact elementsForName:@"t:Culture"] firstObject];
                model.culture = [cultureElement stringValue];
                GDataXMLElement *fileAsElement = [[contact elementsForName:@"t:FileAs"] firstObject];
                model.fileAs = [fileAsElement stringValue];
                GDataXMLElement *displayNameElement = [[contact elementsForName:@"t:DisplayName"] firstObject];
                model.displayName = [displayNameElement stringValue];
                GDataXMLElement *givenNameElement = [[contact elementsForName:@"t:GivenName"] firstObject];
                model.givenName = [givenNameElement stringValue];
                GDataXMLElement *surnameElement = [[contact elementsForName:@"t:Surname"] firstObject];
                model.surname = [surnameElement stringValue];
                GDataXMLElement *completeNameElement = [[contact elementsForName:@"t:CompleteName"] firstObject];
                GDataXMLElement *firstNameElement = [[completeNameElement elementsForName:@"t:FirstName"] firstObject];
                GDataXMLElement *lastNameElement = [[completeNameElement elementsForName:@"t:LastName"] firstObject];
                GDataXMLElement *fullNameElement = [[completeNameElement elementsForName:@"t:FullName"] firstObject];
                JDContactName *completeName = [[JDContactName alloc] init];
                completeName.firstName = [firstNameElement stringValue];
                completeName.lastName = [lastNameElement stringValue];
                completeName.fullName = [fullNameElement stringValue];
                model.completeName = completeName;
                // EmailAddresses
                GDataXMLElement *emailAddressesElement = [[contact elementsForName:@"t:EmailAddresses"] firstObject];
                NSArray *emailList = [emailAddressesElement elementsForName:@"t:Entry"];
                NSMutableArray *emailAddresses = [NSMutableArray array];
                for (GDataXMLElement *entryElement in emailList) {
                    GDataXMLNode *keyNode = [entryElement attributeForName:@"Key"];
                    JDContactPhone *email = [[JDContactPhone alloc] init];
                    email.entry = [entryElement stringValue];
                    email.key = [keyNode stringValue];
                    [emailAddresses addObject:email];
                }
                model.emailAddresses = emailAddresses;
                // PhoneNumbers
                GDataXMLElement *phoneNumbersElement = [[contact elementsForName:@"t:PhoneNumbers"] firstObject];
                NSArray *phoneList = [phoneNumbersElement elementsForName:@"t:Entry"];
                NSMutableArray *phoneNumbers = [NSMutableArray array];
                for (GDataXMLElement *entryElement in phoneList) {
                    GDataXMLNode *keyNode = [entryElement attributeForName:@"Key"];
                    JDContactPhone *phone = [[JDContactPhone alloc] init];
                    phone.entry = [entryElement stringValue];
                    phone.key = [keyNode stringValue];
                    [phoneNumbers addObject:phone];
                }
                model.phoneNumbers = phoneNumbers;
                [tempArray addObject:model];
            }
            // 请求成功
            dispatch_async(dispatch_get_main_queue(), ^{
                if (hasNextPage) {
                    [strongSelf.refreshFooter endRefreshing];
                }else {
                    [strongSelf.refreshFooter endRefreshingWithNoMoreData];
                }
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                [strongSelf.dataArray addObjectsFromArray:tempArray];
                [strongSelf.tableView reloadData];
            });
        }else{
            // 请求失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.refreshFooter endRefreshing];
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        __strong JDContactListController *strongSelf = weakSelf;
        NSLog(@"失败%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.refreshFooter endRefreshing];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        });
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDContactListMode *model = [self.dataArray objectAtIndex:indexPath.row];
    JDContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDContactCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    [cell reloadWithModel:model];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"星标"handler:^(UITableViewRowAction *action, NSIndexPath *index) {
        
    }];
    UITableViewRowAction *addAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"添加"handler:^(UITableViewRowAction *action, NSIndexPath *index) {
        
    }];
    return @[starAction, addAction];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0))
{
    UIContextualAction *starAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"星标" handler:^(UIContextualAction *action, __kindof UIView *sourceView, void (^completionHandler)(BOOL)) {
        
        
        if(completionHandler) {
            completionHandler(YES);
        }
    }];
    starAction.backgroundColor = [UIColor greenColor];
    UIContextualAction *addAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"添加" handler:^(UIContextualAction *action, __kindof UIView *sourceView, void (^completionHandler)(BOOL)) {
        
        
        if(completionHandler) {
            completionHandler(YES);
        }
    }];
    addAction.backgroundColor = [UIColor redColor];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[starAction, addAction]];
    return config;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configSwipeButton];
}

- (void)configSwipeButton
{
    // iOS 11层级: UITableView -> UISwipeActionPullView
    for (UIView *subview in self.tableView.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")]) {
            for (UIView *button in subview.subviews) {
                UIButton *swapBtn = (UIButton *)button;
                if ([swapBtn isKindOfClass:[UIButton class]]) {
                    if ([swapBtn.titleLabel.text isEqualToString:@"添加"]) {
                        [swapBtn setImage:[UIImage imageNamed:@"header_icon_back"] forState:UIControlStateNormal];
                    }
                    if ([swapBtn.titleLabel.text isEqualToString:@"星标"]) {
                        [swapBtn setImage:[UIImage imageNamed:@"header_icon_back"] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JDContactListMode *model = [self.dataArray objectAtIndex:indexPath.row];
    JDContactDetailController *detail = [[JDContactDetailController alloc] init];
    detail.itemId = model.itemId;
    detail.changeKey = model.changeKey;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - getter/setter

- (MJRefreshGifHeader *)refreshHeader
{
    if (!_refreshHeader) {
        _refreshHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshDidTrigger)];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=10; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
            [idleImages addObject:image];
        }
        [_refreshHeader setImages:idleImages forState:MJRefreshStateIdle];
        [_refreshHeader setImages:idleImages forState:MJRefreshStatePulling];
        [_refreshHeader setImages:idleImages forState:MJRefreshStateRefreshing];
        
        [_refreshHeader setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [_refreshHeader setTitle:@"松手刷新" forState:MJRefreshStatePulling];
        [_refreshHeader setTitle:@"正在加载 ..." forState:MJRefreshStateRefreshing];
    }
    return _refreshHeader;
}

- (MJRefreshBackGifFooter *)refreshFooter
{
    if (!_refreshFooter) {
        _refreshFooter = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshDidTrigger)];
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=10; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
            [idleImages addObject:image];
        }
        [_refreshFooter setImages:idleImages forState:MJRefreshStateRefreshing];
        [_refreshFooter setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        [_refreshFooter setTitle:@"正在加载更多数据" forState:MJRefreshStateRefreshing];
        [_refreshFooter setTitle:@"已经全部加载完毕" forState:MJRefreshStateNoMoreData];
    }
    return _refreshFooter;
}

- (JDContactHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JDContactHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), 60.0)];
        __weak JDContactListController *weakSelf = self;
        _headerView.addBlock = ^{
            __strong JDContactListController *strongSelf = weakSelf;
            JDNewContactController *newContact = [[JDNewContactController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:newContact];
            [strongSelf presentViewController:nav animated:YES completion:nil];
        };
        _headerView.contactsBlock = ^{
            
        };
        _headerView.groupBlock = ^{
            
        };
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = self.refreshHeader;
        _tableView.mj_footer = self.refreshFooter;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), 34.0)];
        [_tableView registerClass:[JDContactCell class] forCellReuseIdentifier:@"JDContactCell"];
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

@end
