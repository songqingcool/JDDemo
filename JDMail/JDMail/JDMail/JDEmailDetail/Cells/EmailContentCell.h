//
//  EmailContentCell.h
//  JDMail
//
//  Created by 千阳 on 2019/2/27.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmailContentCell : UITableViewCell

@property(nonatomic,copy) void(^emialHtmlBodyHeight)(CGFloat height);

- (void)reloadWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
