//
//  JDFileItemSelectCell.h
//  JDMail
//
//  Created by 千阳 on 2019/1/29.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VerticalLayout = 1,
    HorizontalLayout = 2,
} CellLayoutType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^FileItemClickMore)(NSDictionary *modelDic);

@interface JDFileItemSelectCell : UICollectionViewCell

@property(nonatomic,assign)CellLayoutType cellLayoutType;
@property(nonatomic,copy)FileItemClickMore fileItemClickMore;

- (void)reloadModelData:(NSDictionary *)modelDic;

@end

NS_ASSUME_NONNULL_END
