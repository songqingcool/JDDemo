//
//  EmailEditCell.h
//  JDMail
//
//  Created by 千阳 on 2019/2/21.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXCustomNavigationController;
@class HXAlbumListViewController;
@class HXPhotoModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ShowPhotoController)(HXCustomNavigationController *nav);

@interface JDEmailEditCell : UITableViewCell

@property(nonatomic,copy)ShowPhotoController showPhotoController;

@property(nonatomic,copy)void(^contentDivHeight)(CGFloat height);

@property(nonatomic,readonly,copy)NSString *emailContentHtml;

@property(nonatomic,copy)NSString *originalEmailHtml;


- (void)reloadAttachment:(NSArray *)attachments;
@end

NS_ASSUME_NONNULL_END
