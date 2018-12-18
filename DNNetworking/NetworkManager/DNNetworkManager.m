//
//  DNNetworkManager.m
//  DNNetworkManager
//
//  Created by 张健康 on 2018/12/17.
//  Copyright © 2018 张健康. All rights reserved.
//

#import "DNNetworkManager.h"
#import <pthread/pthread.h>
#import <YYModel.h>
#import <objc/message.h>

#import "DNHttpClient.h"
#import "DNApiConfig.h"
#import "DNResponse.h"

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

@interface DNNetworkManager(){
    NSMutableDictionary<NSNumber *, DNBaseRequest *> *_requestsRecord;
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

- (void)addRequest:(DNBaseRequest *)request{
    NSParameterAssert(request != nil);
    if ([self containRequest:request]) {
        return;
    }
    [DNHttpClient sendRequestWithURLString:request.completeUrl
                                parameters:request.parametersDictionary method:request.requestMethod
                                   success:^(id responseObject) {
                                       [self removeRequestFromRecord:request];
                                       [request requestSuccess:responseObject];
    } failed:^(NSError *error) {
        [self removeRequestFromRecord:request];
        [request requestFailed:error];
    }];
}

- (void)cancelRequest:(DNBaseRequest *)request{
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
            DNBaseRequest *request = _requestsRecord[key];
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
- (BOOL)containRequest:(DNBaseRequest *)request{
    __block BOOL contain = false;
    [_requestsRecord enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, DNBaseRequest * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj == request) {
            contain = true;
            *stop = YES;
        }
    }];
    return contain;
}

- (void)addRequestToRecord:(DNBaseRequest *)request {
    Lock();
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
}

- (void)removeRequestFromRecord:(DNBaseRequest *)request {
    Lock();
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    NSLog(@"Request queue size = %zd", [_requestsRecord count]);
    Unlock();
}


@end
