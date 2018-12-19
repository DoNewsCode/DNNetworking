//
//  DNNetworkingMacro.h
//  DNNetworking
//
//  Created by 张健康 on 2018/12/18.
//  Copyright © 2018 Donews. All rights reserved.
//

#ifndef DNNetworkingMacro_h
#define DNNetworkingMacro_h

@class DNResponse;

typedef NS_ENUM(NSInteger, DNHttpRequestMethod) {
    DNRequestMethodPost = 0,
    DNRequestMethodGET,
};

typedef void(^DNRequestSuccessBlock)(DNResponse *response);

typedef void(^DNRequestFailureBlock)(NSError *error);

typedef NS_ENUM(NSUInteger, DNNetworkStatusType) {
    /** 未知网络*/
    DNNetworkStatusUnknown,
    /** 无网络*/
    DNNetworkStatusNotReachable,
    /** 手机网络*/
    DNNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    DNNetworkStatusReachableViaWiFi
};

typedef NS_ENUM(NSUInteger, DNRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    DNRequestSerializerJSON,
    /** 设置请求数据为二进制格式*/
    DNRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, DNResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    DNResponseSerializerJSON,
    /** 设置响应数据为二进制格式*/
    DNResponseSerializerHTTP,
};

/** 请求成功的Block */
typedef void(^DNHttpRequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^DNHttpRequestFailed)(NSError *error);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^DNHttpProgress)(NSProgress *progress);

/** 网络状态的Block*/
typedef void(^DNNetworkStatus)(DNNetworkStatusType status);

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
#endif /* DNNetworkingMacro_h */
