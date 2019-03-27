//
//  JDMailReplyView.m
//  JDMail
//
//  Created by 公司 on 2019/3/4.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDMailReplyView.h"

@interface JDMailReplyView ()

@property(nonatomic, strong) UIButton *forwardingButton;
@property(nonatomic, strong) UIButton *moreButton;
@property(nonatomic, strong) UIButton *replyAllButton;

@end

@implementation JDMailReplyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:248/251.0 green:248/251.0 blue:248/251.0 alpha:1.0];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.replyAllButton];
    [self addSubview:self.forwardingButton];
    [self addSubview:self.moreButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat moreY = 0.0;
    CGFloat moreW = 50.0;
    CGFloat moreH = 50.0;
    CGFloat moreX = CGRectGetWidth(self.frame)-10.0-moreW;
    self.moreButton.frame = CGRectMake(moreX, moreY, moreW, moreH);
    
    CGFloat forwardingY = 0.0;
    CGFloat forwardingW = 50.0;
    CGFloat forwardingH = 50.0;
    CGFloat forwardingX = CGRectGetMinX(self.moreButton.frame)-10.0-forwardingW;
    self.forwardingButton.frame = CGRectMake(forwardingX, forwardingY, forwardingW, forwardingH);
    
    CGFloat replyAllX = 10.0;
    CGFloat replyAllY = 0.0;
    CGFloat replyAllW = CGRectGetMinX(self.forwardingButton.frame)-10.0-replyAllX;
    CGFloat replyAllH = 50.0;
    self.replyAllButton.frame = CGRectMake(replyAllX, replyAllY, replyAllW, replyAllH);
}

- (UIButton *)replyAllButton
{
    if(!_replyAllButton) {
        _replyAllButton = [[UIButton alloc] init];
        [_replyAllButton setTitle:@"全部回复" forState:UIControlStateNormal];
        _replyAllButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_replyAllButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _replyAllButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_replyAllButton addTarget:self action:@selector(replyAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyAllButton;
}

- (void)replyAllButtonAction:(UIButton *)sender
{
    if (self.replyAllBlock) {
        self.replyAllBlock();
    }
}

- (UIButton *)forwardingButton
{
    if(!_forwardingButton) {
        _forwardingButton = [[UIButton alloc] init];
        [_forwardingButton setImage:[UIImage imageNamed:@"ic_reply_all_dark_grey"] forState:UIControlStateNormal];
        [_forwardingButton addTarget:self action:@selector(forwardingAction:) forControlEvents:UIControlEventTouchUpInside];
        [_forwardingButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _forwardingButton;
}

- (void)forwardingAction:(UIButton *)sender
{
    if (self.forwardingBlock) {
        self.forwardingBlock();
    }
}

- (UIButton *)moreButton
{
    if(!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _moreButton;
}

- (void)moreAction:(UIButton *)sender
{
    if (self.moreBlock) {
        self.moreBlock();
    }
}

@end
