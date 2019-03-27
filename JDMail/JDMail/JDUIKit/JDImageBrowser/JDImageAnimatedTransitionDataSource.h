//
//  JDImageAnimatedTransitionDataSource.h
//  JDSafeSpace
//
//  Created by 公司 on 2018/12/21.
//  Copyright © 2018 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JDImageAnimatedTransitionDataSource <NSObject>

- (UIImageView *)animatedTransitionPresentViewControllerTapView;
- (void)animatedTransitionBeginPresentViewController;
- (void)animatedTransitionEndPresentViewController;

- (UIImageView *)animatedTransitionDismissViewControllerCurrentImageView;
- (void)animatedTransitionBeginDismissViewController;
- (UIImageView *)animatedTransitionDismissViewControllerTargetView;

@end

NS_ASSUME_NONNULL_END
