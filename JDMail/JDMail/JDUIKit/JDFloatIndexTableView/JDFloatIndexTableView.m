//
//  JDFloatIndexTableView.m
//  JDDemo
//
//  Created by 公司 on 2019/1/18.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDFloatIndexTableView.h"
#import "JDTableViewIndexView.h"

@interface JDFloatIndexTableView ()<JDTableViewIndexViewDelegate, CAAnimationDelegate>

@property (nonatomic, strong) UILabel *floatingLabel;
@property (nonatomic, strong) JDTableViewIndexView *tableIndexView;
@property (nonatomic) BOOL tableIndexViewScrolled;

@end

@implementation JDFloatIndexTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self relayoutFloatingLableFrame];
    [self.tableIndexView reloadTableIndex];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self.tableIndexView removeFromSuperview];
    [self.superview addSubview:self.tableIndexView];
    
    [self.floatingLable removeFromSuperview];
    [self.superview addSubview:self.floatingLable];
    [self relayoutFloatingLableFrame];
    [self.tableIndexView reloadTableIndex];
}

- (void)removeFromSuperview
{
    [self.tableIndexView removeFromSuperview];
    [self.floatingLable removeFromSuperview];
    [super removeFromSuperview];
}

- (void)relayoutFloatingLableFrame
{
    CGRect floatingFrame = CGRectMake(0.0, 0.0, 90.0, 90.0);
    self.floatingLable.frame = floatingFrame;
    self.floatingLabel.center = self.superview.center;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    self.tableIndexView.hidden = hidden;
}

- (void)reloadData
{
    [super reloadData];
    [self.tableIndexView reloadTableIndex];
}

#pragma mark - Observer Table ContentOffset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"contentOffset"] || self.tableIndexViewScrolled) {
        return;
    }
    
    NSIndexPath *currentIndex = [self indexPathsForVisibleRows].firstObject;
    if (currentIndex != nil) {
        NSInteger imageSections = [self numberOfImageSections];
        self.tableIndexView.highLightIndex = currentIndex.section + imageSections;
        [self.tableIndexView reloadTableIndex];
    }
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.floatingLable.hidden = YES;
}

#pragma mark - JDTableViewIndexViewDelegate

- (NSArray *)sectionIndexTitles
{
    if ([self.indexDataSource respondsToSelector:@selector(sectionIndexTitlesForIndexTableView:)]) {
        return [self.indexDataSource sectionIndexTitlesForIndexTableView:self];
    }else{
        return nil;
    }
}

- (NSInteger)numberOfImageSections
{
    if ([self.indexDataSource respondsToSelector:@selector(numberOfImageSectionsInIndexTableView:)]) {
        return [self.indexDataSource numberOfImageSectionsInIndexTableView:self];
    }else{
        return 0;
    }
}

- (void)touchBeginWithTableIndexView:(JDTableViewIndexView *)indexView
{
    self.tableIndexViewScrolled = YES;
}

- (void)touchEndWithTableIndexView:(JDTableViewIndexView *)indexView
{
    self.tableIndexViewScrolled = NO;
    
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    animation.delegate = self;
    [self.floatingLable.layer addAnimation:animation forKey:nil];
}

- (void)touchWithTableIndexView:(JDTableViewIndexView *)indexView indexTitle:(NSString *)title index:(NSInteger)index
{
    NSInteger imageSections = [self numberOfImageSections];
    NSInteger newIndex = 0;
    if (index < imageSections) {
        self.floatingLable.hidden = YES;
    } else {
        self.floatingLable.hidden = NO;
        self.floatingLable.text = title;
        newIndex = index - imageSections;
    }
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:newIndex] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Getter/Setter
- (JDTableViewIndexView *)tableIndexView {
    if (!_tableIndexView) {
        _tableIndexView = [[JDTableViewIndexView alloc] init];
        _tableIndexView.delegate = self;
    }
    return _tableIndexView;
}

- (UILabel *)floatingLable {
    if (!_floatingLabel) {
        _floatingLabel = [[UILabel alloc] init];
        _floatingLabel.font = [UIFont boldSystemFontOfSize:60.0];
        _floatingLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        _floatingLabel.textAlignment = NSTextAlignmentCenter;
        _floatingLabel.layer.cornerRadius = 8.0;
        _floatingLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        _floatingLabel.hidden = YES;
        _floatingLabel.clipsToBounds = YES;
    }
    return _floatingLabel;
}

@end
