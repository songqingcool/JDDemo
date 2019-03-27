//
//  NSString+Extend.h
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extend)

// 版本号比较
- (NSComparisonResult)jd_versionCompare:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
