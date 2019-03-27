//
//  Recipient Cell.h
//  JDMail
//
//  Created by 千阳 on 2019/2/26.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDMailListModel;

NS_ASSUME_NONNULL_BEGIN

@interface RecipientCell : UITableViewCell

@property(nonatomic,copy)void(^showOtherRecipients)(void);

- (void)reloadWithModel:(JDMailListModel *)model;

@end

NS_ASSUME_NONNULL_END
