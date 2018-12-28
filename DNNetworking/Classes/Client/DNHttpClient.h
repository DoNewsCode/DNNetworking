//
//  DNHttpClient.h
//  DNNetworkManager
//
//  Created by 张健康 on 2018/12/17.
//  Copyright © 2018 张健康. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNNetworkingMacro.h"

@class AFHTTPSessionManager;

@interface DNHttpClient : NSObject

/**
 开启双向验证
 */
+ (void)openTwoWayAuth;

/**
 *  普通HTTP请求
 *
 *  @param URLString  请求URL的path部分，HOST会在内部拼接固定参数
 *  @param parameters 请求参数
 *  @param method     请求方法
 *  @param success    成功后的回调
 *  @param failed     失败后的回调
 *
 */
+ (__kindof NSURLSessionDataTask *)sendRequestWithURLString:(NSString *)URLString
                                                 parameters:(id)parameters
                                                     method:(DNHttpRequestMethod)method
                                                    success:(DNHttpRequestSuccess)success
                                                     failed:(DNHttpRequestFailed)failed;

+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(id)parameters
                            success:(DNHttpRequestSuccess)success
                            failure:(DNHttpRequestFailed)failure;

+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(id)parameters
                           success:(DNHttpRequestSuccess)success
                           failure:(DNHttpRequestFailed)failure;

/**
 设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;


/**
 请求头字典
 */
+ (NSDictionary *)HTTPRequestHeaders;

/**
 在开发中,如果以下的设置方式不满足项目的需求,就调用此方法获取AFHTTPSessionManager实例进行自定义设置
 (注意: 调用此方法时在要导入AFNetworking.h头文件,否则可能会报找不到AFHTTPSessionManager的❌)
 @param sessionManager AFHTTPSessionManager的实例
 */
+ (void)setAFHTTPSessionManagerProperty:(void(^)(AFHTTPSessionManager *sessionManager))sessionManager;

///**
// 设置网络请求参数的格式:默认为二进制格式
// @param requestSerializer MMRequestSerializerJSON(JSON格式),MMRequestSerializerHTTP(二进制格式),
// */
//+ (void)setRequestSerializer:(MMRequestSerializer)requestSerializer;

///**
// 设置服务器响应数据格式:默认为JSON格式
// @param responseSerializer MMResponseSerializerJSON(JSON格式),MMResponseSerializerHTTP(二进制格式)
// */
//+ (void)setResponseSerializer:(MMResponseSerializer)responseSerializer;

/**
 设置请求超时时间:默认为15S
 @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 是否打开网络状态转圈菊花:默认打开
 @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/**
 配置自建证书的Https请求, 参考链接: http://blog.csdn.net/syg90178aw/article/details/52839103
 
 @param cerPath 自建Https证书的路径
 @param validatesDomainName 是否需要验证域名，默认为YES. 如果证书的域名与请求的域名不一致，需设置为NO; 即服务器使用其他可信任机构颁发
 的证书，也可以建立连接，这个非常危险, 建议打开.validatesDomainName=NO, 主要用于这种情况:客户端请求的是子域名, 而证书上的是另外
 一个域名。因为SSL证书上的域名是独立的,假如证书上注册的域名是www.google.com, 那么mail.google.com是无法验证通过的.
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;
@end
