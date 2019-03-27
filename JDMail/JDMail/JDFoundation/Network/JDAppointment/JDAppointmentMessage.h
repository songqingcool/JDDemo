//
//  JDAppointmentMessage.h
//  JDMail
//
//  Created by 千阳 on 2019/3/20.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDAppointmentMessage : NSObject

@property(nonatomic,copy)NSString *itemId;
@property(nonatomic,copy)NSString *changeKey;
@property(nonatomic,copy)NSString *body;
@property(nonatomic,copy)NSString *reminderDueBy;
@property(nonatomic,copy)NSString *start;
@property(nonatomic,copy)NSString *end;
@property(nonatomic,copy)NSString *location;
@property(nonatomic,copy)NSString *timeZoneName;

@end

NS_ASSUME_NONNULL_END
