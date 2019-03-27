//
//  UIButton+HXExtension.h
//  微博照片选择
//
//  Created by JD on 17/2/16.
//  Copyright © 2017年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (HXExtension)
/**  扩大buuton点击范围  */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end
