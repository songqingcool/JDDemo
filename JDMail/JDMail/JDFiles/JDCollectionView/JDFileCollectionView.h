//
//  JDFileCollectionView.h
//  JDMail
//
//  Created by 千阳 on 2019/1/29.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CollectionViewClickMoreAction)(NSArray *modelsArray);

@interface JDFileCollectionView : UICollectionView

@property(nonatomic,assign)BOOL isCollectonViewStyle;

@property(nonatomic,copy)CollectionViewClickMoreAction collectionViewClickMoreAction;

@end

NS_ASSUME_NONNULL_END
