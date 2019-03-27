//
//  UIViewController+Extend.m
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import "UIViewController+Extend.h"

@implementation UIViewController (Extend)

- (void)setDefaultGoBackButton
{
    [self setDefaultGoBackButtonWithTitle:@""];
}

- (void)setDefaultGoBackButtonWithTitle:(NSString *)title
{
    [self setDefaultGoBackButtonWithTitle:title titleColor:[UIColor whiteColor]];
}

- (void)setDefaultGoBackButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 42.0, 42.0)];
    UIImage *normalImage = [UIImage imageNamed:@"header_icon_back"];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[titleColor colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tapBackButton:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.titleEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0, -32.0, 0.0, 0.0);
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.leftBarButtonItems = @[backBarButtonItem];
    }else {
        UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixItem.width = -6; // ios7
        self.navigationItem.leftBarButtonItems = @[fixItem,backBarButtonItem];
    }
}

/*
 *  返回按钮
 */
- (void)tapBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
