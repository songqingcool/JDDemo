//
//  JDBrowserImageCell.m
//  JDDemo
//
//  Created by 宋庆功 on 2018/12/11.
//  Copyright © 2018 京东. All rights reserved.
//

#import "JDBrowserImageCell.h"
#import "JDImageModel.h"
#import "UIImageView+WebCache.h"

@interface JDBrowserImageCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapSingle;
@property (nonatomic, strong) UITapGestureRecognizer *tapDouble;

@property (nonatomic, strong) JDImageModel *model;

@end

@implementation JDBrowserImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.scrollView addSubview:self.imageView];
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addGestureRecognizer:self.tapDouble];
        [self.scrollView addGestureRecognizer:self.tapSingle];
        [self.tapSingle requireGestureRecognizerToFail:self.tapDouble];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.contentView.bounds;
    self.scrollView.contentSize = self.contentView.bounds.size;
    self.imageView.frame = self.contentView.bounds;
}

- (void)reloadWithModel:(JDImageModel *)model
{
    self.model = model;
    __weak JDBrowserImageCell *weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong JDBrowserImageCell *strongSelf = weakSelf;
        [strongSelf updateLayoutWithImageSize:image.size];
    }];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 0.5;
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UITapGestureRecognizer *)tapSingle
{
    if (!_tapSingle) {
        _tapSingle = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewSingleTapAction:)];
        _tapSingle.numberOfTapsRequired = 1;
    }
    return _tapSingle;
}

- (void)imageViewSingleTapAction:(UITapGestureRecognizer *)ges
{
    [self.scrollView setZoomScale:1.0 animated:YES];
    [self.scrollView setContentOffset:CGPointZero];
    
    if (self.singleClickBlock) {
        self.singleClickBlock(self.model);
    }
}

- (UITapGestureRecognizer *)tapDouble
{
    if (!_tapDouble) {
        _tapDouble = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewDoubleTapAction:)];
        _tapDouble.numberOfTapsRequired = 2;
    }
    return _tapDouble;
}

- (void)imageViewDoubleTapAction:(UITapGestureRecognizer *)ges
{
    [self.scrollView setZoomScale:(self.scrollView.zoomScale == 2.0)?1.0:2.0 animated:YES];
}

- (void)updateLayoutWithImageSize:(CGSize)size
{
    CGFloat scaleW = size.width/CGRectGetWidth(self.scrollView.bounds);
    CGFloat scaleH = size.height/CGRectGetHeight(self.scrollView.bounds);
    CGFloat scale = MAX(scaleW, scaleH);
    CGFloat contentW = 0.0;
    CGFloat contentH = 0.0;
    if (scale > 0.0) {
        contentW = size.width/scale;
        contentH = size.height/scale;
    }
    CGFloat width = MAX(contentW, CGRectGetWidth(self.scrollView.bounds));
    CGFloat height = MAX(contentH, CGRectGetHeight(self.scrollView.bounds));
    CGFloat centerX = width/2.0;
    CGFloat centerY = height/2.0;
    self.imageView.frame = CGRectMake(0.0, 0.0, contentW, contentH);
    self.imageView.center = CGPointMake(centerX, centerY);
    self.scrollView.contentSize = CGSizeMake(width, height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
