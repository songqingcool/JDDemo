//
//  FloatIndexController.m
//  JDDemo
//
//  Created by 公司 on 2019/2/12.
//  Copyright © 2019 公司. All rights reserved.
//

#import "FloatIndexController.h"
#import "JDFloatIndexTableView.h"

@interface FloatIndexController ()<UITableViewDelegate, UITableViewDataSource, JDTableViewIndexViewDataSource>

@property (nonatomic, strong) JDFloatIndexTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation FloatIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView = [[JDFloatIndexTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.indexDataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}
// header按照正常的tableview自定义
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @[@"A",@"B",@"C",@"D",@"#"][section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *model = [self.dataArray objectAtIndex:indexPath.row];
//    NSString *title = [model objectForKey:@"title"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
//    cell.textLabel.text = title;
    return cell;
}

#pragma mark - JDTableViewIndexViewDataSource
// 右侧index的数据源，最前面放置icon的资源文件名
- (NSArray *)sectionIndexTitlesForIndexTableView:(JDFloatIndexTableView *)tableView
{
    return @[@"dog",@"A",@"B",@"C",@"D",@"#"];
}

// 多少个图片类型icon
- (NSInteger)numberOfImageSectionsInIndexTableView:(JDFloatIndexTableView *)tableView
{
    return 1;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
