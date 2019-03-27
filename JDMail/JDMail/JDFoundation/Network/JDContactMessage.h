//
//  JDContactMessage.h
//  JDMail
//
//  Created by 公司 on 2019/3/6.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDContactMessage : NSObject

// contacts
@property (nonatomic, copy) NSString *distinguishedFolderId;
// SampleContact
@property (nonatomic, copy) NSString *fileAs;

@property (nonatomic, copy) NSString *givenName;
@property (nonatomic, copy) NSString *surname;

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *jobTitle;
// 
@property (nonatomic, strong) NSArray *emailAddresses;
//
@property (nonatomic, strong) NSArray *phoneNumbers;

@end

NS_ASSUME_NONNULL_END
