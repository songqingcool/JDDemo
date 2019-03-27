//
//  JDLeftPhotoCell.m
//  JDMail
//
//  Created by 千阳 on 2019/1/24.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDLeftPhotoCell.h"

@interface JDLeftPhotoCell()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *photoImage;
@property(nonatomic,strong)UIImageView *arrowImage;

@end

@implementation JDLeftPhotoCell
{
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
        [self setupUI];
        [self performSelector:@selector(reloadWithModel:) withObject:nil afterDelay:1];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - layoutSunView
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self titleLabelLayout];
    [self photoImageLayout];
    [self arrowImageLayout];
}

- (void)titleLabelLayout
{
    CGRect rect = CGRectMake(20, (self.frame.size.height)/2-15, 50, 30);
    self.titleLabel.frame = rect;
}

- (void)photoImageLayout
{
    CGRect rect = CGRectMake(self.frame.size.width-36-20-25, self.frame.size.height/2-18, 36, 36);
    self.photoImage.frame = rect;
}

- (void)arrowImageLayout
{
    CGRect rect = CGRectMake(self.frame.size.width-20-20,self.frame.size.height/2-18, 20, 36);
    self.arrowImage.frame = rect;
}

#pragma mark - setupUI
- (void)setupUI
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.photoImage];
    [self.contentView addSubview:self.arrowImage];
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        UIFont *font = [UIFont systemFontOfSize:14];
        _titleLabel.font = font;
    }
    return _titleLabel;
}

- (UIImageView *)photoImage
{
    if(!_photoImage)
    {
        _photoImage = [[UIImageView alloc] init];
//        _photoImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _photoImage;
}

- (UIImageView *)arrowImage
{
    if(!_arrowImage)
    {
        _arrowImage = [[UIImageView alloc] init];
//        _arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImage.image = [self imageWithColor:[UIColor redColor]];
    }
    return _arrowImage;
}


- (void)reloadWithModel:(NSDictionary *)dic
{
    self.titleLabel.text = @"头像";
    self.photoImage.image = [self imageWithColor:[UIColor greenColor]];
}

@end
