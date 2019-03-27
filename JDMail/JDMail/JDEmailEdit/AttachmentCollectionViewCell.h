//
//  AttachmentCollectionViewCell.h
//  JDMail
//
//  Created by 千阳 on 2019/3/5.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDMailAttachment;

@interface AttachmentCollectionViewCell : UICollectionViewCell

- (void)reloadDataWithModel:(JDMailAttachment *)mailAttachment;

@end

NS_ASSUME_NONNULL_END
