//
//  JDAppointmentModel.h
//  JDMail
//
//  Created by 千阳 on 2019/3/20.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDAppointmentModel : NSObject
/*
 <t:Subject>Tennis lesson</t:Subject>
 <t:Body BodyType="HTML">Focus on backhand this week.</t:Body>
 <t:ReminderDueBy>2013-09-19T14:37:10.732-07:00</t:ReminderDueBy>
 <t:Start>2013-09-21T19:00:00.000Z</t:Start>
 <t:End>2013-09-21T20:00:00.000Z</t:End>
 <t:Location>Tennis club</t:Location>
 <t:MeetingTimeZone TimeZoneName="Pacific Standard Time" />
 */

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
