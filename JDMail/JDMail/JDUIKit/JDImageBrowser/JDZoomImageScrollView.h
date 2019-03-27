//
//  JDZoomImageScrollView.h
//  JDSafeSpace
//
//  Created by 公司 on 2018/12/21.
//  Copyright © 2018 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDZoomImageScrollView : UIScrollView

// 单击点击
@property (nonatomic, copy) void(^tapClickBlock)(void);

- (void)setImageUrl:(NSString *)imageUrl placeHolder:(UIImage *)placeHolderImage;

- (UIImageView *)zoomImageView;

@end

NS_ASSUME_NONNULL_END
