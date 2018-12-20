//
//  DNNetworkingConfig.m
//  AFNetworking
//
//  Created by 张健康 on 2018/12/19.
//

#import "DNNetworkingConfig.h"
#import "DNNetworkingPrivate.h"
#import "DNApiConfig.h"
#import "DNNetworkManager.h"
@implementation DNNetworkingConfig
//单例对象
static DNNetworkingConfig *_instance = nil;
//单例
+ (instancetype)sharedConfig
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.apiConfig = [[DNApiConfig alloc] init];
    }
    return self;
}

- (void)registFailedPath:(NSString *)url{
    [self.apiConfig registFailedPath:url];
}

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

- (void)setSwitchMode:(DNApiConfigSwitchMode)switchMode{
    [DNNetworkingConfig sharedConfig].apiConfig.switchMode = switchMode;
}

- (void)setManualConfigType:(DNApiConfigType)manualConfigType{
    [DNNetworkingConfig sharedConfig].apiConfig.manualConfigType = manualConfigType;
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

- (DNApiConfigType)manualConfigType{
    return [DNNetworkingConfig sharedConfig].apiConfig.manualConfigType;
}

- (DNApiConfigSwitchMode)switchMode{
    return [DNNetworkingConfig sharedConfig].apiConfig.switchMode;
}

- (void)setHeaderDictionary:(NSDictionary *)headerDictionary{
    [headerDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] &&
            [obj isKindOfClass:[NSString class]]) {
            [[DNNetworkManager sharedManager] setValue:obj forHTTPHeaderField:key];
        }
    }];
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field{
    [[DNNetworkManager sharedManager] setValue:value forHTTPHeaderField:field];
}

- (NSDictionary *)headerDictionary{
    return [DNNetworkManager sharedManager].HTTPRequestHeaders;
}
@end


