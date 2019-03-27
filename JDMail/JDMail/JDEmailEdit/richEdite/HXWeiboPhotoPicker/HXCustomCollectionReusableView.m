//
//  HXCustomCollectionReusableView.m
//  微博照片选择
//
//  Created by JD on 2017/11/8.
//  Copyright © 2017年 JD. All rights reserved.
//

#import "HXCustomCollectionReusableView.h"

#ifdef __IPHONE_11_0
@implementation HXCustomLayer

- (CGFloat)zPosition {
    return 0;
}

@end
#endif

@implementation HXCustomCollectionReusableView
#ifdef __IPHONE_11_0
+ (Class)layerClass {
    return [HXCustomLayer class];
}
#endif
@end
