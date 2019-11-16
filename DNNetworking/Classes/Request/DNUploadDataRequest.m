//
//  DNUploadDataRequest.m
//  DNNetworking
//
//  Created by 陈金铭 on 2019/11/8.
//

#import "DNUploadDataRequest.h"

#import <objc/message.h>
#import "YYModel.h"
#import "DNNetworkManager.h"
#import "DNResponse.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wprotocol"

@implementation DNUploadDataRequest

#pragma clang diagnostic pop

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

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
    
    [[DNNetworkManager sharedManager] addUploadDataRequest:self];
}

- (void)stop{
    [[DNNetworkManager sharedManager] cancelUploadDataRequest:self];
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
    [tempArr addObjectsFromArray:@[@"parameterName",@"progressBlock",@"file",@"imageScale",@"fileName",@"imageType"]];
    return [NSArray arrayWithArray:tempArr];
}

@end
