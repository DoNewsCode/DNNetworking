//
//  DNNetworkManager.h
//  DNNetworkManager
//
//  Created by 张健康 on 2018/12/17.
//  Copyright © 2018 张健康. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNRequest.h"
NS_ASSUME_NONNULL_BEGIN

@class DNUploadImageRequest,DNUploadDataRequest;

@interface DNNetworkManager : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedManager;

///  Add request to session and start it.
- (void)addRequest:(DNRequest *)request;

///  Cancel a request that was previously added.
- (void)cancelRequest:(DNRequest *)request;

///  Cancel all requests that were previously added.
- (void)cancelAllRequests;

/// 设置请求头
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/// 请求头字典
- (NSDictionary *)HTTPRequestHeaders;

@end

@interface DNNetworkManager (Upload)

///  Add request to session and start it.
- (void)addUploadRequest:(DNUploadImageRequest *)request;

- (void)addUploadDataRequest:(DNUploadDataRequest *)request;

///  Cancel a request that was previously added.
- (void)cancelUploadRequest:(DNUploadImageRequest *)request;

- (void)cancelUploadDataRequest:(DNUploadDataRequest *)request;

@end

NS_ASSUME_NONNULL_END
