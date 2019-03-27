//
//  SettingAccountCell.m
//  JDMail
//
//  Created by 千阳 on 2019/1/23.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDSettingsAccountCell.h"

#define PhotoImageWidth 48.0

@interface JDSettingsAccountCell()

@property(nonatomic,strong)UIImageView *photoImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *emailLabel;
@property(nonatomic,strong)UILabel *accountLabel;
@property(nonatomic,strong)UIImageView *arrowImage;

@end

@implementation JDSettingsAccountCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorInset = UIEdgeInsetsMake(0, -30, 0, 0);
        [self  setupUI];
    }
    return self;
}

- (void)setupUI
{
    
    [self.contentView addSubview:self.photoImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.emailLabel];
    [self.contentView addSubview:self.accountLabel];
    [self.contentView addSubview:self.arrowImage];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutPhotoImage];
    
    [self layoutNameLabel];
    [self layoutEmailLabel];
    [self layoutAccountLable];
    [self layoutArrowImage];
    
}

- (void)layoutPhotoImage
{
    self.photoImage.frame = CGRectMake(0, 0, PhotoImageWidth, PhotoImageWidth);
    self.photoImage.center = CGPointMake(PhotoImageWidth/2+20, self.frame.size.height/2);
}

- (void)layoutNameLabel
{
    CGFloat centerY = self.frame.size.height/2;
    self.nameLabel.frame = CGRectMake(80, centerY-20, 40, 20);
}

- (void)layoutEmailLabel
{
    CGFloat centerY = self.frame.size.height/2;
    self.emailLabel.frame = CGRectMake(80, centerY+0, 100, 20);
}

-(void)layoutAccountLable
{
    self.accountLabel.frame = CGRectMake(0, 0, 120, 30);
    self.accountLabel.center = CGPointMake(self.frame.size.width-110, self.frame.size.height/2);
}

- (void)layoutArrowImage
{
    self.arrowImage.frame = CGRectMake(0, 0, 20,36);
    self.arrowImage.center = CGPointMake(self.frame.size.width-30, self.frame.size.height/2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)photoImage
{
    if(!_photoImage)
    {
        _photoImage = [[UIImageView alloc] init];
    }
    return _photoImage;
}

- (UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = font;
    }
    return _nameLabel;
}

- (UILabel *)emailLabel
{
    if(!_emailLabel)
    {
        _emailLabel = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:12];
        _emailLabel.textColor = [UIColor lightGrayColor];
        _emailLabel.font = font;
    }
    return _emailLabel;
}

- (UILabel *)accountLabel
{
    if(!_accountLabel)
    {
        _accountLabel = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:15];
        _accountLabel.font = font;
        _accountLabel.textColor = [UIColor lightGrayColor];
        _accountLabel.textAlignment = NSTextAlignmentRight;
        _accountLabel.text = @"账号管理";
    }
    return _accountLabel;
}

- (UIImageView *)arrowImage
{
    if(!_arrowImage)
    {
        _arrowImage = [[UIImageView alloc] init];
        _arrowImage.image = [self imageWithColor:[UIColor redColor]];
    }
    return _arrowImage;
}

#pragma mark - reloadData

-(void)reloadWithModel:(NSDictionary *)dic
{
    self.photoImage.image = [self imageWithColor:[UIColor greenColor]];
    NSString *name = [[dic allKeys] firstObject];
    NSString *emial = [[dic allValues] firstObject];
 
    self.nameLabel.text = name;
    self.emailLabel.text = emial;
    
    [self setNeedsDisplay];
}



@end
