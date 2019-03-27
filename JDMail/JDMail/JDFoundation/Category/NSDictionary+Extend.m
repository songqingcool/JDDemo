//
//  NSDictionary+Extend.m
//  JDMail
//
//  Created by 公司 on 2019/1/23.
//  Copyright © 2019 公司. All rights reserved.
//

#import "NSDictionary+Extend.h"

@implementation NSDictionary (Extend)

- (NSString *)jd_stringForKey:(id)key {
    
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

- (NSArray *)jd_arrayForKey:(id)key {
    
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)jd_dictionaryForKey:(id)key {
    
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSInteger)jd_integerForKey:(id)key {
    
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (double)jd_doubleForKey:(id)key {
    
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return 0.0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value doubleValue];
    }
    return 0.0;
}

- (BOOL)jd_boolForKey:(id)key
{
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null]) {
        return NO;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    return NO;
}

- (NSString *)jd_JSONString{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (jsonData == nil) {
#ifdef DEBUG
        NSLog(@"fail to get JSON from dictionary: %@, error: %@", self, error);
#endif
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSDictionary *)jd_dictionaryWithJsonString:(NSString *)jsonString {
    if (!jsonString) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
