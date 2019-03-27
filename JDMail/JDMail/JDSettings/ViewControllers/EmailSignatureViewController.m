//
//  EmailSignatureViewController.m
//  JDMail
//
//  Created by 千阳 on 2019/1/25.
//  Copyright © 2019 公司. All rights reserved.
//

#import "EmailSignatureViewController.h"
#import <Masonry/Masonry.h>

@interface EmailSignatureViewController ()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextView *textView;

@end

@implementation EmailSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邮件签名";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setupUI];
    
    UIBarButtonItem *saveBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveEmailSignature:)];
    self.navigationItem.rightBarButtonItem = saveBarItem;
    
}

-(void)updateViewConstraints
{
    [self titleLabelConstraints];
    [self textViewConstraints];
    
    [super updateViewConstraints];
}

- (void)titleLabelConstraints
{
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(30);
        
    }];
}

- (void)textViewConstraints
{
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(200);
        
        
    }];
}

#pragma mark - setupUI

- (void)setupUI
{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.textView];
    [self.view setNeedsUpdateConstraints];
}

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        UIFont *font = [UIFont systemFontOfSize:15];
        _titleLabel.font = font;
        _titleLabel.text = @"签名设置";
    }
    return _titleLabel;
}

- (UITextView *)textView
{
    if(!_textView)
    {
        _textView = [[UITextView alloc] init];
    }
    return _textView;
}

- (void)saveEmailSignature:(UIBarButtonItem *)sender
{
    NSLog(@"保存邮箱签名");
}
@end
