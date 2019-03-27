//
//  JDContactListMode.h
//  JDMail
//
//  Created by 公司 on 2019/3/6.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JDContactName;

@interface JDContactListMode : NSObject
//
@property (nonatomic, copy) NSString *itemId;
//
@property (nonatomic, copy) NSString *changeKey;
@property (nonatomic, copy) NSString *hasAttachments;
// zh-CN
@property (nonatomic, copy) NSString *culture;
//
@property (nonatomic, copy) NSString *fileAs;
//
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *givenName;
@property (nonatomic, copy) NSString *surname;

@property (nonatomic, strong) JDContactName *completeName;
@property (nonatomic, strong) NSArray *emailAddresses;
@property (nonatomic, strong) NSArray *phoneNumbers;

@end

NS_ASSUME_NONNULL_END
