//
//  DNUploadImageRequest.h
//  AFNetworking
//
//  Created by 张健康 on 2019/1/23.
//
#import "DNRequest.h"
NS_ASSUME_NONNULL_BEGIN
@protocol DNUploadImageDelegate <DNRequestDelegate>
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

@interface DNUploadImageRequest : DNRequest <DNUploadImageDelegate>

/**
 上传文件时文件在body的key
 */
@property (nonatomic, copy, nullable) NSString *parameterName;

/**
 上传进度回调
 */
@property (nonatomic, copy, nullable) DNHttpProgress progressBlock;

/**
 上传图片
 */
@property (nonatomic, strong, nullable) UIImage *file;

/**
 图片缩放比例（默认为1.f）
 */
@property (nonatomic, assign) CGFloat imageScale;

/**
 上传图片名
 */
@property (nonatomic, copy, nullable) NSString *fileName;

- (void)uploadingWithProgress:(NSProgress *)progress;

@end

NS_ASSUME_NONNULL_END
