//
//  JDSlipMenuHeaderView.m
//  JDMail
//
//  Created by 公司 on 2019/1/23.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDSlipMenuHeaderView.h"
#import "NSDictionary+Extend.h"
#import "UIColor+Extend.h"

@interface JDSlipMenuHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *sepView;

@end

@implementation JDSlipMenuHeaderView

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
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    [self addSubview:self.sepView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat titleX = 20.0;
    CGFloat titleY = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+10.0;
    CGFloat titleW = CGRectGetWidth(self.bounds)-titleX-20.0;
    CGFloat titleH = 19.0;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat subtitleX = 20.0;
    CGFloat subtitleY = CGRectGetMaxY(self.titleLabel.frame) + 10.0;
    CGFloat subtitleW = CGRectGetWidth(self.bounds)-subtitleX-20.0;;
    CGFloat subtitleH = 19.0;
    self.subtitleLabel.frame = CGRectMake(subtitleX, subtitleY, subtitleW, subtitleH);
    
    CGFloat sepX = 0.0;
    CGFloat sepY = CGRectGetHeight(self.bounds)-1.0;
    CGFloat sepW = CGRectGetWidth(self.bounds);
    CGFloat sepH = 1.0;
    self.sepView.frame = CGRectMake(sepX, sepY, sepW, sepH);
}

- (void)reloadWithModel:(NSDictionary *)model
{
    self.titleLabel.text = [model jd_stringForKey:@"title"];
    self.subtitleLabel.text = [model jd_stringForKey:@"subtitle"];
    [self setNeedsLayout];
}

#pragma mark - Getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
    }
    return _subtitleLabel;
}

- (UIView *)sepView
{
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.5];
    }
    return _sepView;
}

@end
