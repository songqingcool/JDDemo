
//
//  JDAllFilesViewController.m
//  JDMail
//
//  Created by 千阳 on 2019/1/28.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDAllFilesViewController.h"
#import "../../JDCollectionView/JDFileCollectionView.h"
#import <Masonry.h>

@interface JDAllFilesViewController ()

@property(nonatomic,strong)JDFileCollectionView *fileCollectionView;

@end

@implementation JDAllFilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.fileCollectionView];
    
    [self addRightBarButtonItem];
    
}

- (void)addRightBarButtonItem
{
    UITabBarController *rootVC = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootVC isKindOfClass:[UITabBarController class]])
    {
        UINavigationController *nav = [rootVC.viewControllers lastObject];
        if([nav isKindOfClass:[UINavigationController class]])
        {
            UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"样式" style:UIBarButtonItemStylePlain target:self action:@selector(collectionViewLayoutChange:)];
            UIViewController *vc = (UIViewController *)[nav.viewControllers firstObject];
            vc.navigationItem.rightBarButtonItem = rightBarButtonItem;
        }
    }
}

- (void)updateViewConstraints
{
    [self fileCollectionViewConstraints];
    
    [super updateViewConstraints];
}

- (void)fileCollectionViewConstraints
{
    [self.fileCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right);
        
    }];
}

- (JDFileCollectionView *)fileCollectionView
{
    if(!_fileCollectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _fileCollectionView = [[JDFileCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        
        __weak JDAllFilesViewController *weakSelf = self;
        _fileCollectionView.collectionViewClickMoreAction = ^(NSArray * _Nonnull modelsArray) {
            [weakSelf alertActionWithCollectionViewSelectFileItems:modelsArray];
        };
    }
    return _fileCollectionView;
}

- (void)collectionViewLayoutChange:(UIBarButtonItem *)barItem
{
    self.fileCollectionView.isCollectonViewStyle = !self.fileCollectionView.isCollectonViewStyle;
    [self.fileCollectionView reloadData];
}

- (void)alertActionWithCollectionViewSelectFileItems:(NSArray *)selectFileItems
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    
    UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *actionSpecialSend = [UIAlertAction actionWithTitle:@"以会话方式发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *actionReadEmail = [UIAlertAction actionWithTitle:@"查看原邮件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction *actionSendEmail = [UIAlertAction actionWithTitle:@"发送邮件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alertController addAction:actionSendEmail];
    [alertController addAction:actionReadEmail];
    [alertController addAction:actionSpecialSend];
    [alertController addAction:actionDelete];
    [alertController addAction:actionCancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertViewConrollerDismiss:(UITapGestureRecognizer *)tap
{
    
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
