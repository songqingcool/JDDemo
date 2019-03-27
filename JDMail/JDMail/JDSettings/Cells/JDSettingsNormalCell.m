//
//  SettingsNormalCell.m
//  JDMail
//
//  Created by 千阳 on 2019/1/24.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDSettingsNormalCell.h"

#define ArrowImageHeight 36

@interface JDSettingsNormalCell()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *arrowImage;

@end

@implementation JDSettingsNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorInset = UIEdgeInsetsMake(0, -30, 0, 0);
        [self setupUI];
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self titleLabelLayout];
    [self contentLabelLayout];
    [self arrowImageLayout];
    
    
}

#pragma mark - UISetup

-(void)setupUI
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.arrowImage];
}

- (void)titleLabelLayout
{
    CGRect rect = CGRectMake(20, (self.frame.size.height-7)/2, 100, 15);
    self.titleLabel.frame = rect;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:14];
        _titleLabel.font = font;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (void)contentLabelLayout
{
    CGRect rect = CGRectMake(self.frame.size.width - 150, (self.frame.size.height-7)/2, 100, 15);
    self.contentLabel.frame = rect;
}

-(UILabel *)contentLabel
{
    if(!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        UIFont *font = [UIFont systemFontOfSize:14];
        _contentLabel.font = font;
        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.textAlignment = NSTextAlignmentRight;
    }
    return _contentLabel;
}

- (void)arrowImageLayout
{
    CGRect rect = CGRectMake(0, 0, 20, ArrowImageHeight);
    self.arrowImage.frame = rect;
    self.arrowImage.center = CGPointMake(self.frame.size.width-30, self.frame.size.height/2);
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

- (void)reloadWithModel:(NSDictionary *)model
{
    self.arrowImage.image = [self imageWithColor:[UIColor greenColor]];
    NSString *title = [[model allKeys] firstObject];
    NSString *content = [[model allValues] firstObject];
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    [self setNeedsDisplay];
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 50, 50);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
