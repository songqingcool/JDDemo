//
//  JDContactFieldCell.m
//  JDMail
//
//  Created by 公司 on 2019/3/7.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDContactFieldCell.h"

@interface JDContactFieldCell ()<UITextFieldDelegate>

@end

@implementation JDContactFieldCell

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
    [self.contentView addSubview:self.textField];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat fieldX = 10.0;
    CGFloat fieldY = 10.0;
    CGFloat fieldW = CGRectGetWidth([UIScreen mainScreen].bounds)-fieldX-10.0;
    CGFloat fieldH = 40.0;
    self.textField.frame = CGRectMake(fieldX, fieldY, fieldW, fieldH);
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.textField.text = content;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

#pragma mark - getter/setter

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
    }
    return _textField;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.endEditBlock) {
        self.endEditBlock(textField.text);
    }
}

@end
