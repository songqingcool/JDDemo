//
//  JDAccountManagerController.m
//  JDMail
//
//  Created by 千阳 on 2019/1/24.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDAccountManagerController.h"
#import "../Cells/JDLeftPhotoCell.h"
#import "../Cells/JDSettingsNormalCell.h"

@interface JDAccountManagerController ()<UITableViewDelegate,
                                         UITableViewDataSource,
                                         UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImagePickerController *imagePickerController;

@end

@implementation JDAccountManagerController
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

#pragma mark - setupUI
- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[JDLeftPhotoCell class] forCellReuseIdentifier:@"JDLeftPhotoCellIdentifier"];
        [_tableView registerClass:[JDSettingsNormalCell class] forCellReuseIdentifier:@"JDSettingsNormalCellIdentifier"];
    }
    return _tableView;
}

#pragma mark - UITableViewDatasource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JDSettingsBaseCell *cell = nil;
    if(indexPath.row == 0)
    {
        cell = [[JDLeftPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JDLeftPhotoCellIdentifier"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"JDSettingsNormalCellIdentifier" forIndexPath:indexPath];
        if(indexPath.row == 1)
            [cell reloadWithModel:@{@"手机号":@"15010790233"}];
        else if(indexPath.row == 2)
            [cell reloadWithModel:@{@"ERP账号":@"libo"}];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UIAlertController *alertController = [[UIAlertController alloc] init];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *picturesAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
            }
        }];
        
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:self.imagePickerController animated:YES completion:nil];
            }
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:picturesAction];
        [alertController addAction:albumAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(UIImagePickerController *)imagePickerController
{
    if(!_imagePickerController)
    {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
