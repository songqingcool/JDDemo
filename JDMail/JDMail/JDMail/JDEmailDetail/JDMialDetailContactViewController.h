//
//  JDMialDetailContactViewController.h
//  JDMail
//
//  Created by 千阳 on 2019/3/11.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMialDetailContactViewController : UIViewController

///from,recipient,ccRecipient
-(instancetype)initWithContactDic:(NSDictionary *)contactDic;

@end

NS_ASSUME_NONNULL_END
