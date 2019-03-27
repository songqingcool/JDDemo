//
//  JDLoginButtonCell.h
//  JDMail
//
//  Created by 公司 on 2019/2/27.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDLoginButtonCell : UITableViewCell

// 点击登录按钮
@property (nonatomic, copy) void(^loginBlock)(void);

@end

NS_ASSUME_NONNULL_END
