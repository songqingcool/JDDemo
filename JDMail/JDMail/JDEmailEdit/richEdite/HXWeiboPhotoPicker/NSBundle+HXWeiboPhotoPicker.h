//
//  NSBundle+HXWeiboPhotoPicker.h
//  微博照片选择
//
//  Created by JD on 2017/7/25.
//  Copyright © 2017年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (HXWeiboPhotoPicker)
+ (instancetype)hx_photoPickerBundle;
+ (NSString *)hx_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)hx_localizedStringForKey:(NSString *)key;
@end
