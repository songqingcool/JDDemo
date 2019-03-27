//
//  JDSlipMenu.m
//  JDMail
//
//  Created by 公司 on 2019/1/22.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDSlipMenu.h"
#import "JDSlipMenuHeaderView.h"
#import "JDSlipMenuLeftView.h"
#import "JDSlipMenuCell.h"

#define kRightGap 60.0
#define kHeaderHeight 120.0
#define kLeftWidth 70.0

@interface JDSlipMenu ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JDSlipMenuHeaderView *headerView;
@property (nonatomic, strong) JDSlipMenuLeftView *leftView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JDSlipMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeGesture];
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.headerView];
    [self addSubview:self.leftView];
    [self addSubview:self.tableView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
}

- (void)reloadFolderList:(NSArray *)folderList
         currentFolderId:(NSString *)currentFolderId
{
    self.dataArray = folderList;
    [self.tableView reloadData];
    
    NSInteger selectIndex = -1;
    for (int i = 0; i<folderList.count; i++) {
        NSDictionary *folderDict = [folderList objectAtIndex:i];
        NSString *folderId = [folderDict objectForKey:@"folderId"];
        if ([currentFolderId isEqualToString:folderId]) {
            selectIndex = i;
            break;
        }
    }
    
    if (selectIndex != -1) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)show
{
    CGFloat frameX = 0.0;
    CGFloat frameY = 0.0;
    CGFloat frameW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat frameH = CGRectGetHeight([UIScreen mainScreen].bounds);
    self.frame = CGRectMake(frameX, frameY, frameW, frameH);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGFloat leftY = 0.0;
    CGFloat leftW =  kLeftWidth;
    CGFloat leftH = CGRectGetHeight(self.bounds);
    CGFloat leftX = 0.0-(CGRectGetWidth(self.bounds)-kRightGap);
    self.leftView.frame = CGRectMake(leftX, leftY, leftW, leftH);
    
    CGFloat headerY = 0.0;
    CGFloat headerW = CGRectGetWidth(self.bounds)-kRightGap-kLeftWidth;
    CGFloat headerH = kHeaderHeight;
    CGFloat headerX = kLeftWidth-(CGRectGetWidth(self.bounds)-kRightGap);
    self.headerView.frame = CGRectMake(headerX, headerY, headerW, headerH);
    
    CGFloat tableY = CGRectGetMaxY(self.headerView.frame);
    CGFloat tableW = CGRectGetWidth(self.bounds)-kRightGap-kLeftWidth;
    CGFloat tableH = CGRectGetHeight(self.bounds)-kHeaderHeight;
    CGFloat tableX = kLeftWidth-(CGRectGetWidth(self.bounds)-kRightGap);
    self.tableView.frame = CGRectMake(tableX, tableY, tableW, tableH);
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat leftTX = 0.0;
        CGFloat leftTY = 0.0;
        CGFloat leftTW = kLeftWidth;
        CGFloat leftTH = CGRectGetHeight(self.bounds);
        self.leftView.frame = CGRectMake(leftTX, leftTY, leftTW, leftTH);
        
        CGFloat headerTX = kLeftWidth;
        CGFloat headerTY = 0.0;
        CGFloat headerTW = CGRectGetWidth(self.bounds)-kRightGap-kLeftWidth;
        CGFloat headerTH = kHeaderHeight;
        self.headerView.frame = CGRectMake(headerTX, headerTY, headerTW, headerTH);
        
        CGFloat tableTX = kLeftWidth;
        CGFloat tableTY = CGRectGetMaxY(self.headerView.frame);
        CGFloat tableTW = CGRectGetWidth(self.bounds)-kRightGap-kLeftWidth;
        CGFloat tableTH = CGRectGetHeight(self.bounds)-kHeaderHeight;
        self.tableView.frame = CGRectMake(tableTX, tableTY, tableTW, tableTH);
        self.backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissWithCompletion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat leftY = 0.0;
        CGFloat leftW = kLeftWidth;
        CGFloat leftH = CGRectGetHeight(self.bounds);
        CGFloat leftX = 0.0-(CGRectGetWidth(self.bounds)-kRightGap);
        self.leftView.frame = CGRectMake(leftX, leftY, leftW, leftH);
        
        CGFloat headerTY = 0.0;
        CGFloat headerTW = CGRectGetWidth(self.bounds)-kRightGap-kLeftWidth;
        CGFloat headerTH = kHeaderHeight;
        CGFloat headerTX = kLeftWidth-(CGRectGetWidth(self.bounds)-kRightGap);
        self.headerView.frame = CGRectMake(headerTX, headerTY, headerTW, headerTH);
        
        CGFloat tableY = CGRectGetMaxY(self.headerView.frame);
        CGFloat tableW = CGRectGetWidth(self.bounds)-kRightGap-kLeftWidth;
        CGFloat tableH = CGRectGetHeight(self.bounds)-kHeaderHeight;
        CGFloat tableX = kLeftWidth-(CGRectGetWidth(self.bounds)-kRightGap);
        self.tableView.frame = CGRectMake(tableX, tableY, tableW, tableH);
        self.backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completion) {
            completion(finished);
        }
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
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.imageView.image = [UIImage imageNamed:[dict objectForKey:@"icon"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissWithCompletion:nil];
    NSDictionary *model = [self.dataArray objectAtIndex:indexPath.row];
    if (self.folderBlock) {
        self.folderBlock(model);
    }
}

#pragma mark - Setter

- (void)setAccountsArray:(NSArray *)accountsArray
{
    _accountsArray = accountsArray;
    [self.leftView reloadWithAccounts:accountsArray];
}

- (void)setCurrentAccount:(NSDictionary *)currentAccount
{
    _currentAccount = currentAccount;
    [self.headerView reloadWithModel:currentAccount];
}

#pragma mark - Getter

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureAction:)];
        [_backgroundView addGestureRecognizer:singleGesture];
    }
    return _backgroundView;
}

- (void)singleTapGestureAction:(UITapGestureRecognizer *)sender
{
    [self dismissWithCompletion:nil];
}

- (void)swipeGestureAction:(UITapGestureRecognizer *)sender
{
    [self dismissWithCompletion:nil];
}

- (JDSlipMenuLeftView *)leftView
{
    if (!_leftView) {
        _leftView = [[JDSlipMenuLeftView alloc] init];
        __weak JDSlipMenu *weakSelf = self;
        _leftView.accountBlock = ^(NSDictionary *account) {
            __strong JDSlipMenu *strongSelf = weakSelf;
            [strongSelf dismissWithCompletion:^(BOOL finished) {
                if (strongSelf.accountBlock) {
                    strongSelf.accountBlock(account);
                }
            }];
        };
        _leftView.addBlock = ^{
            __strong JDSlipMenu *strongSelf = weakSelf;
            [strongSelf dismissWithCompletion:^(BOOL finished) {
                if (strongSelf.addBlock) {
                    strongSelf.addBlock();
                }
            }];
        };
        _leftView.settingBlock = ^{
            __strong JDSlipMenu *strongSelf = weakSelf;
            [strongSelf dismissWithCompletion:^(BOOL finished) {
                if (strongSelf.settingBlock) {
                    strongSelf.settingBlock();
                }
            }];
        };
    }
    return _leftView;
}

- (JDSlipMenuHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JDSlipMenuHeaderView alloc] init];
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), 34.0)];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [_tableView registerClass:[JDSlipMenuCell class] forCellReuseIdentifier:@"JDSlipMenuCell"];
    }
    return _tableView;
}

@end
