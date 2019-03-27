//
//  JDImageTransitionPresentAnimation.m
//  JDSafeSpace
//
//  Created by 公司 on 2018/12/21.
//  Copyright © 2018 公司. All rights reserved.
//

#import "JDImageTransitionPresentAnimation.h"
#import "JDImageAnimatedTransitionDataSource.h"

@interface JDImageTransitionPresentAnimation()

@end

@implementation JDImageTransitionPresentAnimation

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController<JDImageAnimatedTransitionDataSource> *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    toController.view.alpha = 0.0;
    if ([toController respondsToSelector:@selector(animatedTransitionBeginPresentViewController)]) {
        [toController animatedTransitionBeginPresentViewController];
    }
    [containerView addSubview:toController.view];
    containerView.backgroundColor = [UIColor clearColor];
    
    CGRect tapImageViewFrameInScreen = CGRectZero;
    UIImageView *tapImageView = nil;
    if ([toController respondsToSelector:@selector(animatedTransitionPresentViewControllerTapView)]) {
        tapImageView = [toController animatedTransitionPresentViewControllerTapView];
        if (tapImageView) {
            tapImageViewFrameInScreen = [tapImageView convertRect:tapImageView.bounds toView:[UIApplication sharedApplication].delegate.window];
        }
    }
    UIImage *image = tapImageView.image;
    
    UIImageView *imageViewForAnimation = [[UIImageView alloc] initWithFrame:tapImageViewFrameInScreen];
    imageViewForAnimation.contentMode = UIViewContentModeScaleAspectFill;
    imageViewForAnimation.clipsToBounds = YES;
    imageViewForAnimation.image = image;
    [containerView addSubview:imageViewForAnimation];
    
    CGFloat w = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat h = 0.0;
    if (image.size.width > 0.0) {
        h = image.size.height*CGRectGetWidth([UIScreen mainScreen].bounds)/image.size.width;
    }else{
        h = CGRectGetHeight([UIScreen mainScreen].bounds);
    }
    CGFloat x = 0.0;
    CGFloat y = MAX((CGRectGetHeight([UIScreen mainScreen].bounds) - h) * 0.5, 0.0);
    CGRect finalRect = CGRectMake(x, y, w, h);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageViewForAnimation.frame = finalRect;
        imageViewForAnimation.center = toController.view.center;
        toController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        if ([toController respondsToSelector:@selector(animatedTransitionEndPresentViewController)]) {
            [toController animatedTransitionEndPresentViewController];
        }
        [imageViewForAnimation removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
