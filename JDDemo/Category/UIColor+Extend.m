//
//  UIColor+Extend.m
//  JDMail
//
//  Created by 宋庆功 on 2019/1/31.
//  Copyright © 2019年 京东. All rights reserved.
//

#import "UIColor+Extend.h"

@implementation UIColor (Extend)

// 透明度固定为1，以0x开头的十六进制转换成的颜色
+ (UIColor*) colorWithHex:(long)hexColor
{
    return [UIColor colorWithHex:hexColor alpha:1.0];
}

// 0x开头的十六进制转换成的颜色,透明度可调整
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

@end
