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
    NSDictionary *parameters = request.obtainParameters;
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
#import "DNUploadDataRequest.h"

@implementation DNNetworkManager(Upload)

- (void)addUploadRequest:(DNUploadImageRequest *)request{
    NSParameterAssert(request != nil);
    //    if ([self containRequest:request]) {
    //        return;
    //    }
    NSString *completeUrl = DNURL(request.requestUrl);
    
    request.completeUrl = completeUrl;
    
    NSURLSessionUploadTask *task = [DNHttpClient uploadImageWithURL:request.completeUrl
                                                         parameters:request.obtainParameters
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

- (void)addUploadDataRequest:(DNUploadDataRequest *)request {
    NSParameterAssert(request != nil);
    //    if ([self containRequest:request]) {
    //        return;
    //    }
    NSString *completeUrl = DNURL(request.requestUrl);
    
    request.completeUrl = completeUrl;
    
    NSURLSessionUploadTask *task = [DNHttpClient uploadDataWithURL:request.completeUrl parameters:request.obtainParameters data:request.data name:request.parameterName fileName:request.fileName mimeType:request.mimeType progress:^(NSProgress *progress) {
        if ([request respondsToSelector:@selector(uploadingWithProgress:)]) {
                                                   [request uploadingWithProgress:progress];
                                               }
    } success:^(id responseObject) {
        if ([request respondsToSelector:@selector(requestSuccess:)]) {
                                                   [request requestSuccess:responseObject];
                                               }
    } failure:^(NSError *error) {
        [[DNNetworkingConfig sharedConfig].apiConfig registFailedPath:request.requestUrl];
                                               if ([request respondsToSelector:@selector(requestFailed:)]) {
                                                   [request requestFailed:error];
                                               }
    }];
    request.requestTask = task;
    [self addRequestToRecord:request];
}

- (void)cancelUploadRequest:(DNUploadImageRequest *)request {
    NSParameterAssert(request != nil);
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

- (void)cancelUploadDataRequest:(DNUploadDataRequest *)request {
    NSParameterAssert(request != nil);
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

@end
#import "DNDownloadRequest.h"
@implementation DNNetworkManager(Download)
///  Add request to session and start it.
- (void)addDownloadRequest:(DNDownloadRequest *)request{
    NSParameterAssert(request != nil);
    NSString *completeUrl = DNURL(request.requestUrl);

    request.completeUrl = completeUrl;
    
    DNHttpRequestSuccess success = ^(id responseObject) {
        [self removeRequestFromRecord:request];
        [request requestSuccess:responseObject];
    };
    
    DNHttpRequestFailed failure = ^(NSError *error) {
        [self removeRequestFromRecord:request];
        [[DNNetworkingConfig sharedConfig].apiConfig registFailedPath:request.requestUrl];
        [request requestFailed:error];
    };
    
    
    if (request.resumeData && request.resumeData.length) {
        [DNHttpClient downloadWithURL:request.completeUrl fileDir:request.filePath fileName:request.fileName resumeData:request.resumeData progress:request.progressBlock success:success failure:failure];
    }else{
        [DNHttpClient downloadWithURL:request.completeUrl fileDir:request.filePath fileName:request.fileName progress:request.progressBlock success:success failure:failure];
    }
}

///  Cancel a request that was previously added.
- (void)cancelDownloadRequest:(DNDownloadRequest *)request{
    NSParameterAssert(request != nil);
    if (![request.requestTask isKindOfClass:[NSURLSessionDownloadTask class]]) {
        [request.requestTask cancel];
        return;
    }else{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        NSURLSessionDownloadTask *downloadTask = (NSURLSessionDownloadTask *)request.requestTask;
        [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            request.resumeData = resumeData;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

- (void)suspendDownloadRequest:(DNDownloadRequest *)request{
    [request.requestTask suspend];
    
}

- (void)resumeDownloadRequest:(DNDownloadRequest *)request{
    [request.requestTask resume];
}
@end
