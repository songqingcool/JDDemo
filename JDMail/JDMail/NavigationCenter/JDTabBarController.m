//
//  JDTabBarController.m
//  JDMail
//
//  Created by 公司 on 2018/12/24.
//  Copyright © 2018 公司. All rights reserved.
//

#import "JDTabBarController.h"
#import "JDNavigationController.h"

@interface JDTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) NSArray *settingsArray;

@end

@implementation JDTabBarController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    [self updateTabBarController];
}

- (NSArray *)settingsArray
{
    if (!_settingsArray) {
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"JDTabBarSetting" ofType:@"plist"]];
        _settingsArray = [dict objectForKey:@"items"];
    }
    return _settingsArray;
}

- (void)updateTabBarController
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in self.settingsArray) {
        NSString *title = [dict objectForKey:@"title"];
        NSString *normalImage = [dict objectForKey:@"normalimage"];
        NSString *selectedImage = [dict objectForKey:@"selectedimage"];
        NSString *controllerClass = [dict objectForKey:@"controller"];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:normalImage] selectedImage:[UIImage imageNamed:selectedImage]];
        UIViewController *controller = [[NSClassFromString(controllerClass) alloc] init];
        JDNavigationController *naviController = [[JDNavigationController alloc] initWithRootViewController:controller];
        naviController.tabBarItem = item;
        [array addObject:naviController];
    }
    [self setViewControllers:array animated:NO];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"tabBarSelected:%lu",(unsigned long)tabBarController.selectedIndex);
}

@end
