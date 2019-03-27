//
//  JDContactFieldCell.h
//  JDMail
//
//  Created by 公司 on 2019/3/7.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDContactFieldCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *content;

// 结束编辑
@property (nonatomic, copy) void(^endEditBlock)(NSString *);

@end

NS_ASSUME_NONNULL_END
