//
//  JDSenderTextView.h
//  JDMail
//
//  Created by 公司 on 2019/3/5.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDSenderTextView : UIView

// 编辑结束
@property (nonatomic, copy) void(^endEditingBlock)(NSArray *);
@property(nonatomic,copy) void(^contentHeightBlock)(CGFloat);

- (void)loadEmailAdress:(NSArray *)recipients;

+ (CGFloat)heightWithEmailAdress:(NSArray *)addressList;

@end

NS_ASSUME_NONNULL_END
