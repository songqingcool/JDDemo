//
//  JDContactCell.m
//  JDMail
//
//  Created by 公司 on 2019/1/24.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDContactCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Extend.h"
#import "JDContactListMode.h"
#import "JDContactName.h"
#import "JDContactPhone.h"

@interface JDContactCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *starImageView;

@end

@implementation JDContactCell

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
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.starImageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.iconImageView.frame = CGRectMake(16.0, 10.0, 40.0, 40.0);
    
    CGFloat starY = 15.0;
    CGFloat starW = 30.0;
    CGFloat starH = 30.0;
    CGFloat starX = CGRectGetWidth([UIScreen mainScreen].bounds)-starW-10.0;
    self.starImageView.frame = CGRectMake(starX, starY, starW, starH);
    
    CGFloat titleX = CGRectGetMaxX(self.iconImageView.frame) + 10.0;
    CGFloat titleW = CGRectGetMinX(self.starImageView.frame) - titleX - 10.0;
    self.titleLabel.frame = CGRectMake(titleX, 10.0, titleW, 18.0);
    
    CGFloat subtitleY = CGRectGetMaxY(self.titleLabel.frame) + 7.0;
    self.subtitleLabel.frame = CGRectMake(titleX, subtitleY, titleW, 15.0);
}

- (void)reloadWithModel:(JDContactListMode *)model
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic.rmb.bdstatic.com/2b3a53eb722575ba7ffd3f5fcc2bcc67.jpeg@wm_2,t_55m+5a625Y+3L0HmiJHkuLrlm77ni4I=,fc_ffffff,ff_U2ltSGVp,sz_13,x_9,y_9"] placeholderImage:nil];
    
    if ([model.culture isEqualToString:@"zh-CN"]) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@",model.completeName.lastName,model.completeName.firstName];
    }else{
        self.titleLabel.text = model.completeName.fullName;
    }
    
    JDContactPhone *emailAddress = model.emailAddresses.firstObject;
    if (emailAddress) {
        self.subtitleLabel.text = emailAddress.entry;
    }else{
        self.subtitleLabel.text = @"未设置邮箱";
    }
    
    if (1) {
        self.starImageView.hidden = YES;
    }else{
        self.starImageView.hidden = NO;
    }
}

#pragma mark - getter/setter

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _titleLabel.textColor = [UIColor colorWithHex:0x050505];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.0];
        _subtitleLabel.textColor = [UIColor colorWithHex:0x050505];
    }
    return _subtitleLabel;
}

- (UIImageView *)starImageView
{
    if (!_starImageView) {
        _starImageView = [[UIImageView alloc] init];
        _starImageView.image = [UIImage imageNamed:@"contact_star_selected"];
    }
    return _starImageView;
}

@end
