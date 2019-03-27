//
//  JDEmialAddressCell.h
//  JDMail
//
//  Created by 千阳 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDEmialAddressCell : UITableViewCell

@property(nonatomic,copy)NSString* title;
@property(nonatomic,readonly,strong)NSArray* recipients;
@property(nonatomic,copy)NSString *subject;

- (void)loadEmailAdress:(NSArray *)recipients;


@end

NS_ASSUME_NONNULL_END
