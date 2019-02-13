//
//  JD3DPoint.h
//  YoungTag
//
//  Created by 宋庆功 on 2018/11/7.
//  Copyright © 2018年 Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface JD3DPoint : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat z;

- (JD3DPoint *)makeRotationWithDirection:(JD3DPoint *)direction angle:(CGFloat)angle;

@end

NS_ASSUME_NONNULL_END
