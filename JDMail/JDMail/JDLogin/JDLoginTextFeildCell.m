//
//  JDLoginTextFeildCell.m
//  JDMail
//
//  Created by 公司 on 2019/2/27.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDLoginTextFeildCell.h"
#import "UIColor+Extend.h"

@interface JDLoginTextFeildCell ()<UITextFieldDelegate>

@property (nonatomic, strong) NSDictionary *model;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JDLoginTextFeildCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.textField];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat titleX = 10.0;
    CGFloat titleY = 10.0;
    CGFloat titleW = 60.0;
    CGFloat titleH = 20.0;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat textX = CGRectGetMaxX(self.titleLabel.frame)+10.0;
    CGFloat textY = 10.0;
    CGFloat textW = CGRectGetWidth([UIScreen mainScreen].bounds)-textX-10.0;
    CGFloat textH = 20.0;
    self.textField.frame = CGRectMake(textX, textY, textW, textH);
}

- (void)reloadWithModel:(NSDictionary *)model
{
    self.model = model;
    self.titleLabel.text = [model objectForKey:@"title"];
    
    NSString *placeholder = [model objectForKey:@"placeholder"];
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0],NSForegroundColorAttributeName:[UIColor colorWithHex:0xBBBBBB]}];
    self.textField.attributedPlaceholder = placeholderString;
}

#pragma mark - getter/setter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _titleLabel.textColor = [UIColor colorWithHex:0x050505];
    }
    return _titleLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.delegate = self;
    }
    return _textField;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textBlock) {
        self.textBlock(textField.text, [self.model objectForKey:@"title"]);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

