//
//  DNApiConfig.m
//  DoNews
//
//  Created by Ming on 2018/7/12.
//  Copyright © 2018 donews. All rights reserved.
//

#import "DNApiConfig.h"

//#define DNApiConfigVersions @"DNApiConfigVersions"
//#define kVersionPath        @"DNAPIConfigVersionPath"
//
//#define DNApiConfigHosts    @"DNApiConfigHosts"
//#define kNormalHost         @"DNApiConfigTypeNormalHost"//线上地址（勿动）
//#define kSparesHost         @"DNApiConfigTypeSparesHost"//备用地址
//#define kTestHost           @"DNApiConfigTypeTestHost"//测试地址

@interface DNApiConfig ()

@property (nonatomic ,strong) NSMutableSet *failedSet;

@end

@implementation DNApiConfig
#pragma mark - Override Methods

#pragma mark - Intial Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - Public Methods

- (NSString *)getCurrentApi:(NSString *)url{
    if ([self isAbsoluteAddress:url]) return url;
    DNApiConfigType urlType = [self.failedSet containsObject:url]?DNApiConfigTypeSpares:DNApiConfigTypeNormal;
    NSString *host = [self getCurrentHost:urlType];
    NSString *version = (_versionPath && _versionPath.length)?_versionPath:@"";
    return [NSString stringWithFormat:@"%@%@%@",host,version,url];
}

- (void)registFailedPath:(NSString *)url{
    if ([self isAbsoluteAddress:url]) return;
    if ([self.failedSet containsObject:url]) {
        [self.failedSet removeObject:url];
        return;
    }
    [self.failedSet addObject:url];
}

- (void)unregistFailedPath:(NSString *)url{
    if ([self isAbsoluteAddress:url]) return;
    [self.failedSet removeObject:url];
}

- (void)clearFailedSet{
    [self.failedSet removeAllObjects];
}

#pragma mark - Private Methods
- (NSString *)getCurrentHost:(DNApiConfigType)type{
    NSString *returnHost;
    if (self.switchMode == DNApiConfigSwitchModeManual) {
        type = self.manualConfigType;
    }
    switch (type) {
        case DNApiConfigTypeTest:{
            returnHost = _apiTestHost;
        }break;
        case DNApiConfigTypeNormal:{
            returnHost = _apiNormalHost;
            if (!returnHost) {returnHost = _apiSparesHost;}
        }break;
        case DNApiConfigTypeSpares:{
            returnHost = _apiSparesHost;
            if (!returnHost) {returnHost = _apiNormalHost;}
        }break;
        default:break;
    }
    NSAssert(returnHost.length, @"the HOST is empty!!!");
    return returnHost;
}

- (BOOL)isAbsoluteAddress:(NSString *)url{
    NSURL *testUrl = [NSURL URLWithString:url];
    if (testUrl && testUrl.host) {
        return testUrl && testUrl.host;
    }
    return testUrl && testUrl.host;
}

#pragma mark - Setter

- (void)setApiTestHost:(NSString *)apiTestHost{
    while ([apiTestHost hasSuffix:@"/"]) {
        apiTestHost = [apiTestHost substringToIndex:apiTestHost.length-1];
    }
    _apiTestHost = [apiTestHost copy];
}

- (void)setApiNormalHost:(NSString *)apiNormalHost{
    while ([apiNormalHost hasSuffix:@"/"]) {
        apiNormalHost = [apiNormalHost substringToIndex:apiNormalHost.length-1];
    }
    _apiNormalHost = [apiNormalHost copy];
}

- (void)setApiSparesHost:(NSString *)apiSparesHost{
    while ([apiSparesHost hasSuffix:@"/"]) {
        apiSparesHost = [apiSparesHost substringToIndex:apiSparesHost.length-1];
    }
    _apiSparesHost = [apiSparesHost copy];
}

- (void)setVersionPath:(NSString *)versionPath{
    if (!versionPath.length) {
        return;
    }
    if (![versionPath hasPrefix:@"/"]) {
        versionPath = [NSString stringWithFormat:@"/%@",versionPath];
    }
    while ([versionPath hasSuffix:@"/"]) {
        versionPath = [versionPath substringToIndex:versionPath.length-1];
    }
    _versionPath = [versionPath copy];
}
#pragma mark - Getter

- (NSMutableSet *)failedSet{
    if (!_failedSet) {
        _failedSet = [[NSMutableSet alloc] init];
    }
    return _failedSet;
}
@end
