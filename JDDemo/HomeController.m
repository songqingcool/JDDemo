//
//  HomeController.m
//  JDDemo
//
//  Created by 宋庆功 on 2018/11/26.
//  Copyright © 2018 京东. All rights reserved.
//

#import "HomeController.h"

@interface HomeController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.dataArray removeAllObjects];
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setValue:@"球" forKey:@"title"];
    [dict1 setValue:@"SphereController" forKey:@"target"];
    [self.dataArray addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setValue:@"圆盘" forKey:@"title"];
    [dict2 setValue:@"CircleController" forKey:@"target"];
    [self.dataArray addObject:dict2];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setValue:@"动画" forKey:@"title"];
    [dict3 setValue:@"AnimationController" forKey:@"target"];
    [self.dataArray addObject:dict3];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    [dict4 setValue:@"看大图" forKey:@"title"];
    [dict4 setValue:@"JDImageBrowserController" forKey:@"target"];
    [self.dataArray addObject:dict4];
    
    NSMutableDictionary *dict5 = [NSMutableDictionary dictionary];
    [dict5 setValue:@"指纹/面容ID" forKey:@"title"];
    [dict5 setValue:@"FaceIDController" forKey:@"target"];
    [self.dataArray addObject:dict5];
    
    NSMutableDictionary *dict6 = [NSMutableDictionary dictionary];
    [dict6 setValue:@"FloatIndexTableView" forKey:@"title"];
    [dict6 setValue:@"FloatIndexController" forKey:@"target"];
    [self.dataArray addObject:dict6];
    
    NSMutableDictionary *dict7 = [NSMutableDictionary dictionary];
    [dict7 setValue:@"JDVideoPlayer" forKey:@"title"];
    [dict7 setValue:@"JDVideoPlayerController" forKey:@"target"];
    [self.dataArray addObject:dict7];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
}

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
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *title = [model objectForKey:@"title"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *target = [model objectForKey:@"target"];
    UIViewController *root = [[NSClassFromString(target) alloc] init];
    if (indexPath.row == 3) {
        [self.navigationController presentViewController:root animated:YES completion:nil];
        return;
    }
    
    [self.navigationController pushViewController:root animated:YES];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
