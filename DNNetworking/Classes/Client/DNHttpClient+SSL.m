//
//  DNHttpClient+SSL.m
//  DNNetworking
//
//  Created by 张健康 on 2018/12/26.
//
#import "DNHttpClient+SSL.h"
#import "AFNetworking.h"
#import "DNNetworkingConfig.h"
@implementation DNHttpClient (SSL)

+ (AFSecurityPolicy*)customSecurityPolicy {
    
    // AFSSLPinningModeCertificate:需要客户端预先保存服务端的证书(自建证书)
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    NSString * cerPath  = [DNNetworkingConfig sharedConfig].cerFilePath;
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:cerPath]){
        [DNNetworkingConfig sharedConfig].TwoWayAuth = NO;
        NSLog(@"client.cer:not exist");
    }else{
        NSData *certData    = [NSData dataWithContentsOfFile:cerPath];
        NSSet   *dataSet    = [NSSet setWithArray:@[certData]];
        // 自建证书的时候，提供相应的证书
        [securityPolicy setPinnedCertificates:dataSet];
        // 是否允许无效证书(自建证书)
        [securityPolicy setAllowInvalidCertificates:YES];
        // 是否需要验证域名
        [securityPolicy setValidatesDomainName:NO];
    }
    return securityPolicy;
}

/**
 客户端验证服务器信任凭证
 
 @param manager AFURLSessionManager
 */
+ (void)checkCredential:(AFURLSessionManager *)manager
{
    //为了方便测试
    [manager setSessionDidBecomeInvalidBlock:^(NSURLSession * _Nonnull session, NSError * _Nonnull error) {
        NSLog(@"%s error：%@",__FUNCTION__,error);
    }];
    typeof(self) __weak weak_self = self;
    __weak typeof(manager) weakManager = manager;
    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession*session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing*_credential) {
        
        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        __autoreleasing NSURLCredential *credential = nil;
        NSLog(@"authenticationMethod=%@",challenge.protectionSpace.authenticationMethod);
        //判断当前校验的是客户端证书还是服务器证书
        if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            // 客户端的安全策略来决定是否信任该服务器；不信任，则取消请求。
            //接口提示：已取消;是因为客户端设置了需要验证域名
            if([weakManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                // 创建URL凭证
                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                if (credential) {
                    disposition = NSURLSessionAuthChallengeUseCredential;//使用（信任）证书
                } else {
                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;//默认，忽略
                }
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;//取消
            }
        } else {
            
            // client authentication
            SecIdentityRef identity = NULL;
            SecTrustRef trust       = NULL;
            NSString *p12 = [DNNetworkingConfig sharedConfig].p12FilePath;
            NSFileManager *fileManager =[NSFileManager defaultManager];
            
            if(![fileManager fileExistsAtPath:p12]){
                NSLog(@"client.p12:not exist");
            }else{
                
                NSData *PKCS12Data = [NSData dataWithContentsOfFile:p12];
                if ([weak_self extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data]){
                    
                    SecCertificateRef certificate = NULL;
                    SecIdentityCopyCertificate(identity, &certificate);
                    const void*certs[]      = {certificate};
                    CFArrayRef certArray    = CFArrayCreate(kCFAllocatorDefault, certs,1,NULL);
                    credential  = [NSURLCredential credentialWithIdentity:identity certificates:(__bridge  NSArray*)certArray persistence:NSURLCredentialPersistencePermanent];
                    disposition = NSURLSessionAuthChallengeUseCredential;
                }
            }
        }
        *_credential = credential;
        return disposition;
    }];
}

//解读p12文件信息
+ (BOOL)extractIdentity:(SecIdentityRef*)outIdentity andTrust:(SecTrustRef *)outTrust fromPKCS12Data:(NSData *)inPKCS12Data {
    OSStatus securityError = errSecSuccess;
    //client certificate password
    NSString *password = [DNNetworkingConfig sharedConfig].p12FilePassword;
    NSDictionary *optionsDic = [NSDictionary dictionaryWithObject:password
                                                           forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError    = SecPKCS12Import((__bridge CFDataRef)inPKCS12Data,(__bridge CFDictionaryRef)optionsDic,&items);
    
    if(securityError == errSecSuccess) {
        CFDictionaryRef myIdentityAndTrust =CFArrayGetValueAtIndex(items,0);
        const void*tempIdentity = NULL;
        tempIdentity    = CFDictionaryGetValue (myIdentityAndTrust,kSecImportItemIdentity);
        *outIdentity    = (SecIdentityRef)tempIdentity;
        const void*tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust,kSecImportItemTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failedwith error code %d",(int)securityError);
        return NO;
    }
    return YES;
}

@end
