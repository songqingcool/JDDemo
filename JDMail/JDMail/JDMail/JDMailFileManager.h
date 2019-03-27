//
//  JDMailFileManager.h
//  JDMail
//
//  Created by 千阳 on 2019/3/8.
//  Copyright © 2019 公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FilePath(FolderName)

NS_ASSUME_NONNULL_BEGIN

@interface JDMailFileManager : NSObject

+ (instancetype)shareManager;

- (NSString *)getFullFilePath:(NSString *)FolderName withFileName:(NSString *)fileName;

- (BOOL)writeFileToFile:(NSString *)folderName fileName:(NSString *)fileName withData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
