//
//  JDNetworkManager.m
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import "JDNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "NSDictionary+Extend.h"

@interface JDNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFHTTPSessionManager *uploadManager;
@property (nonatomic, strong) AFHTTPSessionManager *downloadManager;

@property (nonatomic, strong) NSMutableDictionary *managerDict;

@end

@implementation JDNetworkManager

#pragma mark - shareManager
/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager {
    static JDNetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 普通网络请求
        self.manager = [AFHTTPSessionManager manager];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.requestSerializer.timeoutInterval = 20.0;
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/text",@"application/json",@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil]];
        dispatch_queue_t queue = dispatch_queue_create("com.jd.hio.networking.completionqueue", DISPATCH_QUEUE_CONCURRENT);
        self.manager.completionQueue = queue;
        // 上传
        self.uploadManager = [AFHTTPSessionManager manager];
        self.uploadManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.uploadManager.requestSerializer.timeoutInterval = 20.0;
        self.uploadManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.uploadManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/text",@"application/json",@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil]];
        dispatch_queue_t uploadQueue = dispatch_queue_create("com.jd.hio.networking.uploadcompletionqueue", DISPATCH_QUEUE_CONCURRENT);
        self.uploadManager.completionQueue = uploadQueue;
        // 下载
        self.downloadManager = [AFHTTPSessionManager manager];
        self.downloadManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.downloadManager.requestSerializer.timeoutInterval = 20.0;
        self.downloadManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [self.downloadManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/text",@"application/json",@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil]];
        dispatch_queue_t downloadQueue = dispatch_queue_create("com.jd.hio.networking.downloadcompletionqueue", DISPATCH_QUEUE_CONCURRENT);
        self.downloadManager.completionQueue = downloadQueue;
    }
    return self;
}

#pragma mark - GET/POST请求
/**
 登录POST请求方法

 @param URLString 请求地址
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 @return 请求Task
 */
- (NSURLSessionDataTask *)loginPOST:(NSString *)URLString
                         parameters:(NSDictionary *)parameters
                            success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDict setValuesForKeysWithDictionary:parameters];
    [paramDict setValue:@"iOS" forKey:@"platform"];
    NSLog(@"%@请求参数\n%@😄",URLString,paramDict);
    NSURLSessionDataTask *postTask = [self.manager POST:URLString parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *object = (NSDictionary *)responseObject;
        NSLog(@"%@请求成功\n%@",task.originalRequest.URL,object);
        NSInteger code = [object jd_integerForKey:@"code"];
        NSString *message = [object jd_stringForKey:@"msg"];
        if (code == 1) {
            if (success) {
                success(task, object);
            }
        }else {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
            [userInfo setValue:@(code) forKey:@"code"];
            [userInfo setValue:message forKey:@"msg"];
            NSError *error = [NSError errorWithDomain:@"JD-MAM-Domain-Error" code:code userInfo:userInfo];
            if (failure) {
                failure(task, error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@请求失败\n%@",task.originalRequest.URL,error);
        if (failure) {
            failure(task, error);
        }
    }];
    return postTask;
}

/**
 GET请求方法
 
 @param URLString 请求地址
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 @return 请求Task
 */
- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSURLSessionDataTask *task = [self.manager GET:URLString parameters:parameters progress:nil success:success failure:failure];
    return task;
}

/**
 POST请求方法
 
 @param URLString 请求地址
 @param parameters 请求参数
 @param success 成功回调
 @param failure 失败回调
 @return 请求Task
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDict setValuesForKeysWithDictionary:parameters];
    NSLog(@"%@请求参数\n%@😄",URLString,paramDict);
    NSURLSessionDataTask *postTask = [self.manager POST:URLString parameters:paramDict progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultObject = (NSDictionary *)responseObject;
        NSLog(@"%@请求成功\n%@😄",task.originalRequest.URL,resultObject);
        NSInteger code = [resultObject jd_integerForKey:@"code"];
        NSString *message = [resultObject jd_stringForKey:@"msg"];
        if (code == 1) {
            if (success) {
                success(task, resultObject);
            }
        }else {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
            [userInfo setValue:@(code) forKey:@"code"];
            [userInfo setValue:message forKey:@"msg"];
            NSError *error = [NSError errorWithDomain:@"JD-MAM-Domain-Error" code:code userInfo:userInfo];
            if (failure) {
                failure(task, error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@请求失败\n%@😄",task.originalRequest.URL,error);
        if (failure) {
            failure(task, error);
        }
    }];
    return postTask;
}

#pragma mark - 上传文件请求
/**
 POST请求方法
 
 @param URLString 请求地址
 @param parameters 请求参数
 @param data 上传的data
 @param success 成功回调
 @param failure 失败回调
 @return 请求Task
 */
- (NSURLSessionDataTask *)uploadDataPOST:(NSString *)URLString
                              parameters:(NSDictionary *)parameters
                                    data:(NSData *)data
                                 success:(void (^)(NSURLSessionDataTask *task, NSDictionary *responseObject))success
                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDict setValuesForKeysWithDictionary:parameters];
    NSLog(@"%@请求参数\n%@😄",URLString,paramDict);
    NSURLSessionDataTask *postTask = [self.uploadManager POST:URLString parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultObject = (NSDictionary *)responseObject;
        NSLog(@"%@请求成功\n%@",task.originalRequest.URL,resultObject);
        NSInteger code = [resultObject jd_integerForKey:@"code"];
        NSString *message = [resultObject jd_stringForKey:@"msg"];
        if (code == 1) {
            if (success) {
                success(task, resultObject);
            }
        }else {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
            [userInfo setValue:@(code) forKey:@"code"];
            [userInfo setValue:message forKey:@"msg"];
            NSError *error = [NSError errorWithDomain:@"JD-MAM-Domain-Error" code:code userInfo:userInfo];
            if (failure) {
                failure(task, error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@请求失败\n%@",task.originalRequest.URL,error);
        if (failure) {
            failure(task, error);
        }
    }];
    return postTask;
}

#pragma mark - 文件下载
/**
 *  文件下载
 *
 *  @param URLString    请求的url
 *  @param savePath     下载文件保存路径
 *  @param progress     下载文件的进度显示
 *  @param success      下载文件成功的回调
 *  @param failure      下载文件失败的回调
 */
- (void)downloadFileWithURLString:(NSString *)URLString
                         savaPath:(NSURL *)savePath
                         progress:(void (^)(CGFloat progress))progress
                          success:(void (^)(NSURLSessionDownloadTask *task, NSURL *filePath))success
                          failure:(void (^)(NSURLSessionDownloadTask *task, NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    __block NSURLSessionDownloadTask *downloadTask = [self.downloadManager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        progress(1.00 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return savePath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            if (failure) {
                failure(downloadTask, error);
            }
        } else {
            if (success) {
                success(downloadTask, filePath);
            }
        }
    }];
    [downloadTask resume];
}

#pragma mark -  soap网络请求

- (NSMutableDictionary *)managerDict
{
    if (!_managerDict) {
        _managerDict = [NSMutableDictionary dictionary];
    }
    return _managerDict;
}

- (void)registerSoapManagerWithAccount:(NSString *)account
                              userName:(NSString *)userName
                              password:(NSString *)password
{
    if (!account) {
        return;
    }
    
    AFHTTPSessionManager *manager = [self.managerDict objectForKey:account];
    if (!manager) {
        // soap请求
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20.0;
        [manager.requestSerializer setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
            return [parameters objectForKey:@"message"];
        }];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *queueLabel = [NSString stringWithFormat:@"com.jd.hio.networking.soapcompletionqueue_%@",account];
        dispatch_queue_t soapQueue = dispatch_queue_create([queueLabel cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_CONCURRENT);
        manager.completionQueue = soapQueue;
        [self.managerDict setValue:manager forKey:account];
    }
    // 更新账号密码
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *credential) {
        NSLog(@"开始认证...");
        NSString *authMethod = [[challenge protectionSpace] authenticationMethod];
        NSLog(@"%@认证...",authMethod);
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([challenge previousFailureCount] == 0) {
                *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                return NSURLSessionAuthChallengeUseCredential;
            }else{
                *credential = nil;
                return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        }
        
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodNTLM]) {
            if ([challenge previousFailureCount] == 0) {
                *credential = [NSURLCredential credentialWithUser:userName password:password persistence:NSURLCredentialPersistenceForSession];
                [[challenge sender] useCredential:*credential forAuthenticationChallenge:challenge];
                return NSURLSessionAuthChallengeUseCredential;
            }else{
                *credential = nil;
                return NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        }
        NSLog(@"认证结束...");
        *credential = nil;
        return NSURLSessionAuthChallengePerformDefaultHandling;
    }];
}

- (void)unregisterSoapManagerWithAccount:(NSString *)account
{
    [self.managerDict removeObjectForKey:account];
}

/**
 POST请求方法
 
 @param httpBodyString 请求参数
 @param success 成功回调
 @param failure 失败回调
 @return 请求Task
 */
- (NSURLSessionDataTask *)POSTWithAccount:(NSString *)account
                           httpBodyString:(NSString *)httpBodyString
                                  success:(void (^)(NSURLSessionDataTask *task, NSData *responseObject))success
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    if (!account.length || !httpBodyString.length) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (failure) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:@"account或者httpBodyString为空" forKey:@"msg"];
                NSError *error = [NSError errorWithDomain:@"JD-Mail-Domain-Error" code:999 userInfo:userInfo];
                failure(nil, error);
            }
        });
        return nil;
    }
    
    AFHTTPSessionManager *soapManager = [self.managerDict objectForKey:account];
    if (!soapManager) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (failure) {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:@"找不到soapManager出错" forKey:@"msg"];
                NSError *error = [NSError errorWithDomain:@"JD-Mail-Domain-Error" code:999 userInfo:userInfo];
                failure(nil, error);
            }
        });
        return nil;
    }
    
    NSLog(@"%@😂soap请求参数\n%@😄",@"https://mail.jd.com/EWS/exchange.asmx",httpBodyString);
    NSURLSessionDataTask *postTask = [soapManager POST:@"https://mail.jd.com/EWS/exchange.asmx" parameters:@{@"message":httpBodyString} progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSData *resultObject = (NSData *)responseObject;
        NSLog(@"%@😂soap请求成功\n%@😄",task.originalRequest.URL,[[NSString alloc] initWithData:resultObject encoding:NSUTF8StringEncoding]);
        if (success) {
            success(task, resultObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@😂soap请求失败\n%@😄",task.originalRequest.URL,error);
        if (failure) {
            failure(task, error);
        }
    }];
    return postTask;
}

@end
