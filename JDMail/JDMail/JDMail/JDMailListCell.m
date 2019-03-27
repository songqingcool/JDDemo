//
//  JDMailListCell.m
//  JDMail
//
//  Created by 公司 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDMailListCell.h"
#import "UIColor+Extend.h"
#import "JDMailListModel.h"
#import "JDMailPerson.h"

@interface JDMailListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *bodyLabel;

@end

@implementation JDMailListCell

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
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.bodyLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat titleX = 10.0;
    CGFloat titleW = CGRectGetWidth([UIScreen mainScreen].bounds) - titleX - 10.0;
    self.titleLabel.frame = CGRectMake(titleX, 10.0, titleW, 20.0);
    
    CGFloat subtitleY = CGRectGetMaxY(self.titleLabel.frame) + 7.0;
    self.subtitleLabel.frame = CGRectMake(titleX, subtitleY, titleW, 16.0);
    
    CGFloat bodyY = CGRectGetMaxY(self.subtitleLabel.frame) + 7.0;
    self.bodyLabel.frame = CGRectMake(titleX, bodyY, titleW, 40.0);
}

- (void)reloadWithModel:(JDMailListModel *)model
{
    if (model.from.name.length) {
        self.titleLabel.text = model.from.name;
    }else{
        self.titleLabel.text = model.from.emailAddress;
    }
    
    self.subtitleLabel.text = model.subject;
    
    if (model.bodyString.length) {
        self.bodyLabel.text = model.bodyString;
    }else{
        self.bodyLabel.text = @"此邮件不包含任何内容";
    }
}

#pragma mark - getter/setter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        _titleLabel.textColor = [UIColor colorWithHex:0x050505];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _subtitleLabel;
}

- (UILabel *)bodyLabel
{
    if (!_bodyLabel) {
        _bodyLabel = [[UILabel alloc] init];
        _bodyLabel.textColor = [UIColor grayColor];
        _bodyLabel.font = [UIFont systemFontOfSize:15.0];
        _bodyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _bodyLabel.numberOfLines = 2;
    }
    return _bodyLabel;
}

@end
