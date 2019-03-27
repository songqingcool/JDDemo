//
//  JDZoomImageScrollView.m
//  JDSafeSpace
//
//  Created by 公司 on 2018/12/21.
//  Copyright © 2018 公司. All rights reserved.
//

#import "JDZoomImageScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"

@interface JDZoomImageScrollView() <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) BOOL isLoaded;
@property (nonatomic, copy) NSString *imageUrl;

@end

@implementation JDZoomImageScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        [self addSubview:self.imageView];
        
        UIGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureAction:)];
        [self addGestureRecognizer:singleGesture];
        
        UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageViewDidDoubleTapped:)];
        doubleGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleGesture];
        [singleGesture requireGestureRecognizerToFail:doubleGesture];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.imageView.frame;
    frame.origin.x = CGRectGetWidth(self.frame) > CGRectGetWidth(frame) ? ((CGRectGetWidth(self.frame) - CGRectGetWidth(frame)) / 2.0) : 0.0;
    frame.origin.y = CGRectGetHeight(self.frame) > CGRectGetHeight(frame) ? ((CGRectGetHeight(self.frame) - CGRectGetHeight(frame)) /2.0) : 0.0;
    self.imageView.frame = frame;
}

- (void)setImageUrl:(NSString *)imageUrl placeHolder:(UIImage *)placeHolderImage
{
    self.imageUrl = imageUrl;
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 1.0;
    self.zoomScale = 1.0;
    self.imageView.frame = self.bounds;
    self.contentOffset = CGPointZero;
    self.isLoaded = NO;
    __weak JDZoomImageScrollView *weakSelf = self;
    [self.imageView sd_internalSetImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeHolderImage options:SDWebImageRetryFailed operationKey:nil setImageBlock:^(UIImage *image, NSData *imageData) {
        __strong JDZoomImageScrollView *strongSelf = weakSelf;
        [strongSelf setImage:image];
    } progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong JDZoomImageScrollView *strongSelf = weakSelf;
        strongSelf.isLoaded = YES;
    }];
}

- (void)setImage:(UIImage *)image
{
    if (!image) {
        return;
    }
    
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    
    if (w >=self.bounds.size.width) {
        w = [UIScreen mainScreen].bounds.size.width;
        h = h/(image.size.width/w);
    }else{
        w = [UIScreen mainScreen].bounds.size.width;
        if (image.size.width) {
            h *= w/image.size.width;
        }else{
            h = [UIScreen mainScreen].bounds.size.height;
        }
    }
    
    self.maximumZoomScale = MAX([UIScreen mainScreen].bounds.size.height / h, 2.0);
    self.minimumZoomScale = 1.0;
    self.zoomScale = 1.0;
    
    self.contentSize = CGSizeMake(w, h);
    
    CGFloat x = MAX((self.bounds.size.width - w) * 0.5, 0.0);;
    CGFloat y = MAX((self.bounds.size.height - h) * 0.5, 0.0);
    self.imageView.frame = CGRectMake(x, y, w, h);
    self.imageView.image = image;
    [self setNeedsLayout];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.isLoaded) {
        return self.imageView;
    }
    return nil;
}

#pragma mark - Gesture Action
- (void)singleTapGestureAction:(UITapGestureRecognizer *)gesture
{
    if (self.tapClickBlock) {
        self.tapClickBlock();
    }
}

- (void)tapImageViewDidDoubleTapped:(UIGestureRecognizer *)doubleTap
{
    if (self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGPoint point = [doubleTap locationInView:doubleTap.view];
        CGFloat touchX = point.x;
        CGFloat touchY = point.y;
        touchX *= 1/self.zoomScale;
        touchY *= 1/self.zoomScale;
        touchX += self.contentOffset.x;
        touchY += self.contentOffset.y;
        CGRect zoomRect = [self zoomRectForScale:self.maximumZoomScale withCenter:CGPointMake(touchX, touchY)];
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    CGFloat height = self.frame.size.height / scale;
    CGFloat width  = self.frame.size.width / scale;
    CGFloat x = center.x - width * 0.5;
    CGFloat y = center.y - height * 0.5;
    return CGRectMake(x, y, width, height);
}

#pragma mark - Getter & Setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor blackColor];
        [_imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_imageView sd_setShowActivityIndicatorView:YES];
    }
    return _imageView;
}

- (UIImageView *)zoomImageView
{
    return self.imageView;
}

@end
