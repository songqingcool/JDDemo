//
//  JDAttachmentTableViewCell.h
//  JDMail
//
//  Created by 千阳 on 2019/3/5.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDAttachmentTableViewCell : UITableViewCell

- (void)reloadDataWithMailAttachmentArray:(NSArray *)mailAttachmentArray;

@end

NS_ASSUME_NONNULL_END
