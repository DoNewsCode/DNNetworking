//
//  DNNetworkManager.h
//  DNNetworkManager
//
//  Created by 张健康 on 2018/12/17.
//  Copyright © 2018 张健康. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface DNNetworkManager : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedManager;

///  Add request to session and start it.
- (void)addRequest:(DNBaseRequest *)request;

///  Cancel a request that was previously added.
- (void)cancelRequest:(DNBaseRequest *)request;

///  Cancel all requests that were previously added.
- (void)cancelAllRequests;

/**
 设置请求头
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
@end

NS_ASSUME_NONNULL_END
