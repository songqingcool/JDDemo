//
//  JDMailListController.m
//  JDMail
//
//  Created by 公司 on 2018/12/24.
//  Copyright © 2018 公司. All rights reserved.
//

#import "JDMailListController.h"
#import <Masonry/Masonry.h>
#import "JDSlipMenu.h"
#import "JDSettingsViewController.h"
#import "JDMailListModel.h"
#import "JDMailListCell.h"
#import "JDEditSendEmailController.h"
#import "JDAccountManager.h"
#import "JDAccount.h"
#import "JDLoginController.h"
#import <MJRefresh/MJRefresh.h>
#import "JDMailDetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "JDSendEmailModel.h"
#import "JDMailSyncManager.h"
#import "JDMailFolder.h"
#import "JDNetworkManager.h"
#import "JDMailMessageBuilder.h"
#import "JDMailDBManager.h"
#import "JDAppDBManager.h"

@interface JDMailListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MJRefreshGifHeader *refreshHeader;
@property (nonatomic, strong) MJRefreshBackGifFooter *refreshFooter;
@property (nonatomic, strong) JDSlipMenu *slipMenu;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedArrM;
@property (nonatomic, strong) JDMailFolder *folder;

@property (nonatomic, strong) NSMutableArray *folderDataArray;

@end

@implementation JDMailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"收件箱";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    
    // 加载侧滑菜单账号信息
    [self loadMenuAccountsData];
    [self loadMenuHeaderDataWithCurrentAccount:[JDAccountManager shareManager].currentAccount];
    // 同步文件夹和邮件列表
    [self syncFolderHierarchyWithChangeCurrentFolder:YES];
    
    [self setNavigationBarButtonItem];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewLongPressAction:)];
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountDidChanage:) name:@"AccountDidChanage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentAccountDidChanage:) name:@"CurrentAccountDidChanage" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)accountDidChanage:(NSNotification *)notification
{
    // 加载侧滑菜单账号信息
    [self loadMenuAccountsData];
}

- (void)currentAccountDidChanage:(NSNotification *)notification
{
    // 加载侧滑菜单账号信息
    [self loadMenuHeaderDataWithCurrentAccount:[JDAccountManager shareManager].currentAccount];
    // 同步文件夹和邮件列表
    [self syncFolderHierarchyWithChangeCurrentFolder:YES];
}

- (void)setNavigationBarButtonItem
{
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mail_slip"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemDidClicked:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mail_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemDidClicked:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)leftBarButtonItemDidClicked:(UIBarButtonItem *)sender
{
    [self.slipMenu show];
}

- (void)rightBarButtonItemDidClicked:(UIBarButtonItem *)sender
{
    JDEditSendEmailController *sendVC = [[JDEditSendEmailController alloc] init];
    sendVC.model.emialSendType = EmailSendNormal;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sendVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)tableViewLongPressAction:(UILongPressGestureRecognizer *)recognizer
{
    [self.tableView setEditing:YES];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(navigationDeleteEmail:)];
    UIBarButtonItem *cancelItmd = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(navigationCancelEdit:)];
    
    self.navigationItem.leftBarButtonItem = cancelItmd;
    self.navigationItem.rightBarButtonItem = deleteItem;
}

- (void)navigationDeleteEmail:(UIBarButtonItem *)sender
{
    if(self.selectedArrM.count > 0) {
        [self deleteEmail:self.selectedArrM];
    }
}

- (void)navigationCancelEdit:(UIBarButtonItem *)sender
{
    [self.selectedArrM removeAllObjects];
    [self.tableView setEditing:NO];
    [self setNavigationBarButtonItem];
    self.navigationItem.title = @"收件箱";
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

- (void)loadMenuHeaderDataWithCurrentAccount:(JDAccount *)account
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:account.nickName forKey:@"title"];
    [dict setValue:account.account forKey:@"subtitle"];
    self.slipMenu.currentAccount = dict;
}

- (void)loadMenuAccountsData
{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSArray *accountsArray = [JDAccountManager shareManager].accountsArray;
    for (JDAccount *tempAccount in accountsArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:tempAccount.avatar forKey:@"icon"];
        [dict setValue:tempAccount forKey:@"account"];
        [tempArray addObject:dict];
    }
    self.slipMenu.accountsArray = tempArray;
}

- (void)loadMenuFolderData
{
    NSMutableArray *array = [NSMutableArray array];
    for (JDMailFolder *folder in self.folderDataArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"mail_inbox_normal" forKey:@"icon"];
        [dict setValue:folder.displayName forKey:@"title"];
        [dict setValue:folder.folderId forKey:@"folderId"];
        [dict setValue:folder forKey:@"folder"];
        [array addObject:dict];
    }
    [self.slipMenu reloadFolderList:array currentFolderId:self.folder.folderId];
}

- (void)syncFolderHierarchyWithChangeCurrentFolder:(BOOL)isChanage
{
    NSString *account = [JDAccountManager shareManager].currentAccount.account;
    NSString *syncState = [[JDAppDBManager shareManager] queryfolderSyncStateWithAccount:account];
    __weak JDMailListController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[JDMailSyncManager shareManager] syncFolderHierarchyWithAccount:account syncState:syncState success:^{
        __strong JDMailListController *strongSelf = weakSelf;
        // 数据库读取文件夹数据
        NSArray *folderList = [[JDMailDBManager shareManager] queryFolderWithAccount:account];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.folderDataArray removeAllObjects];
            [strongSelf.folderDataArray addObjectsFromArray:folderList];
            // 是否需要切换文件夹
            if (isChanage) {
                JDMailFolder *folder = strongSelf.folderDataArray.firstObject;
                strongSelf.navigationItem.title = folder.displayName;
                strongSelf.folder = folder;
            }
            [strongSelf loadMenuFolderData];
            [strongSelf syncFolderItems];
        });
    } failure:^(NSError *error) {
        __strong JDMailListController *strongSelf = weakSelf;
        NSLog(@"失败%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.refreshHeader endRefreshing];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        });
    }];
}

- (void)syncFolderItems
{
    NSString *account = [JDAccountManager shareManager].currentAccount.account;
    NSString *folderId = self.folder.folderId;
    NSString *changeKey = self.folder.changeKey;
    NSString *syncState = [[JDMailDBManager shareManager] queryFolderSyncStateWithAccount:account folderId:folderId];
    if (folderId.length == 0) {
        NSLog(@"当前未选中文件夹");
        return;
    }
    __weak JDMailListController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[JDMailSyncManager shareManager] syncFolderItemsWithAccount:account folderId:folderId folderChangeKey:changeKey syncState:syncState success:^{
        __strong JDMailListController *strongSelf = weakSelf;
        // 数据库读取文件夹数据
        NSArray *emailItemList = [[JDMailDBManager shareManager] queryEmailItemWithAccount:account folderId:folderId lastReceivedTime:@"" pageSize:@"20"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.refreshHeader endRefreshing];
            if (emailItemList.count<20) {
                [strongSelf.refreshFooter endRefreshingWithNoMoreData];
            }else {
                [strongSelf.refreshFooter endRefreshing];
            }
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            
            [strongSelf.dataArray removeAllObjects];
            [strongSelf.dataArray addObjectsFromArray:emailItemList];
            [strongSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        __strong JDMailListController *strongSelf = weakSelf;
        NSLog(@"失败%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.refreshHeader endRefreshing];
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        });
    }];
}

- (void)headerRefreshDidTrigger
{
    [self syncFolderHierarchyWithChangeCurrentFolder:NO];
}

- (void)footerRefreshDidTrigger
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *account = [JDAccountManager shareManager].currentAccount.account;
    NSString *folderId = self.folder.folderId;
    JDMailListModel *model = self.dataArray.lastObject;
    NSString *lastReceivedTime = model.dateTimeReceived;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 数据库读取文件夹数据
        NSArray *emailItemList = [[JDMailDBManager shareManager] queryEmailItemWithAccount:account folderId:folderId lastReceivedTime:lastReceivedTime pageSize:@"20"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (emailItemList.count<20) {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }else {
                [self.refreshFooter endRefreshing];
            }
            [self.dataArray addObjectsFromArray:emailItemList];
            [self.tableView reloadData];
        });
    });
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource

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
    return 110.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDMailListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    JDMailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JDMailListCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    [cell reloadWithModel:model];
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"更多click");
    }];
    moreAction.backgroundColor = [UIColor lightGrayColor];
    
    UITableViewRowAction *flagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"星标" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"星标click");
    }];
    flagAction.backgroundColor = [UIColor grayColor];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        JDMailListModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if(model)
            [self deleteEmail:@[model]];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    return @[deleteAction,flagAction,moreAction];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0))
{
    UIContextualAction *moreAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"更多" handler:^(UIContextualAction *action, __kindof UIView *sourceView, void (^completionHandler)(BOOL)) {
        
        
        if(completionHandler) {
            completionHandler(YES);
        }
    }];
    moreAction.backgroundColor = [UIColor lightGrayColor];
    
    UIContextualAction *flagAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"星标" handler:^(UIContextualAction *action, __kindof UIView *sourceView, void (^completionHandler)(BOOL)) {
        
        
        if(completionHandler) {
            completionHandler(YES);
        }
    }];
    flagAction.backgroundColor = [UIColor grayColor];
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"删除" handler:^(UIContextualAction *action, __kindof UIView *sourceView, void (^completionHandler)(BOOL)) {
        
        
        if(completionHandler) {
            completionHandler(YES);
        }
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction, flagAction, moreAction]];
    return config;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        JDMailListModel *mailModel = self.dataArray[indexPath.row];
        if(mailModel){
            JDMailDetailViewController *mailDetailVC = [[JDMailDetailViewController alloc] initWithModel:mailModel];
            [self.navigationController pushViewController:mailDetailVC animated:YES];
        }
    }else{
        [self.selectedArrM addObject:self.dataArray[indexPath.row]];
        self.navigationItem.title = [NSString stringWithFormat:@"收件箱(%lu)",(unsigned long)self.selectedArrM.count];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.isEditing) {
        [self.selectedArrM removeObject:self.dataArray[indexPath.row]];
        self.navigationItem.title = [NSString stringWithFormat:@"收件箱(%lu)",self.selectedArrM.count];
    }
}

- (void)deleteEmail:(NSArray *)models
{
    if(models.count == 0) {
        return ;
    }
    
    NSMutableArray *itemIds = [NSMutableArray array];
    for (JDMailListModel *model in models) {
        [itemIds addObject:model.itemId];
    }
    NSString *requestXml = [[JDMailMessageBuilder new] ewsSoapMessageDeleteEmailsByItems:itemIds];
    [[JDNetworkManager shareManager] POSTWithAccount:[JDAccountManager shareManager].currentAccount.account httpBodyString:requestXml success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (JDMailListModel *model in models) {
                [self.dataArray removeObject:model];
            }
            [self navigationCancelEdit:nil];
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"删除邮件失败：%@",error.description);
    }];
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
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), 34.0)];
        [_tableView registerClass:[JDMailListCell class] forCellReuseIdentifier:@"JDMailListCell"];
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

- (NSMutableArray *)selectedArrM
{
    if(!_selectedArrM) {
        _selectedArrM = [NSMutableArray array];
    }
    return _selectedArrM;
}

- (NSMutableArray *)folderDataArray
{
    if (!_folderDataArray) {
        _folderDataArray = [NSMutableArray array];
    }
    return _folderDataArray;
}

- (JDSlipMenu *)slipMenu
{
    if (!_slipMenu) {
        _slipMenu = [[JDSlipMenu alloc] init];
        __weak JDMailListController *weakSelf = self;
        _slipMenu.settingBlock = ^{
            __strong JDMailListController *strongSelf = weakSelf;
            JDSettingsViewController *settingsVC = [[JDSettingsViewController alloc] init];
            [strongSelf.navigationController pushViewController:settingsVC animated:YES];
        };
        _slipMenu.folderBlock = ^(NSDictionary *folderModel) {
            __strong JDMailListController *strongSelf = weakSelf;
            JDMailFolder *folder = [folderModel objectForKey:@"folder"];
            NSString *title = [folderModel objectForKey:@"title"];
            strongSelf.navigationItem.title = title;
            strongSelf.folder = folder;
            [strongSelf syncFolderItems];
        };
        _slipMenu.addBlock = ^{
            __strong JDMailListController *strongSelf = weakSelf;
            JDLoginController *loginVC = [[JDLoginController alloc] init];
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [strongSelf presentViewController:loginNav animated:YES completion:nil];
        };
        _slipMenu.accountBlock = ^(NSDictionary *accountDict) {
            JDAccount *acc = [accountDict objectForKey:@"account"];
            JDAccount *currentAcc = [JDAccountManager shareManager].currentAccount;
            if ([acc.account isEqualToString:currentAcc.account]) {
                return ;
            }
            [[JDAccountManager shareManager] changeCurrentAccount:acc];
        };
    }
    return _slipMenu;
}

@end
