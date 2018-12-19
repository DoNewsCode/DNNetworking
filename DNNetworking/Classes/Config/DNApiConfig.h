//
//  DNApiConfig.h
//  DoNews
//
//  Created by Ming on 2018/7/12.
//  Copyright © 2018 donews. All rights reserved.
//  Api配置管理

#import "DNNetworkingMacro.h"

//#define DNAPI(urlString) [[DNApiConfig sharedInstance] getCurrentApi:urlString]

@interface DNApiConfig : NSObject

@property (nonatomic, assign) DNApiConfigSwitchMode switchMode;

@property (nonatomic, assign) DNApiConfigType manualConfigType;

@property (nonatomic, copy) NSString *apiNormalHost;

@property (nonatomic, copy) NSString *apiSparesHost;

@property (nonatomic, copy) NSString *apiTestHost;

@property (nonatomic, copy) NSString *versionPath;

- (NSString *)getCurrentApi:(NSString *)url;

- (void)registFailedPath:(NSString *)url;

- (void)unregistFailedPath:(NSString *)url;

- (void)clearFailedSet;

@end
