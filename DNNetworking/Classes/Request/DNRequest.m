//
//  DNRequest.m
//  Gravity
//
//  Created by Ming on 2018/9/4.
//  Copyright © 2018 DoNews. All rights reserved.
//

#import "DNRequest.h"
#import <objc/message.h>
#import "YYModel.h"
#import "DNNetworkManager.h"
#import "DNResponse.h"

@interface DNRequest()

@property (copy, nonatomic) NSString *app_id;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wprotocol"
@implementation DNRequest
#pragma clang diagnostic pop

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

///  Convenience method to start the request with block callbacks.
- (void)startWithSuccess:(nullable DNRequestSuccessBlock)success
                 failure:(nullable DNRequestFailureBlock)failure{
    
    NSAssert([self respondsToSelector:@selector(requestUrl)], @"requestUrl is nil");
    NSAssert([self requestUrl], @"requestUrl is nil");
    NSAssert([self requestUrl].length, @"requestUrl is nil");
    
    if (self.inTheRequest) {
        return;
    }
    
    self.successCompletionBlock = success;
    
    self.failureCompletionBlock = failure;
    
    self.inTheRequest = YES;
    
    [[DNNetworkManager sharedManager] addRequest:self];
}

- (void)stop{
    [[DNNetworkManager sharedManager] cancelRequest:self];
}

- (void)requestSuccess:(id)responseObject{
    self.inTheRequest = NO;
    DNResponse *response = [DNResponse responseWithResponseObject:responseObject];
    if (self.successCompletionBlock) {
        self.successCompletionBlock(response);
    }
    [self clearCompletionBlock];
}

- (void)requestFailed:(NSError *)error{
    self.inTheRequest = NO;
    if (self.failureCompletionBlock) {
        self.failureCompletionBlock(error);
    }
    [self clearCompletionBlock];
}

- (void)clearCompletionBlock{
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
    return @[@"requestMethod",@"requestUrl",@"inTheRequest",@"completeUrl",@"successCompletionBlock",@"failureCompletionBlock",@"requestTask"];
}

- (NSDictionary *)parametersDictionary {
    return [self yy_modelToJSONObject];
}

@end
