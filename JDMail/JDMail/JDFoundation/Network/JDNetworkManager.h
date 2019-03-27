//
//  JDNetworkManager.h
//  JDMail
//
//  Created by 公司 on 2019/1/31.
//  Copyright © 2019年 公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface JDNetworkManager : NSObject

/**
 *  单例方法
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager;

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
                            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

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
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

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
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

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
                                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

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
                          failure:(void (^)(NSURLSessionDownloadTask *task, NSError *error))failure;

#pragma mark -  soap网络请求

// 账号密码改动或者新登录账号时需要重新注册
- (void)registerSoapManagerWithAccount:(NSString *)account
                              userName:(NSString *)userName
                              password:(NSString *)password;

- (void)unregisterSoapManagerWithAccount:(NSString *)account;

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
                                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

