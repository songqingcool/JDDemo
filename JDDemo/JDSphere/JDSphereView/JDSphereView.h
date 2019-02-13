//
//  JDSphereView.h
//  YoungTag
//
//  Created by 宋庆功 on 2018/11/7.
//  Copyright © 2018年 Young. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDSphereView : UIView

- (void)setCloudTags:(NSArray *)array;

/**
 *  Starts the cloud autorotation animation.
 */
- (void)timerStart;

/**
 *  Stops the cloud autorotation animation.
 */
- (void)timerStop;

@end

NS_ASSUME_NONNULL_END
