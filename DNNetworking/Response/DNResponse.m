//
//  DNResponse.m
//  A9VG
//
//  Created by 张健康 on 2018/9/18.
//  Copyright © 2018年 DoNews. All rights reserved.
//

#import "DNResponse.h"
#import <YYModel.h>

#define SUCCESS_CODE @200
#define SUCCESS_RESPONSE_CODE @1000
#define APP_LOGIN_EXPIRED_CODE @(410)

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
        self.code = self.responseObject[@"code"];
        self.rspcode=self.responseObject[@"rspcode"];
        self.errormsg=self.responseObject[@"errormsg"];
        self.msg = self.responseObject[@"msg"];
        self.data=self.responseObject[@"data"];
    } @catch (NSException *exception) {
        self.rspcode = @(1001);
        self.errormsg = @"处理数据失败";
        self.data = @{};
    } @finally {

    }

}

//-(void)setDownloadResponseObject:(id)responseObject{
//
//    _responseObject=responseObject;
//    NSHTTPURLResponse *httpResponse = responseObject;
//    @try {
//        self.rspcode=[NSString stringWithFormat:@"%ld",httpResponse.statusCode];
//        NSString *timeStr = httpResponse.allHeaderFields[@"Date"];
//        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//        fmt.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss ZZZ";
//        // fmt.dateFormat = @"EEE MMM dd HH:mm:ss ZZZZ yyyy";
//        // 设置语言区域(因为这种时间是欧美常用时间)
//        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//        NSDate *date = [fmt dateFromString:timeStr];
//        NSTimeInterval timestamp = [date timeIntervalSince1970];
//        self.timestamp =  [NSString stringWithFormat:@"%f",timestamp];
//    } @catch (NSException *exception) {
//        self.rspcode = @800001;
//        self.errormsg = @"处理数据失败";
//        self.data = @{};
//    } @finally {
//    }
//
//}

+(id)responseWithResponseObject:(id)responseObject{

    DNResponse *response=[[DNResponse alloc] init];
  
    response.responseObject = responseObject;

    BOOL isSuccess = [response.code isEqualToNumber:SUCCESS_CODE] || [response.rspcode isEqualToNumber:SUCCESS_RESPONSE_CODE];
    response.failed = !isSuccess;

    return response;
}

-(void)setrspcode:(NSNumber *)rspcode{
    _rspcode = rspcode;
}

- (void)setCode:(NSNumber *)code{
    _code = code;
//    if ([code isEqualToNumber:APP_LOGIN_EXPIRED_CODE]) {
//        [DNAppLogin loginExpired];
//    }
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
