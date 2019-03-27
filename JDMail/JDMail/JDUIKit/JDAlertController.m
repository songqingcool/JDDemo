//
//  JDAlertController.m
//  JDSafeSpace
//
//  Created by 公司 on 2018/6/6.
//  Copyright © 2018年 公司. All rights reserved.
//

#import "JDAlertController.h"

@interface JDAlertController ()

@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;

@end

@implementation JDAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAnimated:(BOOL)animated
{
    [self showAnimated:animated addCancelGesture:NO];
}

- (void)showAnimated:(BOOL)animated addCancelGesture:(BOOL)flag
{
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.backgroundColor = [UIColor clearColor];
    self.alertWindow.windowLevel = UIWindowLevelAlert + 1;
    UIViewController *rootViewController = [[UIViewController alloc] init];
    rootViewController.view.backgroundColor = [UIColor clearColor];
    // set window level
    self.alertWindow.rootViewController = rootViewController;
    [self.alertWindow makeKeyAndVisible];
    if (flag) {
        // 添加点击手势
        [self.alertWindow addGestureRecognizer:self.gestureRecognizer];
    }
    [rootViewController presentViewController:self animated:animated completion:nil];
}

- (UITapGestureRecognizer *)gestureRecognizer
{
    if (!_gestureRecognizer) {
        _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerDidClicked:)];
    }
    return _gestureRecognizer;
}

- (void)tapGestureRecognizerDidClicked:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (void)showComfirmAlertWithTitle:(NSString *)title
                          message:(NSString *)message
                destructiveButton:(NSString *)destructiveTitle
                     cancelButton:(NSString *)cancelTitle
                          handler:(void (^)(UIAlertAction *action))handler
{
    JDAlertController *alertController = [JDAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:handler];
    [alertController addAction:confirmAction];
    
    UIAlertAction *errorAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:errorAction];
    [alertController showAnimated:YES];
}

- (void)dealloc {
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

