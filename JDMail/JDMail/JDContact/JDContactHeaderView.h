//
//  JDContactHeaderView.h
//  JDMail
//
//  Created by 公司 on 2019/1/24.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDContactHeaderView : UIView

// 点击添加联系人
@property (nonatomic, copy) void(^addBlock)(void);
// 点击了联系人
@property (nonatomic, copy) void(^contactsBlock)(void);
// 点击了群组
@property (nonatomic, copy) void(^groupBlock)(void);

@end

NS_ASSUME_NONNULL_END
