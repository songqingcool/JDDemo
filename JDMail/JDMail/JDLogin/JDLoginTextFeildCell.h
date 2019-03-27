//
//  JDLoginTextFeildCell.h
//  JDMail
//
//  Created by 公司 on 2019/2/27.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDLoginTextFeildCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;

// 输入完毕
@property (nonatomic, copy) void(^textBlock)(NSString *,NSString *);

- (void)reloadWithModel:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END
