//
//  JDImageBrowserController.h
//  JDSafeSpace
//
//  Created by 公司 on 2018/12/21.
//  Copyright © 2018 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDImageSourceModel;

@interface JDImageBrowserController : UIViewController

// 当前展示图片index
@property (nonatomic) NSInteger currentIndex;
// 
@property (nonatomic, strong) UIImageView *tapImageView;
//
@property (nonatomic, strong) NSArray<JDImageSourceModel *> *dataArray;
//
@property (nonatomic, copy) UIImageView *(^dismissTargetViewBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
