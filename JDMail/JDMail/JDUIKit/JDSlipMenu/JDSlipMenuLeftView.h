//
//  JDSlipMenuLeftView.h
//  JDMail
//
//  Created by 公司 on 2019/1/23.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDSlipMenuLeftView : UIView

// 点击添加账号
@property (nonatomic, copy) void(^addBlock)(void);
// 点击了设置
@property (nonatomic, copy) void(^settingBlock)(void);
// 点击了某个账号
@property (nonatomic, copy) void(^accountBlock)(NSDictionary *);

- (void)reloadWithAccounts:(NSArray *)accounts;

@end

NS_ASSUME_NONNULL_END
