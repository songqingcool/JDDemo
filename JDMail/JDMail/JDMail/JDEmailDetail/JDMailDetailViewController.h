//
//  JDMailDetailViewController.h
//  JDMail
//
//  Created by 千阳 on 2019/2/26.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDMailListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDMailDetailViewController : UIViewController

- (instancetype)initWithModel:(JDMailListModel *)model;

@end

NS_ASSUME_NONNULL_END
