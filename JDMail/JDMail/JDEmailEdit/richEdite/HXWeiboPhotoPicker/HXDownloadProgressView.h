//
//  HXDownloadProgressView.h
//  微博照片选择
//
//  Created by JD on 2017/11/20.
//  Copyright © 2017年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXDownloadProgressView : UIView
@property (nonatomic, assign) CGFloat progress;
- (void)resetState;
- (void)startAnima;
@end
