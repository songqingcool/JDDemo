//
//  UIViewController+Extend.h
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extend)

- (void)setDefaultGoBackButton;

- (void)setDefaultGoBackButtonWithTitle:(NSString *)title;

- (void)setDefaultGoBackButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;
    
@end
