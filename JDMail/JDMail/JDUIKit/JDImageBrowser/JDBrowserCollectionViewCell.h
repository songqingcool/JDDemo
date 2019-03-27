//
//  JDBrowserCollectionViewCell.h
//  JDSafeSpace
//
//  Created by 公司 on 2018/12/21.
//  Copyright © 2018 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDImageSourceModel;

@interface JDBrowserCollectionViewCell : UICollectionViewCell

// 单击点击
@property (nonatomic, copy) void(^tapClickBlock)(JDImageSourceModel *);

- (void)reloadWithModel:(JDImageSourceModel *)model;

- (UIImageView *)currentImageView;

@end

NS_ASSUME_NONNULL_END
