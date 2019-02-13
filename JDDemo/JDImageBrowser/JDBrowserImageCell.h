//
//  JDBrowserImageCell.h
//  JDDemo
//
//  Created by 宋庆功 on 2018/12/11.
//  Copyright © 2018 京东. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDImageModel;

@interface JDBrowserImageCell : UICollectionViewCell

// 单击
@property (nonatomic, copy) void(^singleClickBlock)(JDImageModel *model);

- (void)reloadWithModel:(JDImageModel *)model;

@end

NS_ASSUME_NONNULL_END
