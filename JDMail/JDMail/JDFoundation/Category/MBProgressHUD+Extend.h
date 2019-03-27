//
//  MBProgressHUD+Extend.h
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extend)

+ (void)showHudWithText:(NSString *)text;

+ (void)showHudWithText:(NSString *)text delay:(NSTimeInterval)delay;

@end
