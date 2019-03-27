//
//  JDLoginManager.m
//  JDMail
//
//  Created by 公司 on 2019/3/19.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDLoginManager.h"
#import "JDTabBarController.h"
#import "JDAccountManager.h"
#import "JDLoginController.h"

@implementation JDLoginManager

+ (void)loginDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([JDAccountManager shareManager].accountsArray.count) {
        [JDLoginManager gotoHomePage];
        [JDLoginManager didLoginProcess];
    }else{
        JDLoginController *loginController = [[JDLoginController alloc] init];
        loginController.finishBlock = ^{
            [JDLoginManager gotoHomePage];
            [JDLoginManager didLoginProcess];
        };
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginController];
        [UIApplication sharedApplication].delegate.window.rootViewController = loginNav;
    }
}

// 跳转到首页
+ (void)gotoHomePage
{
    JDTabBarController *tabBarController = [[JDTabBarController alloc] init];
    [UIApplication sharedApplication].delegate.window.rootViewController = tabBarController;
}

+ (void)didLoginProcess
{
    
}

@end
