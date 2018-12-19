//
//  DNNetworkingPrivate.h
//  AFNetworking
//
//  Created by 张健康 on 2018/12/19.
//

#import <Foundation/Foundation.h>
#import "DNNetworkingConfig.h"
#import "DNApiConfig.h"

@interface DNNetworkingConfig()

@property (nonatomic, strong) DNApiConfig *apiConfig;

@end

@interface DNNetworkingConfig (apiConfig)

@property (nonatomic, copy, readwrite) NSString *apiNormalHost;

@property (nonatomic, copy, readwrite) NSString *apiSparesHost;

@property (nonatomic, copy, readwrite) NSString *apiTestHost;

@property (nonatomic, copy, readwrite) NSString *apiVersionPath;

@end

@interface DNNetworkingConfig (responseConfig)

@property (nonatomic, copy, readwrite) NSString *responseDataKey;

@property (nonatomic, copy, readwrite) NSString *responseCodeKey;

@property (nonatomic, copy, readwrite) NSString *responseMsgKey;

@property (nonatomic, copy, readwrite) NSNumber *responseSuccessCode;

@property (nonatomic, copy, readwrite) NSNumber *responseExpiredode;

@end
