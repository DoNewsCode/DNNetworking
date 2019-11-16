//
//  DNNetworkStateCenter.h
//  DNNetworking
//
//  Created by 张健康 on 2019/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const DNNetworkAccessibityChangedNotification;

/**
    网络权限
*/
typedef NS_ENUM(NSUInteger, DNNetworkAccessibleStatus) {
    DNNetworkChecking  = 0,
    DNNetworkUnknown     ,
    DNNetworkAccessible  ,
    DNNetworkRestricted  ,
};

typedef void (^NetworkAccessibleStateNotifier)(DNNetworkAccessibleStatus state);

@interface DNNetworkAccessibity : NSObject

/**
 开启 DNNetworkAccessibity
 */
+ (void)start;

/**
 停止 DNNetworkAccessibity
 */
+ (void)stop;

/**
 当判断网络状态为 DNNetworkRestricted 时，提示用户开启网络权限
 */
+ (void)setAlertEnable:(BOOL)setAlertEnable;

/**
  通过 block 方式监控网络权限变化。
 */
+ (void)setStateDidUpdateNotifier:(void (^)(DNNetworkAccessibleStatus))block;

/**
 返回的是最近一次的网络状态检查结果，若距离上一次检测结果短时间内网络授权状态发生变化，该值可能会不准确。
 */
+ (DNNetworkAccessibleStatus)currentState;

@end

//    DUSTBIN
///**
//    网络状态
//*/
//typedef NS_ENUM(NSInteger, DNNetworkReachabilityStatus) {
//    DNNetworkReachabilityStatusUnknown          = -1,
//    DNNetworkReachabilityStatusNotReachable     = 0,
//    DNNetworkReachabilityStatusReachableViaWWAN = 1,
//    DNNetworkReachabilityStatusReachableViaWiFi = 2,
//};
NS_ASSUME_NONNULL_END
