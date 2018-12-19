//
//  DNNetworkingConfig.h
//  AFNetworking
//
//  Created by 张健康 on 2018/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNNetworkingConfig : NSObject

+ (instancetype)sharedConfig;
/**
 API配置相关
 */
@property (nonatomic, copy, readonly) NSString *apiNormalHost;

@property (nonatomic, copy, readonly) NSString *apiSparesHost;

@property (nonatomic, copy, readonly) NSString *apiTestHost;

@property (nonatomic, copy, readonly) NSString *apiVersionPath;

- (void)registFailedPath:(NSString *)url;
/**
 response配置相关，配置responseKey
 */
@property (nonatomic, copy, readonly) NSString *responseDataKey;

@property (nonatomic, copy, readonly) NSString *responseCodeKey;

@property (nonatomic, copy, readonly) NSString *responseMsgKey;

@property (nonatomic, strong, readonly) NSNumber *responseSuccessCode;

@property (nonatomic, strong, readonly) NSNumber *responseExpiredode;

@property (nonatomic, copy, readonly) dispatch_block_t expiredBlock;
@end
NS_ASSUME_NONNULL_END
