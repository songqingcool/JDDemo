//
//  JDContactDetailHeaderView.m
//  JDMail
//
//  Created by 公司 on 2019/3/11.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDContactDetailHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JDContactDetailModel.h"
#import "JDContactName.h"
#import "JDContactPhone.h"
#import "UIColor+Extend.h"

@interface JDContactDetailHeaderView ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIButton *starButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *editEmailButton;
@property (nonatomic, strong) UIButton *callButton;

@end

@implementation JDContactDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.headImageView];
    [self addSubview:self.starButton];
    [self addSubview:self.nameLabel];
    [self addSubview:self.emailLabel];
    [self addSubview:self.companyLabel];
    [self addSubview:self.phoneLabel];
    [self addSubview:self.editEmailButton];
    [self addSubview:self.callButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat headW = 50.0;
    CGFloat headH = 50.0;
    CGFloat headX = (CGRectGetWidth([UIScreen mainScreen].bounds)-headW)/2.0;
    CGFloat headY = 15.0;
    self.headImageView.frame = CGRectMake(headX, headY, headW, headH);

    CGFloat starW = 30.0;
    CGFloat starH = 30.0;
    CGFloat starX = CGRectGetWidth([UIScreen mainScreen].bounds)-starW-20.0;
    CGFloat starY = 15.0;
    self.starButton.frame = CGRectMake(starX, starY, starW, starH);
    
    CGFloat nameX = 20.0;
    CGFloat nameY = CGRectGetMaxY(self.headImageView.frame)+10.0;
    CGFloat nameW = CGRectGetWidth([UIScreen mainScreen].bounds)-nameX-20.0;
    CGFloat nameH = 20.0;
    self.nameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat emailX = 20.0;
    CGFloat emailY = CGRectGetMaxY(self.nameLabel.frame)+10.0;
    CGFloat emailW = CGRectGetWidth([UIScreen mainScreen].bounds)-emailX-20.0;;
    CGFloat emailH = 20.0;
    self.emailLabel.frame = CGRectMake(emailX, emailY, emailW, emailH);
    
    CGFloat companyX = 20.0;
    CGFloat companyY = CGRectGetMaxY(self.emailLabel.frame)+10.0;
    CGFloat companyW = CGRectGetWidth([UIScreen mainScreen].bounds)-companyX-20.0;;
    CGFloat companyH = 20.0;
    self.companyLabel.frame = CGRectMake(companyX, companyY, companyW, companyH);
    
    CGFloat phoneX = 20.0;
    CGFloat phoneY = CGRectGetMaxY(self.companyLabel.frame)+10.0;
    CGFloat phoneW = CGRectGetWidth([UIScreen mainScreen].bounds)-phoneX-20.0;;
    CGFloat phoneH = 20.0;
    self.phoneLabel.frame = CGRectMake(phoneX, phoneY, phoneW, phoneH);
    
    CGFloat editX = 30.0;
    CGFloat editY = CGRectGetMaxY(self.phoneLabel.frame)+10.0;
    CGFloat editW = 60.0;;
    CGFloat editH = 60.0;
    self.editEmailButton.frame = CGRectMake(editX, editY, editW, editH);
    
    CGFloat callX = CGRectGetMaxX(self.editEmailButton.frame)+20.0;
    CGFloat callY = CGRectGetMaxY(self.phoneLabel.frame)+10.0;
    CGFloat callW = 60.0;;
    CGFloat callH = 60.0;
    self.callButton.frame = CGRectMake(callX, callY, callW, callH);
}

- (void)updateWithModel:(JDContactDetailModel *)model
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic.rmb.bdstatic.com/2b3a53eb722575ba7ffd3f5fcc2bcc67.jpeg@wm_2,t_55m+5a625Y+3L0HmiJHkuLrlm77ni4I=,fc_ffffff,ff_U2ltSGVp,sz_13,x_9,y_9"] placeholderImage:nil];
    
    if (1) {
        self.starButton.selected = YES;
    }else{
        self.starButton.selected = NO;
    }
    
    if ([model.culture isEqualToString:@"zh-CN"]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@%@",model.completeName.lastName,model.completeName.firstName];
    }else{
        self.nameLabel.text = model.completeName.fullName;
    }
    
    JDContactPhone *emailAddress = model.emailAddresses.firstObject;
    if (emailAddress) {
        self.emailLabel.text = emailAddress.entry;
    }else{
        self.emailLabel.text = @"未设置邮箱";
    }
    
    self.companyLabel.text = model.companyName;
    
    JDContactPhone *phoneNumber = model.phoneNumbers.firstObject;
    if (phoneNumber) {
        self.phoneLabel.text = phoneNumber.entry;
    }else{
        self.phoneLabel.text = @"未设置手机号";
    }
}

#pragma mark - getter/setter

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [UIColor greenColor];
    }
    return _headImageView;
}

- (UIButton *)starButton
{
    if (!_starButton) {
        _starButton = [[UIButton alloc] init];
        [_starButton setImage:[UIImage imageNamed:@"contact_star_normal"] forState:UIControlStateNormal];
        [_starButton setImage:[UIImage imageNamed:@"contact_star_selected"] forState:UIControlStateSelected];
        [_starButton addTarget:self action:@selector(starButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _starButton.selected = NO;
    }
    return _starButton;
}

- (void)starButtonDidClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.starBlock) {
        self.starBlock();
    }
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)emailLabel
{
    if (!_emailLabel) {
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.font = [UIFont systemFontOfSize:14.0];
        _emailLabel.textColor = [UIColor blackColor];
        _emailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _emailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emailLabel;
}

- (UILabel *)companyLabel
{
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc] init];
        _companyLabel.font = [UIFont systemFontOfSize:14.0];
        _companyLabel.textColor = [UIColor blackColor];
        _companyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _companyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _companyLabel;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:14.0];
        _phoneLabel.textColor = [UIColor blackColor];
        _phoneLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _phoneLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLabel;
}

- (UIButton *)editEmailButton
{
    if (!_editEmailButton) {
        _editEmailButton = [[UIButton alloc] init];
        [_editEmailButton setImage:[UIImage imageNamed:@"header_icon_back"] forState:UIControlStateNormal];
        [_editEmailButton setTitle:@"写邮件" forState:UIControlStateNormal];
        [_editEmailButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _editEmailButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_editEmailButton addTarget:self action:@selector(editEmailButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _editEmailButton.titleEdgeInsets = UIEdgeInsetsMake(25.0, -15.0, 0.0, 0.0);
        _editEmailButton.imageEdgeInsets = UIEdgeInsetsMake(-25.0, 10.0, 0.0, 0.0);
    }
    return _editEmailButton;
}

- (void)editEmailButtonDidClicked:(UIButton *)sender
{
    if (self.editEmailBlock) {
        self.editEmailBlock();
    }
}

- (UIButton *)callButton
{
    if (!_callButton) {
        _callButton = [[UIButton alloc] init];
        [_callButton setImage:[UIImage imageNamed:@"header_icon_back"] forState:UIControlStateNormal];
        [_callButton setTitle:@"呼叫" forState:UIControlStateNormal];
        [_callButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _callButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [_callButton addTarget:self action:@selector(callButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _callButton.titleEdgeInsets = UIEdgeInsetsMake(25.0, -15.0, 0.0, 0.0);
        _callButton.imageEdgeInsets = UIEdgeInsetsMake(-25.0, 10.0, 0.0, 0.0);
    }
    return _callButton;
}

- (void)callButtonDidClicked:(UIButton *)sender
{
    if (self.callBlock) {
        self.callBlock();
    }
}

@end
