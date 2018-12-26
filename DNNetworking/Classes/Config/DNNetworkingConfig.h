//
//  DNNetworkingConfig.h
//  AFNetworking
//
//  Created by 张健康 on 2018/12/19.
//

#import <Foundation/Foundation.h>
#import "DNNetworkingMacro.h"
NS_ASSUME_NONNULL_BEGIN

@interface DNNetworkingConfig : NSObject

+ (instancetype)sharedConfig;

#pragma mark - api配置相关项

/**
 app服务器地址
 */
@property (nonatomic, copy)  NSString * _Nullable apiNormalHost;

/**
 备用服务器地址，接口请求失败时，下次调用时启动
 */
@property (nonatomic, copy)  NSString * _Nullable apiSparesHost;

/**
 测试用服务器地址
 */
@property (nonatomic, copy)  NSString * _Nullable apiTestHost;

/**
 版本path，可空
 */
@property (nonatomic, copy)  NSString * _Nullable apiVersionPath;

/**
 切换模式，默认为自动切换
 自动模式：启用normalHost与sparesHost，失败时Host切换
 手动模式：固定使用manualConfigType
 */
@property (nonatomic, assign) DNApiConfigSwitchMode switchMode;

/**
 手动模式固定host
 switchMode为1时，所有api调用为此host
 */
@property (nonatomic, assign) DNApiConfigType manualConfigType;


#pragma mark - request配置相关项
/**
 request配置相关项
 */
@property (nonatomic, strong) NSDictionary *headerDictionary;
/**
 设置请求头
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

#pragma mark - response配置相关项
/**
 response解析，data字段名
 */
@property (nonatomic, copy) NSString *responseDataKey;
/**
 response解析，code字段名
 */
@property (nonatomic, copy) NSString *responseCodeKey;
/**
 response解析，msg字段名
 */
@property (nonatomic, copy) NSString *responseMsgKey;
/**
 response解析，请求成功码
 */
@property (nonatomic, strong) NSNumber *responseSuccessCode;
/**
 response解析，异地登录错误码
 */
@property (nonatomic, strong) NSNumber *responseExpiredode;
/**
 response解析，异地登录错误回调
 */
@property (nonatomic, copy) dispatch_block_t expiredBlock;

#pragma mark - 证书配置相关项

/**
 是否需要双向https认证
 */
@property (nonatomic, assign)  BOOL TwoWayAuth;
/**
 需要双向https认证时cer证书路径
 */
@property (nonatomic, copy)  NSString * cerFilePath;

/**
 需要双向https认证时p12证书路径
 */
@property (nonatomic, copy)  NSString * p12FilePath;

/**
 需要双向https认证时p12证书密码
 */
@property (nonatomic, copy)  NSString * p12FilePassword;
@end
NS_ASSUME_NONNULL_END
