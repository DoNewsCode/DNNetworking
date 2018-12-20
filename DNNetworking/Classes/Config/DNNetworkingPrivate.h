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
#define DNURL(urlstring) [[DNNetworkingConfig sharedConfig].apiConfig getCurrentApi:urlstring]
@property (nonatomic, strong) DNApiConfig *apiConfig;

@end
