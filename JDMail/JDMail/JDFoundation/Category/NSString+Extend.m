//
//  NSString+Extend.m
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import "NSString+Extend.h"

@implementation NSString (Extend)

// 版本号比较
- (NSComparisonResult)jd_versionCompare:(NSString *)string
{
    NSArray *frontArray = [self componentsSeparatedByString:@"."];
    NSArray *rearArray = [string componentsSeparatedByString:@"."];
    int count = (int)MIN(frontArray.count, rearArray.count);
    NSComparisonResult result = NSOrderedSame;
    for (int i = 0; i<count; i++) {
        NSInteger front = [[frontArray objectAtIndex:i] integerValue];
        NSInteger rear = [[rearArray objectAtIndex:i] integerValue];
        if (front > rear) {
            result = NSOrderedDescending;
            break;
        }else if (front == rear) {
            continue;
        }else{
            result = NSOrderedAscending;
            break;
        }
    }
    
    if (result == NSOrderedSame && frontArray.count != rearArray.count) {
        if (frontArray.count > rearArray.count) {
            result = NSOrderedDescending;
        }else{
            result = NSOrderedAscending;
        }
    }
    return result;
}

@end
