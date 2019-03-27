//
//  JDNetworkAPI.m
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import "JDNetworkAPI.h"
#import "JDNetworkPathHeader.h"
#import "JDNetworkManager.h"

@implementation JDNetworkAPI

+ (void)helpNotesQueryListWithSuccess:(void (^)(NSDictionary *))success
                              failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [[JDNetworkManager shareManager] loginPOST:userHelpNotesQueryListURL parameters:param success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
