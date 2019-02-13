//
//  FaceIDController.m
//  JDDemo
//
//  Created by 宋庆功 on 2019/2/11.
//  Copyright © 2019 京东. All rights reserved.
//

#import "FaceIDController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface FaceIDController ()

@property (nonatomic, strong) LAContext *context;

@end

@implementation FaceIDController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self dd];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dd
{
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"验证手势密码";
    NSError *error1 = nil;
    BOOL canEvaluate = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error1];
    if (canEvaluate) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹/面容ID解锁" reply:^(BOOL success, NSError *error) {
            
            if (success) {
                
            }else{
                if (error.code != LAErrorUserCancel && error.code != LAErrorUserFallback) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"dddddd1%@",@"未验证成功");
                    });
                }
            }
        }];
    }else{
        NSLog(@"当前设备不支持TouchID%@",error1);
        NSString *errorString = @"指纹/面容ID未能启用";
        if (@available(iOS 11.0, *)) {
            if (error1.code == LAErrorBiometryLockout) {
                errorString = @"指纹/面容ID被锁";
            }
        } else {
            if (error1.code == LAErrorTouchIDLockout) {
                errorString = @"指纹/面容ID被锁";
            }
        }
        NSLog(@"dddddd1%@",errorString);
    }
}

@end
