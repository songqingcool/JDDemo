
//
//  JDMailFileManager.m
//  JDMail
//
//  Created by 千阳 on 2019/3/8.
//  Copyright © 2019 公司. All rights reserved.
//

#import "JDMailFileManager.h"


@implementation JDMailFileManager

+ (instancetype)shareManager
{
    static JDMailFileManager *fileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManager = [[JDMailFileManager alloc] init];
    });
    return fileManager;
}

- (NSString *)getFullFilePath:(NSString *)FolderName withFileName:(NSString *)fileName
{
    NSString *fullFilePath = @"";
    NSString * cachesDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *folderFullPath = [cachesDirPath stringByAppendingPathComponent:FolderName];
    BOOL isDir = NO;
    BOOL dirIsExist = [[NSFileManager defaultManager]fileExistsAtPath:folderFullPath isDirectory:&isDir];
    if(!(dirIsExist && isDir))
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderFullPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    fullFilePath = [cachesDirPath stringByAppendingPathComponent:fileName];
    
    return fullFilePath;
}

- (BOOL)writeFileToFile:(NSString *)folderName fileName:(NSString *)fileName withData:(NSData *)data
{
    NSString *filePath = [self getFullFilePath:fileName withFileName:fileName];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if(fileHandle)
    {
        [fileHandle seekToEndOfFile];//跳到最后
        [fileHandle writeData:data];
        [fileHandle closeFile];
        return YES;
    }
    return NO;
    
}

@end
