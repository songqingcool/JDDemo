//
//  JDAlertController.h
//  JDSafeSpace
//
//  Created by 公司 on 2018/6/6.
//  Copyright © 2018年 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDAlertController : UIAlertController

// 不带有取消手势
- (void)showAnimated:(BOOL)animated;

- (void)showAnimated:(BOOL)animated addCancelGesture:(BOOL)flag;

// 示例demo alert  删除场景下的二次确认框,左侧取消右侧红色确定
// 所有字段必填
+ (void)showComfirmAlertWithTitle:(NSString *)title
                          message:(NSString *)message
                destructiveButton:(NSString *)destructiveTitle
                     cancelButton:(NSString *)cancelTitle
                          handler:(void (^)(UIAlertAction *action))handler;

@end

