//
//  DNUploadDataRequest.h
//  DNNetworking
//
//  Created by 陈金铭 on 2019/11/8.
//

#import "DNRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DNUploadDataDelegate <DNRequestDelegate>
@optional
- (void)startWithSuccess:(DNRequestSuccessBlock)success
               progress:(DNRequestProgress)progress
                failure:(DNRequestFailureBlock)failure;

///  Remove self from request queue and cancel the request.
- (void)stop;

///  Convenience method to start the request with block callbacks.
- (void)startWithSuccess:(nullable DNRequestSuccessBlock)success
                 failure:(nullable DNRequestFailureBlock)failure NS_UNAVAILABLE;
@end

@interface DNUploadDataRequest : DNRequest<DNUploadDataDelegate>


/// 上传进度回调
@property (nonatomic, copy, nullable) DNHttpProgress progressBlock;

/// 上传图片
@property (nonatomic, strong, nullable) NSData *data;
/// 上传文件时文件在body的key
@property (nonatomic, copy, nullable) NSString *parameterName;

/// 上传文件名
@property (nonatomic, copy, nullable) NSString *fileName;

/// mimeType
@property (nonatomic, copy, nullable) NSString *mimeType;


- (void)uploadingWithProgress:(NSProgress *)progress;


@end

NS_ASSUME_NONNULL_END
