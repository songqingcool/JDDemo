//
//  JDBrowserCollectionViewCell.m
//  JDSafeSpace
//
//  Created by 公司 on 2018/12/21.
//  Copyright © 2018 公司. All rights reserved.
//

#import "JDBrowserCollectionViewCell.h"
#import "JDZoomImageScrollView.h"
#import "JDImageSourceModel.h"

@interface JDBrowserCollectionViewCell ()

@property(nonatomic, strong) JDZoomImageScrollView *scrollView;
@property(nonatomic, strong) JDImageSourceModel *model;

@end

@implementation JDBrowserCollectionViewCell

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
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.scrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat scrollX = 0.0;
    CGFloat scrollY = 0.0;
    CGFloat scrollW = CGRectGetWidth(self.frame);
    CGFloat scrollH = CGRectGetHeight(self.frame);
    self.scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
}

- (void)reloadWithModel:(JDImageSourceModel *)model
{
    self.model = model;
    
    [self.scrollView setImageUrl:model.imageUrl placeHolder:nil];
}

- (UIImageView *)currentImageView
{
    return [self.scrollView zoomImageView];
}

#pragma mark - Getter
- (JDZoomImageScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[JDZoomImageScrollView alloc] init];
        __weak JDBrowserCollectionViewCell *weakSelf = self;
        _scrollView.tapClickBlock = ^{
            __strong JDBrowserCollectionViewCell *strongSelf = weakSelf;
            if (strongSelf.tapClickBlock) {
                strongSelf.tapClickBlock(strongSelf.model);
            }
        };
    }
    return _scrollView;
}

@end
