//
//  JDImageTransitionDismissAnimation.m
//  JDSafeSpace
//
//  Created by 公司 on 2018/12/21.
//  Copyright © 2018 公司. All rights reserved.
//

#import "JDImageTransitionDismissAnimation.h"
#import "JDImageAnimatedTransitionDataSource.h"

@interface JDImageTransitionDismissAnimation()

@end

@implementation JDImageTransitionDismissAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController<JDImageAnimatedTransitionDataSource> *rootController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    rootController.view.alpha = 1.0;
    
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:toController.view];
    [containerView sendSubviewToBack:toController.view];
    
    if ([rootController respondsToSelector:@selector(animatedTransitionBeginDismissViewController)]) {
        [rootController animatedTransitionBeginDismissViewController];
    }
    
    CGRect currentImageViewFrameInScreen = CGRectZero;
    UIImageView *currentImageView = nil;
    if ([rootController respondsToSelector:@selector(animatedTransitionDismissViewControllerCurrentImageView)]) {
        currentImageView = [rootController animatedTransitionDismissViewControllerCurrentImageView];
        if (currentImageView) {
            currentImageViewFrameInScreen = [currentImageView convertRect:currentImageView.bounds toView:[UIApplication sharedApplication].delegate.window];
        }
    }
    UIImage *image = currentImageView.image;
    
    UIImageView *imageViewForAnimation = [[UIImageView alloc] initWithFrame:currentImageViewFrameInScreen];
    imageViewForAnimation.contentMode = UIViewContentModeScaleAspectFill;
    imageViewForAnimation.clipsToBounds = YES;
    imageViewForAnimation.image = image;
    [containerView addSubview:imageViewForAnimation];
    
    CGRect finalFrame = CGRectZero;
    if ([rootController respondsToSelector:@selector(animatedTransitionDismissViewControllerTargetView)]) {
        UIImageView *targetImageView = [rootController animatedTransitionDismissViewControllerTargetView];
        if (targetImageView) {
            finalFrame = [targetImageView convertRect:targetImageView.bounds toView:[UIApplication sharedApplication].delegate.window];
        }
    }
    BOOL haveTargetFrame = NO;
    if (!CGRectEqualToRect(finalFrame, CGRectZero)) {
        haveTargetFrame = YES;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        rootController.view.alpha = 0.0;
        imageViewForAnimation.frame = finalFrame;
        if (!haveTargetFrame) {
            imageViewForAnimation.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        [imageViewForAnimation removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
