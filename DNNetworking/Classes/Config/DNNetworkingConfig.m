//
//  DNNetworkingConfig.m
//  AFNetworking
//
//  Created by 张健康 on 2018/12/19.
//

#import "DNNetworkingConfig.h"
#import "DNNetworkingPrivate.h"
#import "DNApiConfig.h"

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

@end


