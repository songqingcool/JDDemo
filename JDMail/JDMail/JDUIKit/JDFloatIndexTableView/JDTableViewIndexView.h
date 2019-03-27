//
//  JDTableViewIndexView.h
//  JDDemo
//
//  Created by 公司 on 2019/1/18.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDTableViewIndexView;

@protocol JDTableViewIndexViewDelegate <NSObject>

- (NSArray *)sectionIndexTitles;
- (NSInteger)numberOfImageSections;

- (void)touchBeginWithTableIndexView:(JDTableViewIndexView *)indexView;
- (void)touchEndWithTableIndexView:(JDTableViewIndexView *)indexView;
- (void)touchWithTableIndexView:(JDTableViewIndexView *)indexView indexTitle:(NSString *)title index:(NSInteger)index;

@end


@interface JDTableViewIndexView : UIView

@property(nonatomic, strong) UIFont *indexFont;
@property(nonatomic, strong) UIColor *normalColor;
@property(nonatomic, strong) UIColor *highLightColor;
@property(nonatomic, strong) UIColor *highLightBckColor;
@property(nonatomic) NSUInteger highLightIndex;
@property (nonatomic, weak) id<JDTableViewIndexViewDelegate> delegate;

- (void)reloadTableIndex;

@end

NS_ASSUME_NONNULL_END
