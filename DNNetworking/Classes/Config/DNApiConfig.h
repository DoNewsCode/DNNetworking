//
//  DNApiConfig.h
//  DoNews
//
//  Created by Ming on 2018/7/12.
//  Copyright © 2018 donews. All rights reserved.
//  Api配置管理

#import <Foundation/Foundation.h>

#define DNAPI(urlString) [[DNApiConfig sharedInstance] getCurrentApi:urlString]
 
//Api环境
typedef NS_ENUM(NSInteger, DNApiConfigType) {
    DNApiConfigTypeTest,  //测试环境
    DNApiConfigTypeNormal,  //正式环境
    DNApiConfigTypeSpares, //备用环境
};

//Api环境切换方式
typedef NS_ENUM(NSInteger, DNApiConfigSwitchMode) {
    DNApiConfigSwitchModeAuto,   //自动切换
    DNApiConfigSwitchModeManual  //手动切换
};

#pragma mark - Api环境切换（）
//当前Api切换方式（手动模式下Api环境可通过DNApiConfigCurrentType进行控制，自动模式下DNApiManualConfigType的设置无效）

static DNApiConfigSwitchMode DNApiConfigCurrentSwitchMode  = DNApiConfigSwitchModeManual;

static DNApiConfigType       DNApiManualConfigType         = DNApiConfigTypeTest;

@interface DNApiConfig : NSObject

+ (instancetype)sharedInstance;

- (void)resetVersionPath:(NSString *)versionPath;

- (NSString *)getCurrentApi:(NSString *)url;

- (void)registFailedPath:(NSString *)url;

- (void)unregistFailedPath:(NSString *)url;

- (void)clearFailedSet;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;


@end
