//
//  JDNetworkAPI.h
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDNetworkAPI : NSObject

+ (void)helpNotesQueryListWithSuccess:(void (^)(NSDictionary *))success
                              failure:(void (^)(NSError *))failure;

@end
