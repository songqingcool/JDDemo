//
//  Recipient Cell.m
//  JDMail
//
//  Created by 千阳 on 2019/2/26.
//  Copyright © 2019 公司. All rights reserved.
//

#import "RecipientCell.h"
#import "UIView+Frame.h"
#import "JDMailListModel.h"
#import "JDMailPerson.h"

@interface RecipientCell()

@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UIButton *fromNameButton;
@property(nonatomic,strong)UILabel *dateTimeLabel;
@property(nonatomic,strong)UIButton *otherRecipient;

@end

@implementation RecipientCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUI];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupUI
{
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.fromNameButton];
    [self.contentView addSubview:self.dateTimeLabel];
    [self.contentView addSubview:self.otherRecipient];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self iconImageLayout];
    [self fromNameButtonLayout];
    [self dateTimeLabelLayout];
    [self otherRecipientLayout];
}

- (void)iconImageLayout
{
    self.iconImage.left = 15;
    self.iconImage.top = 5;
    self.iconImage.width = 36;
    self.iconImage.height = 36;
}

- (UIImageView *)iconImage
{
    if(!_iconImage)
    {
        _iconImage = [[UIImageView alloc] init];
    }
    return _iconImage;
}

- (void)fromNameButtonLayout
{
    self.fromNameButton.left = self.iconImage.right +10;
    self.fromNameButton.top = 10;
    self.fromNameButton.width = 200;
    self.fromNameButton.height = 15;
}

- (UIButton *)fromNameButton
{
    if(!_fromNameButton)
    {
        _fromNameButton = [[UIButton alloc] init];
        [_fromNameButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _fromNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _fromNameButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _fromNameButton;
}

- (void)dateTimeLabelLayout
{
    self.dateTimeLabel.left = self.fromNameButton.left;
    self.dateTimeLabel.top = self.fromNameButton.bottom+3;
    self.dateTimeLabel.width = 200;
    self.dateTimeLabel.height = 10;
}

- (UILabel *)dateTimeLabel
{
    if(!_dateTimeLabel)
    {
        _dateTimeLabel = [[UILabel alloc] init];
        _dateTimeLabel.textColor = [UIColor grayColor];
        _dateTimeLabel.font = [UIFont boldSystemFontOfSize:13];
    }
    return _dateTimeLabel;
}

- (void)otherRecipientLayout
{
    self.otherRecipient.left = self.contentView.width - 105;
    self.otherRecipient.top = (self.contentView.height-30)/2;
    self.otherRecipient.width = 100;
    self.otherRecipient.height = 30;
}

- (UIButton *)otherRecipient
{
    if(!_otherRecipient)
    {
        _otherRecipient = [[UIButton alloc] init];
        [_otherRecipient setTitle:@"邮件相关人>" forState:UIControlStateNormal];
        [_otherRecipient setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _otherRecipient.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [_otherRecipient addTarget:self action:@selector(showOtherRecipients:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherRecipient;
}

- (void)reloadWithModel:(JDMailListModel *)model
{
    [self.fromNameButton setTitle:model.from.name forState:UIControlStateNormal];
    NSString *firstText = [self.fromNameButton.titleLabel.text substringToIndex:1];
    self.dateTimeLabel.text =[self changeFormatWithDateString: model.dateTimeSent];
    self.iconImage.image = [self imageWithColor:[UIColor lightGrayColor] withText:firstText];
}


-(NSString *)changeFormatWithDateString:(NSString *)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *currentDate = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateStr=[dateFormatter stringFromDate:currentDate];
    return dateStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showOtherRecipients:(UIButton *)sender
{
    
    self.showOtherRecipients();
    NSLog(@"显示其它联系人");
}

- (UIImage *)imageWithColor:(UIColor *)color withText:(NSString *)text
{
    CGRect rect = CGRectMake(0, 0, 50, 50);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
  
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, rect);
    CGRect textFrame = CGRectMake(10,5, 40, 40);
    UIFont *font = [UIFont systemFontOfSize:30];
    NSDictionary *attributeDic = @{NSFontAttributeName:font};
    [text drawInRect:textFrame withAttributes:attributeDic];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
