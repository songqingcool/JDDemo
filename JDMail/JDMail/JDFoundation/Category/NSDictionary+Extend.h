//
//  NSDictionary+Extend.h
//  JDMail
//
//  Created by 公司 on 2019/1/23.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extend)

- (NSString *)jd_stringForKey:(id)key;
- (NSArray *)jd_arrayForKey:(id)key;
- (NSDictionary *)jd_dictionaryForKey:(id)key;
- (NSInteger)jd_integerForKey:(id)key;
- (double)jd_doubleForKey:(id)key;
- (BOOL)jd_boolForKey:(id)key;

- (NSString *)jd_JSONString;

+ (NSDictionary *)jd_dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
