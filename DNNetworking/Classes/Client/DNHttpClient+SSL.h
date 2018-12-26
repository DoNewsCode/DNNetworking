//
//  DNHttpClient+SSL.h
//  DNNetworking
//
//  Created by 张健康 on 2018/12/26.
//

#import "DNHttpClient.h"

NS_ASSUME_NONNULL_BEGIN
@class AFSecurityPolicy,AFURLSessionManager;

@interface DNHttpClient (SSL)

+ (AFSecurityPolicy*)customSecurityPolicy;

+ (void)checkCredential:(AFURLSessionManager *)manager;
@end

NS_ASSUME_NONNULL_END
