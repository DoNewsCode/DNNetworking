//
//  DNRequest.h
//  Gravity
//
//  Created by Ming on 2018/9/4.
//  Copyright © 2018 DoNews. All rights reserved.
//  项目中Request的基类（除特殊需求外，项目中所有Request都应继承自此基类）

#import <Foundation/Foundation.h>
#import "DNNetworkingMacro.h"

@class DNResponse;

NS_ASSUME_NONNULL_BEGIN

#define DN_A9VG_Error_Message @"网络错误，请稍后重试"


@protocol DNRequestDelegate

@required
- (NSString *)requestUrl;


@optional
///  Convenience method to start the request with block callbacks.
- (void)startWithSuccess:(nullable DNRequestSuccessBlock)success
                 failure:(nullable DNRequestFailureBlock)failure;

///  Remove self from request queue and cancel the request.
- (void)stop;

@end

@interface DNRequest : NSObject <DNRequestDelegate>

/**
 The success callback. Note if this value is not nil and `requestFinished` delegate method is
 also implemented, both will be executed but delegate method is first called. This block
 will be called on the main queue.
 */
@property (nonatomic, copy, nullable) DNRequestSuccessBlock successCompletionBlock;

/**
 The failure callback. Note if this value is not nil and `requestFailed` delegate method is
 also implemented, both will be executed but delegate method is first called. This block
 will be called on the main queue.
 */
@property (nonatomic, copy, nullable) DNRequestFailureBlock failureCompletionBlock;

/**
 The underlying NSURLSessionTask.
 
 @warning This value is actually nil and should not be accessed before the request starts.
 */
@property (nonatomic, strong) NSURLSessionTask *requestTask;

/**
 
 */
@property (assign, nonatomic) BOOL inTheRequest;

/**
 
 */
@property (assign, nonatomic) DNHttpRequestMethod requestMethod;

/**
 
 */
@property (nonatomic, copy) NSString *completeUrl;


/// 通过重写此方法可完成例如sign认证等接口配置
- (NSDictionary *)parametersDictionary;


/// 获取请求参数此方法会调用 parametersDictionary 以获取请求参数并存放，每次请求（startWithSuccess:failure:）会重新调用parametersDictionary并更新存放
- (NSDictionary *)obtainParameters;

- (void)clearCompletionBlock;

- (void)requestSuccess:(id)responseObject;

- (void)requestFailed:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
