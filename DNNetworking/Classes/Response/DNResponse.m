//
//  DNResponse.m
//  A9VG
//
//  Created by 张健康 on 2018/9/18.
//  Copyright © 2018年 DoNews. All rights reserved.
//

#import "DNResponse.h"
#import "YYModel.h"
#import "DNNetworkingConfig.h"

@interface DNResponse()
@property(nonatomic, copy, readwrite) NSNumber *code;//响应码

@property(nonatomic, copy, readwrite) NSNumber *rspcode;//响应码

@property(nonatomic, copy, readwrite) NSString *msg;//响应信息

@property(nonatomic, copy, readwrite) NSString *errormsg;//响应信息

@property(nonatomic, strong, readwrite)NSDictionary *data;//响应数据

@property(nonatomic, copy, readwrite) NSString *timestamp;//服务端时间戳

@property(nonatomic, strong, readwrite) id responseObject;//原始json对象

@property(nonatomic, assign, getter=isFailed,readwrite) BOOL failed;

@end

@implementation DNResponse
-(BOOL)isDataNull {
    return self.data == nil || [self.data isEqual:[NSNull null]];
}

-(void)setResponseObject:(id)responseObject{

    _responseObject=responseObject;

    @try {
        self.code = self.responseObject[[DNNetworkingConfig sharedConfig].responseCodeKey];
        self.rspcode=self.responseObject[[DNNetworkingConfig sharedConfig].responseCodeKey];
        self.errormsg=self.responseObject[[DNNetworkingConfig sharedConfig].responseMsgKey];
        self.msg = self.responseObject[[DNNetworkingConfig sharedConfig].responseMsgKey];
        self.data=self.responseObject[[DNNetworkingConfig sharedConfig].responseDataKey];
    } @catch (NSException *exception) {
        self.rspcode = @(1001);
        self.errormsg = @"处理数据失败";
        self.data = @{};
    } @finally {

    }

}

+(id)responseWithResponseObject:(id)responseObject{

    DNResponse *response=[[DNResponse alloc] init];
  
    response.responseObject = responseObject;

    BOOL isSuccess =
    [response.code isEqualToNumber:[DNNetworkingConfig sharedConfig].responseSuccessCode] ||
    [response.rspcode isEqualToNumber:[DNNetworkingConfig sharedConfig].responseSuccessCode];
    
    response.failed = !isSuccess;

    return response;
}

-(void)setrspcode:(NSNumber *)rspcode{
    _rspcode = rspcode;
}

- (void)setCode:(NSNumber *)code{
    _code = code;
    if ([code isEqualToNumber:[DNNetworkingConfig sharedConfig].responseExpiredode]) {
        if ([DNNetworkingConfig sharedConfig].expiredBlock) {
            [DNNetworkingConfig sharedConfig].expiredBlock();
        }
    }
}

-(NSArray *)getListWithClass:(Class)clazz{
    @try {
        if(self.isDataNull) {
            return @[];
        }
        return [NSArray yy_modelArrayWithClass:clazz json:self.data];
    } @catch (NSException *e) {
        return @[];
    }
}

-(NSArray *)getListWithKey:(NSString *)key class:(Class)clazz{
    @try {
        if(self.isDataNull) {
            return @[];
        }
        NSArray *array;
        if (key == nil || [key isEqualToString:@""] || [key isEqualToString:@" "]) {
            array = [NSArray yy_modelArrayWithClass:clazz json:self.data];
        } else {
            array = [NSArray yy_modelArrayWithClass:clazz json:self.data[key]];
        }
        return array;
    } @catch (NSException *e) {
        return @[];
    }
}


-(id)getObjectWithClass:(Class)clazz{
    if(self.isDataNull) {
        return nil;
    }
    return [clazz yy_modelWithDictionary:self.data];
}

-(id)getObjectWithClass:(Class)clazz key:(NSString *)key{
    if(self.isDataNull) {
        return nil;
    }
    return [NSDictionary yy_modelDictionaryWithClass:clazz json:self.data[key]];
}


-(NSString *)description{
    return [NSString stringWithFormat:@" rspcode: %@\n resMsg: %@\n data: %@\n",self.rspcode,self.errormsg,self.data];
}


@end
