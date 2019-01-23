//
//  DNNetworkManager.m
//  DNNetworkManager
//
//  Created by 张健康 on 2018/12/17.
//  Copyright © 2018 张健康. All rights reserved.
//

#import "DNNetworkManager.h"
#import <pthread/pthread.h>
#import "DNHttpClient.h"
#import "DNNetworkingConfig.h"
#import "DNResponse.h"
#import "DNNetworkingPrivate.h"
#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@interface DNNetworkManager(){
    NSMutableDictionary<NSNumber *, DNRequest *> *_requestsRecord;
    pthread_mutex_t _lock;
}

@end

@implementation DNNetworkManager


+ (instancetype)sharedManager
{
    static DNNetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestsRecord = [NSMutableDictionary dictionary];
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (void)addRequest:(DNRequest *)request{
    NSParameterAssert(request != nil);
    if ([self containRequest:request]) {
        return;
    }
    NSString *completeUrl = DNURL(request.requestUrl);
    NSDictionary *parameters = request.parametersDictionary;
    DNHttpRequestMethod method = request.requestMethod;
    
    request.completeUrl = completeUrl;
    
    NSURLSessionTask *task = [DNHttpClient sendRequestWithURLString:completeUrl
                                                         parameters:parameters
                                                             method:method
                                                            success:^(id responseObject) {
                                                                [self removeRequestFromRecord:request];
                                                                [request requestSuccess:responseObject];
                                                            } failed:^(NSError *error) {
                                                                [self removeRequestFromRecord:request];
                                                                [[DNNetworkingConfig sharedConfig].apiConfig registFailedPath:request.requestUrl];
                                                                [request requestFailed:error];
                                                            }];
    request.requestTask = task;
    [self addRequestToRecord:request];
}

- (void)cancelRequest:(DNRequest *)request{
    NSParameterAssert(request != nil);
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    Lock();
    NSArray *allKeys = [_requestsRecord allKeys];
    Unlock();
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            Lock();
            DNRequest *request = _requestsRecord[key];
            Unlock();
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            [request stop];
        }
    }
}

/**
 设置请求头
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field{
    [DNHttpClient setValue:value forHTTPHeaderField:field];
}
/**
 请求头字典
 */
- (NSDictionary *)HTTPRequestHeaders{
    return DNHttpClient.HTTPRequestHeaders;
}

- (BOOL)containRequest:(DNRequest *)request{
    Lock();
    NSArray *allKeys = [_requestsRecord allKeys];
    Unlock();
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            Lock();
            DNRequest *recordRequest = _requestsRecord[key];
            Unlock();
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            if ([recordRequest isEqual:request]){
                return YES;
            }
        }
    }
    return NO;
}

- (void)addRequestToRecord:(DNRequest *)request {
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRecord:(DNRequest *)request {
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    NSLog(@"Request queue size = %zd", [_requestsRecord count]);
    Unlock();
}


@end

#import "DNUploadImageRequest.h"

@implementation DNNetworkManager(Upload)

- (void)addUploadRequest:(DNUploadImageRequest *)request{
    NSParameterAssert(request != nil);
    //    if ([self containRequest:request]) {
    //        return;
    //    }
    NSString *completeUrl = DNURL(request.requestUrl);
    
    request.completeUrl = completeUrl;
    
    NSURLSessionUploadTask *task = [DNHttpClient uploadImageWithURL:request.completeUrl
                                                         parameters:request.parametersDictionary
                                                               name:request.parameterName
                                                              image:request.file
                                                           fileName:request.fileName
                                                         imageScale:request.imageScale
                                                          imageType:nil
                                                           progress:^(NSProgress *progress)
                                    {
                                        if ([request respondsToSelector:@selector(uploadingWithProgress:)]) {
                                            [request uploadingWithProgress:progress];
                                        }
                                    } success:^(id responseObject) {
                                        //        [self removeRequestFromRecord:request];
                                        if ([request respondsToSelector:@selector(requestSuccess:)]) {
                                            [request requestSuccess:responseObject];
                                        }
                                    } failure:^(NSError *error) {
                                        //        [self removeRequestFromRecord:request];
                                        [[DNNetworkingConfig sharedConfig].apiConfig registFailedPath:request.requestUrl];
                                        if ([request respondsToSelector:@selector(requestFailed:)]) {
                                            [request requestFailed:error];
                                        }
                                    }];
    request.requestTask = task;
    [self addRequestToRecord:request];
}

- (void)cancelUploadRequest:(DNUploadImageRequest *)request{
    NSParameterAssert(request != nil);
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}
@end
