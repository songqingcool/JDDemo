//
//  SphereController.m
//  JDDemo
//
//  Created by 宋庆功 on 2018/11/26.
//  Copyright © 2018 京东. All rights reserved.
//

#import "SphereController.h"
#import "JDSphereView.h"

@interface SphereController ()

@property (nonatomic, strong) JDSphereView *sphereView;

@end

@implementation SphereController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 调用展示
    self.sphereView = [[JDSphereView alloc] initWithFrame:CGRectMake(20, 200, 340, 340)];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 30; i ++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"dog"] forState:(UIControlStateNormal)];
        btn.frame = CGRectMake(0, 0, 60, 60);
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [array addObject:btn];
        [self.sphereView addSubview:btn];
    }
    [self.sphereView setCloudTags:array];
    [self.view addSubview:self.sphereView];
}

// 点击后的效果图
- (void)buttonPressed:(UIButton *)btn
{
    [self.sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(3.0, 3.0);
    } completion:^(BOOL finished) {
        // 放大后显示时长
        [UIView animateWithDuration:2.0 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [self.sphereView timerStart];
        }];
    }];
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
