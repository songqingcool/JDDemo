//
//  CircleController.m
//  JDDemo
//
//  Created by 宋庆功 on 2018/11/26.
//  Copyright © 2018 京东. All rights reserved.
//

#import "CircleController.h"
#import "JDRotationView.h"
#import "JDRotationHalfView.h"

@interface CircleController ()

@property (nonatomic, strong) JDRotationView *rotationView;
@property (nonatomic, strong) JDRotationHalfView *rotationHalfView;

@end

@implementation CircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    // 自定义的转盘视图
    self.rotationView = [[JDRotationView alloc] initWithFrame:CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds)-270.0)/2.0, 120.0, 270.0, 270.0)];
    self.rotationView.layer.contents = (__bridge id)[UIImage imageNamed:@"home_center_bg"].CGImage;
    [self.view addSubview:self.rotationView];
    
    [self.rotationView reloadWithModelList:@[@{@"title":@"button1"},@{@"title":@"button2"},@{@"title":@"button3"},@{@"title":@"button4"},@{@"title":@"button5"},@{@"title":@"button6"},@{@"title":@"button7"}]];
    self.rotationView.centerModel = @{@"title":@"button8"};
    
    
    // 自定义的转盘视图
    self.rotationHalfView = [[JDRotationHalfView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.rotationView.frame)+10.0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds))];
    [self.view addSubview:self.rotationHalfView];
    [self.rotationHalfView reloadWithModelList:@[@{@"title":@"button1"},@{@"title":@"button2"},@{@"title":@"button3"},@{@"title":@"button4"},@{@"title":@"button5"},@{@"title":@"button6"},@{@"title":@"button7"}]];
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
