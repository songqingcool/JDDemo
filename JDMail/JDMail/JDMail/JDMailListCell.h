//
//  JDMailListCell.h
//  JDMail
//
//  Created by 公司 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDMailListModel;

@interface JDMailListCell : UITableViewCell

- (void)reloadWithModel:(JDMailListModel *)model;

@end

NS_ASSUME_NONNULL_END
