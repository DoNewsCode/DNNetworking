//
//  DNNetworkingPrivate.m
//  AFNetworking
//
//  Created by 张健康 on 2018/12/19.
//

#import "DNNetworkingPrivate.h"
#import "DNApiConfig.h"
@implementation DNNetworkingConfig(apiConfig)

- (void)setApiNormalHost:(NSString *)apiNormalHost{
    [DNNetworkingConfig sharedConfig].apiConfig.apiNormalHost = apiNormalHost;
}

- (void)setApiSparesHost:(NSString *)apiSparesHost{
    [DNNetworkingConfig sharedConfig].apiConfig.apiSparesHost = apiSparesHost;
}

- (void)setApiTestHost:(NSString *)apiTestHost{
    [DNNetworkingConfig sharedConfig].apiConfig.apiTestHost = apiTestHost;
}

- (void)setApiVersionPath:(NSString *)apiVersionPath{
    [DNNetworkingConfig sharedConfig].apiConfig.versionPath = apiVersionPath;
}

- (NSString *)apiNormalHost{
    return [DNNetworkingConfig sharedConfig].apiConfig.apiNormalHost;
}

- (NSString *)apiSparesHost{
    return [DNNetworkingConfig sharedConfig].apiConfig.apiSparesHost;
}

- (NSString *)apiTestHost{
    return [DNNetworkingConfig sharedConfig].apiConfig.apiTestHost;
}

- (NSString *)apiVersionPath{
    return [DNNetworkingConfig sharedConfig].apiConfig.versionPath;
}
@end

@implementation DNNetworkingConfig(responseConfig)

@end
