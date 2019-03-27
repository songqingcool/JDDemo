
//
//  JDSettingsViewController.m
//  JDMail
//
//  Created by 千阳 on 2019/1/23.
//  Copyright © 2019 公司. All rights reserved.
//

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScrrentWidth [UIScreen mainScreen].bounds.size.width

#import "JDSettingsViewController.h"
#import "JDSettingsAccountCell.h"
#import "JDSettingsNormalCell.h"
#import "ViewControllers/JDAccountManagerController.h"
#import "ViewControllers/EmailSignatureViewController.h"

@interface JDSettingsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation JDSettingsViewController
{
    @private
    
    NSMutableDictionary *dataSourceDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    dataSourceDic = @{
                      @"section0":@{@"李博":@"libo@jd.com"},
                      @"section1":@[@{@"邮件签名":@""},
                                    @{@"邮件模式":@""},
                                    @{@"提醒设置":@""},
                                    @{@"密码保护":@""},
                                    @{@"语言":@""}],
                      @"section2":@[@{@"清除缓存":@"163.6k"},
                                  @{@"意见反馈":@""},
                                  @{@"关于":@"1.2.1"}]
                      };
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        CGRect rect = CGRectMake(0, 0, ScrrentWidth, ScreenHeight);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0.0;
        _tableView.estimatedSectionHeaderHeight = 0.0;
        _tableView.estimatedSectionFooterHeight = 0.0;
        
        [_tableView registerClass:[JDSettingsAccountCell class] forCellReuseIdentifier:@"SettingsAccountCellIdentifier"];
        [_tableView registerClass:[JDSettingsNormalCell class] forCellReuseIdentifier:@"SettingsNormalCellIdentifier"];
    }
    return _tableView;
}

#pragma mark - UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger count = [dataSourceDic allKeys].count;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if(section == 0)
    {
        number = [((NSArray *)dataSourceDic[@"section0"]) count];
    }
    else if(section == 1)
    {
        number = [((NSArray *)dataSourceDic[@"section1"]) count];
    }
    else if(section == 2)
    {
        number = [((NSArray *)dataSourceDic[@"section2"]) count];
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 80;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
   
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionHeader = nil;
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;// [tableView dequeueReusableCellWithIdentifier:@"SettingsAccountCellIdentifier" forIndexPath:indexPath];
    if(indexPath.section == 0)
    {
        cell = [[JDSettingsAccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsAccountCellIdentifier"];
        [((JDSettingsAccountCell *)cell) reloadWithModel:dataSourceDic[@"section0"]];
    }
    else if(indexPath.section == 1)
    {
        cell = [[JDSettingsNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsNormalCellIdentifier"];
        NSArray *array = (NSArray *)dataSourceDic[@"section1"];
        [((JDSettingsNormalCell *)cell) reloadWithModel:array[indexPath.row]];
    }
    else if(indexPath.section == 2)
    {
        cell = [[JDSettingsNormalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsNormalCellIdentifier"];
        
        NSArray *array = (NSArray *)dataSourceDic[@"section2"];
        [((JDSettingsNormalCell *)cell) reloadWithModel:array[indexPath.row]];
        
    }
    

    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        JDAccountManagerController *accountManagerController = [[JDAccountManagerController alloc] init];
        [self.navigationController pushViewController:accountManagerController animated:YES];
    }
    else if(indexPath.section ==1 && indexPath.row == 0)
    {
        EmailSignatureViewController *emailSingnatureVC = [[EmailSignatureViewController alloc] init];
          [self.navigationController pushViewController:emailSingnatureVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
