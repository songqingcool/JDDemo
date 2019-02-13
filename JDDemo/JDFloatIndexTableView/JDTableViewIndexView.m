//
//  JDTableViewIndexView.m
//  JDDemo
//
//  Created by 宋庆功 on 2019/1/18.
//  Copyright © 2019 京东. All rights reserved.
//

#import "JDTableViewIndexView.h"
#import "UIColor+Extend.h"

#define kIndexExtensionGap 2.0

@interface JDTableViewIndexView ()

@property(nonatomic, strong) NSMutableArray *textLables;

@end

@implementation JDTableViewIndexView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.indexFont = [UIFont systemFontOfSize:13.0];
        self.normalColor = [UIColor colorWithHex:0x4A4A4A];
        self.highLightColor = [UIColor whiteColor];
        self.highLightBckColor = [UIColor colorWithHex:0x007AFF];
        self.highLightIndex = 0;
    }
    return self;
}

#pragma mark - Move Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(touchBeginWithTableIndexView:)]) {
        [self.delegate touchBeginWithTableIndexView:self];
    }
    [self touchActionWithEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self touchActionWithEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(touchEndWithTableIndexView:)]) {
        [self.delegate touchEndWithTableIndexView:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(touchEndWithTableIndexView:)]) {
        [self.delegate touchEndWithTableIndexView:self];
    }
}

- (void)touchActionWithEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self];
    NSInteger indx = ((NSInteger)floorf(point.y) / (self.indexFont.lineHeight + kIndexExtensionGap));
    NSArray *indexTitleList = nil;
    if ([self.delegate respondsToSelector:@selector(sectionIndexTitles)]) {
        indexTitleList = [self.delegate sectionIndexTitles];
    }
    NSInteger imageSections = 0;
    if ([self.delegate respondsToSelector:@selector(numberOfImageSections)]) {
        imageSections = [self.delegate numberOfImageSections];
    }
    
    if (indx < 0 || indx<imageSections ||indx > indexTitleList.count - 1) {
        return;
    }
    
    NSString *title = [indexTitleList objectAtIndex:indx];
    self.highLightIndex = indx;
    [self reloadTableIndexTitle];
    
    if ([self.delegate respondsToSelector:@selector(touchWithTableIndexView:indexTitle:index:)]) {
        [self.delegate touchWithTableIndexView:self indexTitle:title index:indx];
    }
}

#pragma mark - reloadIndex
- (void)reloadTableIndex
{
    [self relayoutTableIndex];
    [self reloadTableIndexTitle];
}

- (void)relayoutTableIndex
{
    NSArray *indexTitles = nil;
    if ([self.delegate respondsToSelector:@selector(sectionIndexTitles)]) {
        indexTitles = [self.delegate sectionIndexTitles];
    }
    CGRect selFrame = self.frame;
    selFrame.size.height = indexTitles.count * (self.indexFont.lineHeight + kIndexExtensionGap);
    selFrame.size.width = self.indexFont.lineHeight + kIndexExtensionGap;
    
    UIView *bounceView = (UIView *)self.delegate;
    CGRect parentRect = bounceView.frame;
    selFrame.origin.x = CGRectGetWidth(parentRect) - CGRectGetWidth(selFrame) - 0.5;
    selFrame.origin.y = (CGRectGetHeight(parentRect) - CGRectGetHeight(selFrame)) / 2.0;
    self.frame = selFrame;
}

- (void)reloadTableIndexTitle
{
    for (UILabel *lable in self.textLables) {
        [lable removeFromSuperview];
    }
    CGFloat letterHeight = self.indexFont.lineHeight + kIndexExtensionGap;
    NSArray *indexTitleList = nil;
    if ([self.delegate respondsToSelector:@selector(sectionIndexTitles)]) {
        indexTitleList = [self.delegate sectionIndexTitles];
    }
    NSInteger imageSections = 0;
    if ([self.delegate respondsToSelector:@selector(numberOfImageSections)]) {
        imageSections = [self.delegate numberOfImageSections];
    }
    for (NSUInteger i = 0; i < indexTitleList.count; i++) {
        CGFloat originY = i * letterHeight;
        UILabel *textLayer = [self reuseTextLableWithIndex:i];
        CGRect textFrame = textLayer.frame;
        textFrame.origin.y = originY;
        textLayer.frame = textFrame;
        NSString *title = [indexTitleList objectAtIndex:i];
        
        UIColor *textColor = nil;
        if (i == self.highLightIndex) {
            textColor = self.highLightColor;
            textLayer.backgroundColor = self.highLightBckColor;
        }else{
            textColor = self.normalColor;
            textLayer.backgroundColor = [UIColor clearColor];
        }
        
        if (i < imageSections) {
            UIImage *image = [UIImage imageNamed:title];
            NSTextAttachment *att = [[NSTextAttachment alloc] init];
            att.image = image;
            att.bounds = CGRectMake(0.0, -2.0, textLayer.font.lineHeight, textLayer.font.lineHeight);
            textLayer.attributedText = [NSAttributedString attributedStringWithAttachment:att];
        } else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:self.indexFont forKey:NSFontAttributeName];
            [dict setValue:textColor forKey:NSForegroundColorAttributeName];
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.alignment = NSTextAlignmentCenter;
            [dict setValue:style forKey:NSParagraphStyleAttributeName];
            textLayer.attributedText = [[NSAttributedString alloc] initWithString:title attributes:dict];
        }
        [self addSubview:textLayer];
    }
}

- (UILabel *)reuseTextLableWithIndex:(NSInteger)index
{
    UILabel *textLayer = nil;
    if (index >= self.textLables.count) {
        textLayer = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.indexFont.lineHeight + kIndexExtensionGap, self.indexFont.lineHeight+kIndexExtensionGap)];
        textLayer.layer.cornerRadius = 3.0;
        textLayer.clipsToBounds = YES;
        [self.textLables addObject:textLayer];
    } else {
        textLayer = [self.textLables objectAtIndex:index];
    }
    return textLayer;
}

#pragma mark - getters
- (NSMutableArray *)textLables {
    if (!_textLables) {
        _textLables = [NSMutableArray array];
    }
    return _textLables;
}

@end
