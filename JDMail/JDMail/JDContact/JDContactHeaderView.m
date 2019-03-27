//
//  JDContactHeaderView.m
//  JDMail
//
//  Created by 公司 on 2019/1/24.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDContactHeaderView.h"

@interface JDContactHeaderView ()

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *contactsButton;
@property (nonatomic, strong) UIButton *groupsButton;

@end

@implementation JDContactHeaderView

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
    [self addSubview:self.addButton];
    [self addSubview:self.contactsButton];
    [self addSubview:self.groupsButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonMargin = 50.0;
    CGFloat buttonWidth = 40.0;
    CGFloat buttonY = 10.0;
    CGFloat buttonGap = (CGRectGetWidth([UIScreen mainScreen].bounds)-buttonMargin-buttonMargin-3*buttonWidth)/2.0;
    
    self.addButton.frame = CGRectMake(buttonMargin, buttonY, buttonWidth, buttonWidth);
    
    CGFloat contactsX = CGRectGetMaxX(self.addButton.frame)+buttonGap;
    self.contactsButton.frame = CGRectMake(contactsX, buttonY, buttonWidth, buttonWidth);
    
    CGFloat groupX = CGRectGetMaxX(self.contactsButton.frame)+buttonGap;
    self.groupsButton.frame = CGRectMake(groupX, buttonY, buttonWidth, buttonWidth);
}

#pragma mark - getter/setter

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setImage:nil forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"contact_addcontact"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (void)addButtonDidClicked:(UIButton *)sender
{
    if (self.addBlock) {
        self.addBlock();
    }
}

- (UIButton *)contactsButton
{
    if (!_contactsButton) {
        _contactsButton = [[UIButton alloc] init];
        [_contactsButton setImage:nil forState:UIControlStateNormal];
        [_contactsButton addTarget:self action:@selector(contactsButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _contactsButton.backgroundColor = [UIColor greenColor];
    }
    return _contactsButton;
}

- (void)contactsButtonDidClicked:(UIButton *)sender
{
    if (self.contactsBlock) {
        self.contactsBlock();
    }
}

- (UIButton *)groupsButton
{
    if (!_groupsButton) {
        _groupsButton = [[UIButton alloc] init];
        [_groupsButton setImage:nil forState:UIControlStateNormal];
        [_groupsButton addTarget:self action:@selector(groupsButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _groupsButton.backgroundColor = [UIColor greenColor];
    }
    return _groupsButton;
}

- (void)groupsButtonDidClicked:(UIButton *)sender
{
    if (self.groupBlock) {
        self.groupBlock();
    }
}

@end
