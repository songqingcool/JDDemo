//
//  UIColor+Extend.h
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extend)

// 透明度固定为1，以0x开头的十六进制转换成的颜色
+ (UIColor *)colorWithHex:(long)hexColor;

// 0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

@end
