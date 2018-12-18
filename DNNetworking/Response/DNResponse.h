//
//  DNResponse.h
//  A9VG
//
//  Created by 张健康 on 2018/9/18.
//  Copyright © 2018年 DoNews. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNResponse : NSObject

@property(nonatomic, copy, readonly) NSNumber *code;//响应码

@property(nonatomic, copy, readonly) NSNumber *rspcode;//响应码

@property(nonatomic, copy, readonly) NSString *msg;//响应信息

@property(nonatomic, copy, readonly) NSString *errormsg;//响应信息

@property(nonatomic, strong, readonly) id data;//响应数据

@property(nonatomic, copy, readonly) NSString *timestamp;//服务端时间戳

@property(nonatomic, strong, readonly) id responseObject;//原始json对象

@property(nonatomic, assign, getter=isFailed, readonly) BOOL failed;

+(id)responseWithResponseObject:(id)responseObject;

-(NSArray *)getListWithClass:(Class)clazz;

-(NSArray *)getListWithKey:(NSString *) key class:(Class) clazz;//获取集合

-(id)getObjectWithClass:(Class) clazz;//获取对象

-(id)getObjectWithClass:(Class) clazz  key:(NSString *)key;//获取对象

-(BOOL)isDataNull;
@end
