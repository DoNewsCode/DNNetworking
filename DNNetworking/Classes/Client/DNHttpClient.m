//
//  DNHttpClient.m
//  DNNetworkManager
//
//  Created by 张健康 on 2018/12/17.
//  Copyright © 2018 张健康. All rights reserved.
//

#import "DNHttpClient.h"
#import "DNHttpClient+SSL.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "DNNetworkingConfig.h"

#define DoNewsBaseUrl @"https://api.g.com.cn"
#define PLATFORM @"iOS"
#define VERSION_CODE [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

static AFHTTPSessionManager *_sessionManager;

@interface DNHttpClient()

@end
@implementation DNHttpClient
+ (void)load{
    _sessionManager =  [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:DoNewsBaseUrl]];
    // 设置请求的超时时间
    _sessionManager.requestSerializer.timeoutInterval = 15.f;
    // 设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    _sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

+ (void)openTwoWayAuth{
    //    //基于公钥设置客服端安全策略 ssl
    _sessionManager.securityPolicy = [self customSecurityPolicy];
    //
    //    //客服端利用p12验证服务器
    [self checkCredential:_sessionManager];
}

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName
{
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}

/**
 在开发中,如果以下的设置方式不满足项目的需求,就调用此方法获取AFHTTPSessionManager实例进行自定义设置
 */
+ (void)setAFHTTPSessionManagerProperty:(void(^)(AFHTTPSessionManager *sessionManager))sessionManager
{
    sessionManager ? sessionManager(_sessionManager) : nil;
}

/**
 设置请求超时时间:默认为30S
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time
{
    _sessionManager.requestSerializer.timeoutInterval = time;
}

/**
 设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (NSDictionary *)HTTPRequestHeaders{
    return  _sessionManager.requestSerializer.HTTPRequestHeaders;
}

/**
 是否打开网络状态转圈菊花:默认打开
 */
+ (void)openNetworkActivityIndicator:(BOOL)open
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (__kindof NSURLSessionTask *)sendRequestWithURLString:(NSString *)URLString
                                             parameters:(id)parameters
                                                 method:(DNHttpRequestMethod)method
                                                success:(DNHttpRequestSuccess)success
                                                 failed:(DNHttpRequestFailed)failed{
    NSURLSessionDataTask *task;
    switch (method) {
        case DNRequestMethodPost:
            task = [self POST:URLString parameters:parameters success:success failure:failed];
            break;
        case DNRequestMethodGET:
            task = [self GET:URLString parameters:parameters success:success failure:failed];
            break;
        default:
            break;
    }
    return task;
}

+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                           success:(DNHttpRequestSuccess)success
                           failure:(DNHttpRequestFailed)failure
{
    NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return sessionTask;
}

/**
 POST请求
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                            success:(DNHttpRequestSuccess)success
                            failure:(DNHttpRequestFailed)failure
{
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return sessionTask;
}

/**
 上传图片请求
 */

+ (__kindof NSURLSessionTask *)uploadImageWithURL:(NSString *)URL
                                       parameters:(id)parameters
                                             name:(NSString *)name
                                            image:(UIImage *)image
                                         fileName:(NSString *)fileName
                                       imageScale:(CGFloat)imageScale
                                        imageType:(NSString *)imageType
                                         progress:(DNHttpProgress)progress
                                          success:(DNHttpRequestSuccess)success
                                          failure:(DNHttpRequestFailed)failure
{
    imageType = @"jpg";
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 图片经过等比压缩后得到的二进制文件
        NSData *imageData = UIImageJPEGRepresentation(image, imageScale?imageScale: 1.f);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *imageFileName = [NSString stringWithFormat:@"%@.%@",str,imageType];
        NSString *paraName = name;
        [formData appendPartWithFileData:imageData
                                    name:paraName
                                fileName:fileName.length ? [NSString stringWithFormat:@"%@.%@",fileName,imageType] : imageFileName
                                mimeType:[NSString stringWithFormat:@"image/%@",imageType]];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    return sessionTask;
    
}
@end
