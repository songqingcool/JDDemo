//
//  JDSlipMenuLeftView.m
//  JDMail
//
//  Created by 公司 on 2019/1/23.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDSlipMenuLeftView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "UIColor+Extend.h"

#define kButtonWidth 50.0
#define kButtonGap 20.0

@interface JDSlipMenuLeftView ()

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) NSMutableArray *buttonsArray;
@property (nonatomic, strong) NSArray *accounts;

@end

@implementation JDSlipMenuLeftView

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
    self.backgroundColor = [UIColor colorWithHex:0xF1F1F1];
    [self addSubview:self.addButton];
    [self addSubview:self.settingButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat settingX = 10.0;
    CGFloat settingW = kButtonWidth;
    CGFloat settingH = kButtonWidth;
    CGFloat settingY = CGRectGetHeight(self.bounds)-settingH-34.0;
    self.settingButton.frame = CGRectMake(settingX, settingY, settingW, settingH);
}

- (void)reloadWithAccounts:(NSArray *)accounts
{
    self.accounts = accounts;
    
    CGFloat y = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+10.0;
    if (accounts.count > self.buttonsArray.count) {
        for (int i = 0; i<self.buttonsArray.count; i++) {
            NSDictionary *account = [accounts objectAtIndex:i];
            NSString *icon = [account objectForKey:@"icon"];
            UIButton *button = [self.buttonsArray objectAtIndex:i];
            button.tag = i;
            button.frame = CGRectMake(10.0, y, kButtonWidth, kButtonWidth);
            [button sd_setImageWithURL:[NSURL URLWithString:icon] forState:UIControlStateNormal placeholderImage:nil];
            y += kButtonWidth + kButtonGap;
        }
        for (int i = (int)self.buttonsArray.count; i< accounts.count; i++) {
            NSDictionary *account = [accounts objectAtIndex:i];
            NSString *icon = [account objectForKey:@"icon"];
            UIButton *button = [[UIButton alloc] init];
            button.tag = i;
            button.frame = CGRectMake(10.0, y, kButtonWidth, kButtonWidth);
            [button sd_setImageWithURL:[NSURL URLWithString:icon] forState:UIControlStateNormal placeholderImage:nil];
            [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [self.buttonsArray addObject:button];
            y += kButtonWidth + kButtonGap;
        }
    }else{
        for (int i = 0; i<accounts.count; i++) {
            NSDictionary *account = [accounts objectAtIndex:i];
            NSString *icon = [account objectForKey:@"icon"];
            UIButton *button = [self.buttonsArray objectAtIndex:i];
            button.tag = i;
            button.frame = CGRectMake(10.0, y, kButtonWidth, kButtonWidth);
            [button sd_setImageWithURL:[NSURL URLWithString:icon] forState:UIControlStateNormal placeholderImage:nil];
            y += kButtonWidth + kButtonGap;
        }
        [self.buttonsArray removeObjectsInRange:NSMakeRange(accounts.count, self.buttonsArray.count-accounts.count)];
    }
    self.addButton.frame = CGRectMake(10.0, y, kButtonWidth, kButtonWidth);
}

- (void)buttonDidClicked:(UIButton *)sender
{
    NSDictionary *account = [self.accounts objectAtIndex:sender.tag];
    if (self.accountBlock) {
        self.accountBlock(account);
    }
}

#pragma mark - Getter

- (UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setImage:[UIImage imageNamed:@"slip_addaccount"] forState:UIControlStateNormal];
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

- (UIButton *)settingButton
{
    if (!_settingButton) {
        _settingButton = [[UIButton alloc] init];
        [_settingButton setImage:[UIImage imageNamed:@"slip_setting"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(settingButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (void)settingButtonDidClicked:(UIButton *)sender
{
    if (self.settingBlock) {
        self.settingBlock();
    }
}

- (NSMutableArray *)buttonsArray
{
    if (!_buttonsArray) {
        _buttonsArray = [NSMutableArray array];
    }
    return _buttonsArray;
}

@end
