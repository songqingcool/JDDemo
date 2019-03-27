//
//  JDContactDetailHeaderView.h
//  JDMail
//
//  Created by 公司 on 2019/3/11.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDContactDetailModel;

@interface JDContactDetailHeaderView : UIView

// 点击星标
@property (nonatomic, copy) void(^starBlock)(void);
// 点击编辑邮件
@property (nonatomic, copy) void(^editEmailBlock)(void);
// 点击呼叫
@property (nonatomic, copy) void(^callBlock)(void);

- (void)updateWithModel:(JDContactDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
