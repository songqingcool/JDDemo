//
//  JDSlipMenu.h
//  JDMail
//
//  Created by 公司 on 2019/1/22.
//  Copyright © 2019 公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDSlipMenu : UIView

@property (nonatomic, strong) NSArray *accountsArray;
@property (nonatomic, strong) NSDictionary *currentAccount;
@property (nonatomic, strong) NSArray *dataArray;

// 点击添加账号
@property (nonatomic, copy) void(^addBlock)(void);
// 点击了设置
@property (nonatomic, copy) void(^settingBlock)(void);
// 点击了某个账号
@property (nonatomic, copy) void(^accountBlock)(NSDictionary *);
// 点击了某个文件夹
@property (nonatomic, copy) void(^folderBlock)(NSDictionary *);

- (void)reloadFolderList:(NSArray *)folderList
         currentFolderId:(NSString *)currentFolderId;

- (void)show;

@end

NS_ASSUME_NONNULL_END
