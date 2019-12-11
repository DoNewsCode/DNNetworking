//
//  DNDownloadRequest.m
//  DNNetworking
//
//  Created by 张健康 on 2019/12/10.
//

#import "DNDownloadRequest.h"
#import <objc/message.h>
#import "YYModel.h"
#import "DNNetworkManager.h"
#import "DNResponse.h"

@implementation DNDownloadRequest

-(void)startWithSuccess:(DNRequestSuccessBlock)success
               progress:(DNRequestProgress)progress
                failure:(DNRequestFailureBlock)failure
{
    NSAssert([self respondsToSelector:@selector(requestUrl)], @"requestUrl is nil");
    NSAssert([self requestUrl], @"requestUrl is nil");
    NSAssert([self requestUrl].length, @"requestUrl is nil");
    
    if (self.inTheRequest) {
        return;
    }
    
    self.progressBlock = progress;
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    
    self.inTheRequest = YES;
    
    [[DNNetworkManager sharedManager] addDownloadRequest:self];
}

- (void)stop{
    [[DNNetworkManager sharedManager] cancelDownloadRequest:self];
}

- (void)requestSuccess:(id)responseObject{
    self.inTheRequest = NO;
    DNResponse *response = [DNResponse responseWithResponseObject:responseObject];
    self.successCompletionBlock(response);
    [self clearCompletionBlock];
}

- (void)requestFailed:(NSError *)error{
    self.inTheRequest = NO;
    self.failureCompletionBlock(error);
    [self clearCompletionBlock];
}

- (void)uploadingWithProgress:(NSProgress *)progress{
    if (self.progressBlock) self.progressBlock(progress);
}

- (void)clearCompletionBlock{
    self.progressBlock = nil;
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    NSArray *blackList;
    if ([DNRequest respondsToSelector:@selector(modelPropertyBlacklist)]) {
        blackList = [DNRequest performSelector:@selector(modelPropertyBlacklist)];
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:blackList];
    [tempArr addObjectsFromArray:@[@"resumeData",@"progressBlock",@"fileDir"]];
    return [NSArray arrayWithArray:tempArr];
}
@end
