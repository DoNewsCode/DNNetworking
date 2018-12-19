//
//  DNApiConfig.m
//  DoNews
//
//  Created by Ming on 2018/7/12.
//  Copyright © 2018 donews. All rights reserved.
//

#import "DNApiConfig.h"

#define DNApiConfigVersions @"DNApiConfigVersions"
#define kVersionPath        @"DNAPIConfigVersionPath"

#define DNApiConfigHosts    @"DNApiConfigHosts"
#define kNormalHost         @"DNApiConfigTypeNormalHost"//线上地址（勿动）
#define kSparesHost         @"DNApiConfigTypeSparesHost"//备用地址
#define kTestHost           @"DNApiConfigTypeTestHost"//测试地址

@interface DNApiConfig (){
    NSDictionary *_hostsDict;
    NSString *_versionPath;
}
@property (nonatomic ,strong) NSMutableSet *failedSet;
@end

@implementation DNApiConfig
#pragma mark - Override Methods

#pragma mark - Intial Methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *dict = [self readApiConfigFile];
        _hostsDict = dict[DNApiConfigHosts];
        NSDictionary *versDict = dict[DNApiConfigVersions];
        _versionPath = versDict[kVersionPath];
    }
    return self;
}
#pragma mark - Public Methods

- (void)resetVersionPath:(NSString *)versionPath{
    if (!versionPath.length) {
        return;
    }
    if ([versionPath hasPrefix:@"/"]) {
        versionPath = [NSString stringWithFormat:@"/%@",versionPath];
    }
    if ([versionPath hasSuffix:@"/"]) {
        versionPath = [versionPath substringWithRange:NSMakeRange(0, versionPath.length-1)];
    }
    _versionPath = [versionPath copy];
}

- (NSString *)getCurrentApi:(NSString *)url{
    if ([self isAbsoluteAddress:url]) return url;
    DNApiConfigType urlType = [self.failedSet containsObject:url]?DNApiConfigTypeSpares:DNApiConfigTypeNormal;
    return [NSString stringWithFormat:@"%@%@%@",[self getCurrentHost:urlType],_versionPath,url];
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
        case DNApiConfigTypeTest:
            returnHost = _hostsDict[kTestHost];  break;
        case DNApiConfigTypeNormal:
            returnHost = _hostsDict[kNormalHost];break;
        case DNApiConfigTypeSpares:
            returnHost = _hostsDict[kSparesHost];break;
        default:break;
    }
    return returnHost;
}

- (BOOL)isAbsoluteAddress:(NSString *)url{
    NSURL *testUrl = [NSURL URLWithString:url];
    if (testUrl && testUrl.host) {
        return testUrl && testUrl.host;
    }
    return testUrl && testUrl.host;
}

// 读取本地JSON文件
- (NSDictionary *)readApiConfigFile{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DNApiConfig" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

#pragma mark - Setter

#pragma mark - Getter

- (NSMutableSet *)failedSet{
    if (!_failedSet) {
        _failedSet = [[NSMutableSet alloc] init];
    }
    return _failedSet;
}
@end
