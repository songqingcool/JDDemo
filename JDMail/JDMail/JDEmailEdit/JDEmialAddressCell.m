//
//  JDEmialAddressCell.m
//  JDMail
//
//  Created by 千阳 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDEmialAddressCell.h"
#import "UIView+Frame.h"

@interface JDEmialAddressCell()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextField *emialAddressText;

@end

@implementation JDEmialAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.emialAddressText];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self titleLabelLayout];
    [self emialAddressTextLayout];
}

- (void)titleLabelLayout
{
    self.titleLabel.left = 18;
    self.titleLabel.top = 0;
    self.titleLabel.width = 18*self.titleLabel.text.length;
    self.titleLabel.height = self.height;
}

- (void)emialAddressTextLayout
{
    self.emialAddressText.left = self.titleLabel.right+5;
    self.emialAddressText.top = 0;
    self.emialAddressText.width = ScreenWidth-self.titleLabel.width -5;
    self.emialAddressText.height = self.height;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel= [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UITextField *)emialAddressText
{
    if(!_emialAddressText)
    {
        _emialAddressText = [[UITextField alloc] init];
        _emialAddressText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _emialAddressText;
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = [NSString stringWithFormat:@"%@:",title];
}

-(NSArray *)recipients
{
    NSString *recipientsStr =self.emialAddressText.text;
    if(recipientsStr.length >0)
    {
       return [recipientsStr componentsSeparatedByString:@";"];
    }
    return nil;
}

- (NSString *)subject
{
    return self.emialAddressText.text;
}

- (void)setSubject:(NSString *)subject
{
    self.emialAddressText.text = subject;
}

- (void)loadEmailAdress:(NSArray *)recipients
{
    if(recipients.count >0)
        self.emialAddressText.text = [recipients componentsJoinedByString:@";"];
}

@end
