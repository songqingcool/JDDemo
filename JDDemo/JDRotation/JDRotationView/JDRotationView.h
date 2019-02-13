//
//  JDRotationView.h
//  JDDemo
//
//  Created by 宋庆功 on 2018/11/28.
//  Copyright © 2018 京东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDRotationView : UIView

// 中间按钮
@property (nonatomic, strong) NSDictionary *centerModel;
// 被点击
@property (nonatomic, copy) void(^clickBlock)(NSDictionary *);

- (void)reloadWithModelList:(NSArray *)list;

@end

NS_ASSUME_NONNULL_END
