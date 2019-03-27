//
//  HXDatePhotoViewPresentTransition.h
//  微博照片选择
//
//  Created by JD on 2017/10/28.
//  Copyright © 2017年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    HXDatePhotoViewPresentTransitionTypePresent = 0,
    HXDatePhotoViewPresentTransitionTypeDismiss = 1,
} HXDatePhotoViewPresentTransitionType;
@class HXPhotoView;
@interface HXDatePhotoViewPresentTransition : NSObject<UIViewControllerAnimatedTransitioning>
+ (instancetype)transitionWithTransitionType:(HXDatePhotoViewPresentTransitionType)type photoView:(HXPhotoView *)photoView;

- (instancetype)initWithTransitionType:(HXDatePhotoViewPresentTransitionType)type photoView:(HXPhotoView *)photoView;
@end
