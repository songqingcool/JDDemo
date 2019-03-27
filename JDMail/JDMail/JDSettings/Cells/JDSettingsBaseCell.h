//
//  JDSettingsBaseCell.h
//  JDMail
//
//  Created by 千阳 on 2019/1/24.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDSettingsBaseCell : UITableViewCell

- (UIImage *)imageWithColor:(UIColor *)color;

-(void)reloadWithModel:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
