//
//  JDContactCell.h
//  JDMail
//
//  Created by 公司 on 2019/1/24.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDContactListMode;

@interface JDContactCell : UITableViewCell

- (void)reloadWithModel:(JDContactListMode *)model;

@end

NS_ASSUME_NONNULL_END
