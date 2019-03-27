//
//  UIControl+KWButtonExtension.m
//  KaiWen
//
//  Created by JD on 2018/1/5.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "UIControl+KWButtonExtension.h"
#import <objc/runtime.h>

@implementation UIControl (KWButtonExtension)

static const char* orderTagBy ="orderTagBy";
- (void)setOrderTag:(NSString *)orderTag{
        objc_setAssociatedObject(self, orderTagBy, orderTag, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)orderTag{
    return objc_getAssociatedObject(self, orderTagBy);
}

@end
