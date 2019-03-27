//
//  UIView+Frame.h
//  JDMail
//
//  Created by 千阳 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

@end

NS_ASSUME_NONNULL_END
