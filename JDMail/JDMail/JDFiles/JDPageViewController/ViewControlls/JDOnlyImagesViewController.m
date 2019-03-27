
//
//  JDOnlyImagesViewController.m
//  JDMail
//
//  Created by 千阳 on 2019/1/28.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDOnlyImagesViewController.h"
#import <Masonry.h>

@interface JDOnlyImagesViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation JDOnlyImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"stop");
}

- (void)updateViewConstraints
{
    [self tableViewConstraints];
    [super updateViewConstraints];
}

- (void)tableViewConstraints
{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        
    }];
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellTestIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    NSLog(@"aasf");
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED
{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        //1.更新数据
        
        //2.更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor cyanColor];
    //添加一个置顶按钮
    UITableViewRowAction *topRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        //1.更新数据
        //2.更新UI
        NSIndexPath *firstIndexPath =[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    //置顶按钮颜色
    topRowAction.backgroundColor = [UIColor magentaColor];
    //--------更多
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        
    }];
    //背景特效
    //moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)]；
    //----------收藏
    UITableViewRowAction *collectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"收藏" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"收藏" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
    }];
    //收藏按钮颜色
    collectRowAction.backgroundColor = [UIColor greenColor];
    
    //将设置好的按钮方到数组中返回
    return @[deleteAction,topRowAction,moreRowAction,collectRowAction];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"stop");
    return YES;
}
@end
