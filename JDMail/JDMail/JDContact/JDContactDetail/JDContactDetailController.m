//
//  JDContactDetailController.m
//  JDMail
//
//  Created by 公司 on 2019/3/8.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDContactDetailController.h"
#import <Masonry/Masonry.h>
#import "JDMailMessageBuilder.h"
#import "JDNetworkManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "GDataXMLNode.h"
#import "JDContactDetailModel.h"
#import "JDContactName.h"
#import "JDContactPhone.h"
#import "UIViewController+Extend.h"
#import "JDContactDetailHeaderView.h"
#import "JDAccountManager.h"
#import "JDAccount.h"

@interface JDContactDetailController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JDContactDetailModel *detailModel;
@property (nonatomic, strong) JDContactDetailHeaderView *headerView;

@end

@implementation JDContactDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"联系人信息";
    [self setDefaultGoBackButton];
    
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    [self.tableView reloadData];
    [self loadContactDetail];
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

- (void)loadContactDetail
{
    NSMutableArray *tempList = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.itemId forKey:@"ItemId"];
    [dict setValue:self.changeKey forKey:@"ChangeKey"];
    [tempList addObject:dict];
    NSString *getItemsString = [[JDMailMessageBuilder new] ewsSoapMessageGetItemWithItems:tempList includeMimeContent:@"false"];
    __weak JDContactDetailController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[JDNetworkManager shareManager] POSTWithAccount:[JDAccountManager shareManager].currentAccount.account httpBodyString:getItemsString success:^(NSURLSessionDataTask *task, NSData *responseObject) {
        __strong JDContactDetailController *strongSelf = weakSelf;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithData:responseObject options:0 error:nil];
        GDataXMLElement *rootElement = [document rootElement];
        GDataXMLElement *soapBody = [[rootElement elementsForName:@"s:Body"] firstObject];
        GDataXMLElement *getItemResponse = [[soapBody elementsForName:@"m:GetItemResponse"] firstObject];
        GDataXMLElement *responseMessages = [[getItemResponse elementsForName:@"m:ResponseMessages"] firstObject];
        GDataXMLElement *getItemResponseMessage = [[responseMessages elementsForName:@"m:GetItemResponseMessage"] firstObject];
        GDataXMLElement *responseCode = [[getItemResponseMessage elementsForName:@"m:ResponseCode"] firstObject];
        if ([[responseCode stringValue] isEqualToString:@"NoError"]) {
            GDataXMLElement *items = [[getItemResponseMessage elementsForName:@"m:Items"] firstObject];
            GDataXMLElement *contact = [[items elementsForName:@"t:Contact"] firstObject];
            JDContactDetailModel *model = [[JDContactDetailModel alloc] init];
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
            GDataXMLElement *completeNameElement = [[contact elementsForName:@"t:CompleteName"] firstObject];
            GDataXMLElement *firstNameElement = [[completeNameElement elementsForName:@"t:FirstName"] firstObject];
            GDataXMLElement *lastNameElement = [[completeNameElement elementsForName:@"t:LastName"] firstObject];
            GDataXMLElement *fullNameElement = [[completeNameElement elementsForName:@"t:FullName"] firstObject];
            JDContactName *completeName = [[JDContactName alloc] init];
            completeName.firstName = [firstNameElement stringValue];
            completeName.lastName = [lastNameElement stringValue];
            completeName.fullName = [fullNameElement stringValue];
            model.completeName = completeName;
            GDataXMLElement *companyNameElement = [[contact elementsForName:@"t:CompanyName"] firstObject];
            model.companyName = [companyNameElement stringValue];
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
            GDataXMLElement *jobTitleElement = [[contact elementsForName:@"t:JobTitle"] firstObject];
            model.jobTitle = [jobTitleElement stringValue];
            GDataXMLElement *surnameElement = [[contact elementsForName:@"t:Surname"] firstObject];
            model.surname = [surnameElement stringValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                strongSelf.detailModel = model;
                [strongSelf.headerView updateWithModel:model];
            });
        }else{ // 失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        __strong JDContactDetailController *strongSelf = weakSelf;
        NSLog(@"失败%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
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
    //    JDContactListMode *model = [self.dataArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    //    [cell reloadWithModel:model];
    return cell;
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
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), 34.0)];
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

- (JDContactDetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JDContactDetailHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), 255.0)];
    }
    return _headerView;
}

@end
