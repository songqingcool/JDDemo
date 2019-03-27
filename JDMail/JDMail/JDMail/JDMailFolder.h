//
//  JDMailFolder.h
//  JDMail
//
//  Created by 千阳 on 2019/3/14.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMailFolder : NSObject

@property (nonatomic, copy) NSString *folderId;
@property (nonatomic, copy) NSString *changeKey;
@property (nonatomic, copy) NSString *parentFolderId;
@property (nonatomic, copy) NSString *parentChangeKey;
@property (nonatomic, copy) NSString *folderClass;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *totalCount;
@property (nonatomic, copy) NSString *childFolderCount;
@property (nonatomic, copy) NSString *unreadCount;

@end

NS_ASSUME_NONNULL_END
