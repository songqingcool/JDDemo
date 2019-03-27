//
//  JDLoginButtonCell.m
//  JDMail
//
//  Created by 公司 on 2019/2/27.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDLoginButtonCell.h"

@interface JDLoginButtonCell ()

@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation JDLoginButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.loginButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat titleX = 10.0;
    CGFloat titleY = 10.0;
    CGFloat titleW = CGRectGetWidth([UIScreen mainScreen].bounds)-titleX-10.0;
    CGFloat titleH = 30.0;
    self.loginButton.frame = CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)reloadWithModel:(NSDictionary *)model
{
    
}

#pragma mark - getter/setter

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.backgroundColor = [UIColor greenColor];
    }
    return _loginButton;
}

- (void)loginButtonDidClicked:(UIButton *)sender
{
    if (self.loginBlock) {
        self.loginBlock();
    }
}

@end
