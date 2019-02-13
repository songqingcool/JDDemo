//
//  JDRotationHalfView.h
//  JDDemo
//
//  Created by 宋庆功 on 2018/12/3.
//  Copyright © 2018 京东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDRotationHalfView : UIView

// 被点击
@property (nonatomic, copy) void(^clickBlock)(NSDictionary *);

- (void)reloadWithModelList:(NSArray *)list;

@end

NS_ASSUME_NONNULL_END
