//
//  JDMailReplyView.h
//  JDMail
//
//  Created by 公司 on 2019/3/4.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMailReplyView : UIView

// 点击了全部回复
@property (nonatomic, copy) void(^replyAllBlock)(void);
// 点击了转发
@property (nonatomic, copy) void(^forwardingBlock)(void);
// 点击了更多
@property (nonatomic, copy) void(^moreBlock)(void);

@end

NS_ASSUME_NONNULL_END
