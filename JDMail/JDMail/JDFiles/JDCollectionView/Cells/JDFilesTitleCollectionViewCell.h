//
//  JDFilesTitleCollectionViewCell.h
//  JDMail
//
//  Created by 千阳 on 2019/1/28.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TypeClick)(NSInteger index);

@interface JDFilesTitleCollectionViewCell : UICollectionViewCell;

@property(nonatomic,copy)TypeClick typeClick;

@property(nonatomic,strong)UIButton *titleButton;

- (void)reloadModelData:(NSDictionary *)modelDic;

@end

NS_ASSUME_NONNULL_END
