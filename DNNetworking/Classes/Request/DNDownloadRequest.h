//
//  DNDownloadRequest.h
//  DNNetworking
//
//  Created by 张健康 on 2019/12/10.
//

#import "DNRequest.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DNUDownloadDelegate <DNRequestDelegate>
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
@interface DNDownloadRequest : DNRequest <DNUDownloadDelegate>
/// 上传进度回调
@property (nonatomic, copy, nullable) DNHttpProgress progressBlock;

/// 断点续传data，如果有值则默认开启断点续传
/// stop任务后，resumeData也会放在此字段下
/// 需自己保存到本地，需要断点续传时，把数据取出并赋值在此字段下start
@property (nonatomic, copy, nullable) NSData *resumeData;

/// 下载文件夹
@property (nonatomic, copy, nullable) NSString *filePath;

/// 下载文件名
@property (nonatomic, copy, nullable) NSString *fileName;

- (void)uploadingWithProgress:(NSProgress *)progress;

@end

NS_ASSUME_NONNULL_END
