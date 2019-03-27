//
//  MBProgressHUD+Extend.m
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import "MBProgressHUD+Extend.h"

@implementation MBProgressHUD (Extend)

+ (void)showHudWithText:(NSString *)text
{
    [self showHudWithText:text delay:2.0];
}

+ (void)showHudWithText:(NSString *)text delay:(NSTimeInterval)delay
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.minSize = CGSizeMake(30.0, 69.0);
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    hud.label.text = text;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:18.0];
    [hud hideAnimated:YES afterDelay:delay];
}

@end
