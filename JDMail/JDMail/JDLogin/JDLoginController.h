//
//  JDLoginController.h
//  JDMail
//
//  Created by 公司 on 2019/2/22.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDLoginController : UIViewController

@property (nonatomic, copy) void(^finishBlock)(void);

@end

NS_ASSUME_NONNULL_END
