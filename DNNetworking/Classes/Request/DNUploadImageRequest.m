//
//  DNUploadImageRequest.m
//  DNNetworking
//
//  Created by 张健康 on 2019/1/23.
//

#import "DNUploadImageRequest.h"
#import <objc/message.h>
#import "YYModel.h"
#import "DNNetworkManager.h"
#import "DNResponse.h"

@interface DNUploadImageRequest()

@property (copy, nonatomic) NSString *app_id;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wprotocol"
@implementation DNUploadImageRequest
#pragma clang diagnostic pop

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageScale = 1.f;
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
    
    [[DNNetworkManager sharedManager] addUploadRequest:self];
}

- (void)stop{
    [[DNNetworkManager sharedManager] cancelUploadRequest:self];
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
    if ([super respondsToSelector:@selector(modelPropertyBlacklist)]) {
        blackList = [super performSelector:@selector(modelPropertyBlacklist)];
    }
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:blackList];
    [tempArr addObjectsFromArray:@[@"parameterName",@"progressBlock",@"file",@"imageScale",@"fileName",@"imageType"]];
    return [NSArray arrayWithArray:tempArr];
}

@end
