//
//  SettingAccountCell.h
//  JDMail
//
//  Created by 千阳 on 2019/1/23.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDSettingsBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDSettingsAccountCell : JDSettingsBaseCell

-(void)reloadWithModel:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
