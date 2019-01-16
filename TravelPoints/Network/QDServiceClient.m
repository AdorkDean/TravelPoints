//
//  QDServiceClient.m
//  QDINFI
//
//  Created by 冉金 on 2017/10/21.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#import "QDServiceClient.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworkActivityIndicatorManager.h"
#import "WXApi.h"
#import "QDResponseObject.h"
#import "QDServiceErrorHandler.h"
#import "QDNetworkCache.h"



//请求成功的block
typedef void(^PrivateRequestSuccess)(NSURLSessionDataTask *task, QDResponseObject *responseObject);
//请求失败的block
typedef void(^PrivateRequestFailure)(NSURLSessionDataTask *task, NSError *error);


@interface QDServiceClient ()


@property (nonatomic, strong)NSMutableArray *tasks;                         //管理请求数组
@end

@implementation QDServiceClient

+ (instancetype)shareClient
{
    static QDServiceClient *serviceClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceClient = [[QDServiceClient alloc] init];
        serviceClient.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        serviceClient.manager.securityPolicy.allowInvalidCertificates = YES;
        serviceClient.tasks = [[NSMutableArray alloc] init];
    });
    return serviceClient;
}

+ (void) startMonitoringNetworking
{
    AFNetworkReachabilityManager *statusManager = [AFNetworkReachabilityManager sharedManager];
    [statusManager startMonitoring];
    [statusManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                QDToast(@"网络状态位置错误");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                QDToast(@"当前网络不可用");

            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
//                QDToast(@"当前网络为3/4G状态");

            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
//                QDToast(@"当前网络环境为WI-FI");

            }
                break;
            default:
                break;
        }
    }];
}

- (NSString *)getFullUrlByUrl:(NSString *)urlString
{
    if (urlString == nil) {
        return [NSString stringWithFormat:@"%@%@", QD_Domain, QD_ProjectName];
    }
    else {
        return [NSString stringWithFormat:@"%@%@%@", QD_Domain, QD_ProjectName, urlString];
    }
}

/**
 网络请求
 
 @param serviceName 服务名
 @param funcName 方法名
 @param paraments 参数
 @param successBlock 成功block
 @param failureBlock 失败block
 @param progressBlock 进度
 */
- (void)requestWithServiceName:(NSString *)serviceName functionName:(NSString *)funcName paraments:(NSArray *)paraments successBlock:(RequestSuccess)successBlock failureBlock:(RequestFailure)failureBlock progress:(DownloadProgress)progressBlock
{
    NSString *urlString = [self getFullUrlByUrl:[NSString stringWithFormat:@"%@%@/%@",QD_Service, serviceName, funcName]];
    
    [self requestWithType:kHTTPRequestTypePOST urlString:urlString params:paraments success:^(NSURLSessionDataTask *task, QDResponseObject *responseObject) {
        successBlock ? successBlock(responseObject) : nil;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock ? failureBlock(error) : nil;
    } progress:^(NSProgress *progress) {
        progressBlock ? progressBlock(progress) : nil;
    } isCached:NO];
}


- (void)requestWithServiceName:(NSString *)serviceName functionName:(NSString *)funcName paraments:(NSArray *)paraments successBlock:(RequestSuccess)successBlock failureBlock:(RequestFailure)failureBlock progress:(DownloadProgress)progressBlock isCached:(BOOL)isCached
{
    NSString *urlString = [self getFullUrlByUrl:[NSString stringWithFormat:@"%@%@/%@",QD_Service, serviceName, funcName]];
    [self requestWithType:kHTTPRequestTypePOST urlString:urlString params:paraments success:^(NSURLSessionDataTask *task, QDResponseObject *responseObject) {
        successBlock ? successBlock(responseObject) : nil;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock ? failureBlock(error) : nil;
    } progress:^(NSProgress *progress) {
        progressBlock ? progressBlock(progress) : nil;
    } isCached:isCached];
}

/**
 用户登录
 
 @param userName 用户名
 @param password 密码
 @param successBlock 成功block
 @param failureBlock 失败block
 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password successBlock:(RequestSuccess)successBlock failureBlock:(RequestFailure)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userName forKey:@"legalPhone"];
    [params setValue:[self getMD5String:password] forKey:@"userPwd"];
    NSData *dataFromDict = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *logonUrl = [self getFullUrlByUrl:api_Login];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:logonUrl parameters:nil error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:dataFromDict];
    __block NSURLSessionDataTask *task = [_manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            successBlock ? successBlock(responseObject):nil;
        }else{
            QDResponseObject *responseObj = [QDResponseObject yy_modelWithDictionary:responseObject];
            successBlock ? successBlock(responseObj):nil;
        }
    }];
    [task resume];

    //移除cookie
//    [QDUserDefaults removeCookies];
    
    
//    [self requestWithType:kHTTPRequestTypePOST urlString:logonUrl params:params2 success:^(NSURLSessionDataTask *task, QDResponseObject *responseObject) {
//        //把服务端返回的cookie存起来
//
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//        NSString *cookie = response.allHeaderFields[@"Set-Cookie"];
//        if (cookie) {
//            [QDUserDefaults setCookies:cookie];
//        }
//        successBlock ? successBlock(responseObject) : nil;
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failureBlock ? failureBlock(error) : nil;
//    } progress:^(NSProgress *progress) {
//    } isCached:NO];
}

- (void)logoutSuccessBlock:(RequestSuccess)successBlock failureBlock:(RequestFailure)failureBlock
{
    NSString *logoutUrl = [self getFullUrlByUrl:api_LogoutService];
    [self requestWithType:kHTTPRequestTypePOST urlString:logoutUrl params:nil success:^(NSURLSessionDataTask *task, QDResponseObject *responseObject) {
        //删除cookie
//        [WXUserDefault removeCookies];
        successBlock ? successBlock(responseObject) : nil;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureBlock ? failureBlock(error) : nil;
    } progress:^(NSProgress *progress) {
        
    } isCached:NO];
}


- (NSString *)getVerifyCodeImgUrlString
{
    NSDate *date = [NSDate date];
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    NSLog(@"url:%@", [self getFullUrlByUrl:[NSString stringWithFormat:@"%@%f", api_GetVerifyCode, timeStamp]]);
    return [self getFullUrlByUrl:[NSString stringWithFormat:@"%@%f", api_GetVerifyCode, timeStamp]];
}


- (void)uploadImageWithType:(NSString *)uploadType withImage:(UIImage *)image withServiceName:(NSString *)service withFunctionName:(NSString *)funcName withSuccessBlock:(RequestSuccess)successBlock withFailurBlock:(RequestFailure)failureBlock withUpLoadProgress:(UploadProgress)progress
{
    //image to data
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    //get uploadUrl
    NSString *uploadUrlString = [self getUploadUrlWithServiceName:service functionName:funcName type:uploadType];
//    [self.manager POST:uploadUrlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        //set fileName with current time
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSDate *today = [NSDate date];
//        NSString *fileName = [formatter stringFromDate:today];
//        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        progress ? progress(uploadProgress) : nil;
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSInteger errorCode = 200;
//        @try {
//            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//            NSDictionary *allHeaders = response.allHeaderFields;
//            NSNumber *code = [allHeaders objectForKey:@"error_code"];
//            if (code != nil) {
//                errorCode = [code integerValue];
//            }
//        } @catch (NSException *exception) {
//
//        } @finally {
//
//        }
//        if (errorCode == 200) {
//            QDResponseObject *responseObj = [QDResponseObject yy_modelWithDictionary:responseObject];
//            if ([responseObj.data[@"resultFlag"]integerValue] == 1 && responseObj.data[@"path"] != nil) {
//                successBlock ? successBlock(responseObj) : nil;
//            }
//            else {
//                QDToast(@"上传图片失败，请重试或重新登录");
//            }
//        }
//        else {
//            [QDServiceErrorHandler handleError:errorCode];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}


/**
 文件下载
 
 @param operations 文件下载预留参数
 @param savePath 下载文件保存路径
 @param urlString 请求的URL
 @param successBlock 请求成功的block
 @param failureBlock 请求失败的block
 @param progress 下载文件的进度
 */
- (void)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString withSuccessBlock:(RequestSuccess)successBlock withFailureBlock:(RequestFailure)failureBlock withDownLoadProgress:(DownloadProgress)progress
{
    
}


/**
 取消所有网络请求
 */
- (void)cancelAllRequest
{
    [self.manager.operationQueue cancelAllOperations];
}


/**
 取消指定URL请求
 
 @param requestType 该请求的请求类型
 @param string 该请求的URL
 */
- (void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string
{
    NSError *error;
    
}


#pragma mark - private method
- (void)requestWithType:(HTTPRequestType)type urlString:(NSString *)urlString params:(id)params success:(PrivateRequestSuccess)successBlock failure:(PrivateRequestFailure)failureBlock progress:(DownloadProgress)progress isCached:(BOOL)isCached
{
    NSDictionary *insetParams;
    NSData *jsonData;
    if (params != nil) {
        NSError *error;
        jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            insetParams = @{@"params":@[]};
        }
        else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            insetParams = @{@"params":jsonString};
        }
    }
    else {
        insetParams = @{@"params":@[]};
    }
    //把cookie取出来
    NSString *cookie = [NSString stringWithFormat:@"%@", [QDUserDefaults getCookies]];
    if (cookie && ![cookie isEqualToString:@"(null)"] && ![cookie isEqualToString:@""]) {
//        [self.manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    if (isCached) {
        id cacheObj = [QDNetworkCache httpCacheForURL:urlString parameters:insetParams];
        if (cacheObj) {
            QDResponseObject *responseObj = [QDResponseObject yy_modelWithJSON:cacheObj];
            successBlock ? successBlock(nil, responseObj) : nil;
        }
    }
    
    
    switch (type) {
        case kHTTPRequestTypeGET:
        {
//            [self.manager GET:urlString parameters:insetParams progress:^(NSProgress * _Nonnull downloadProgress) {
//                progress ? progress(downloadProgress) : nil;
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                successBlock ? successBlock(task ,responseObject) : nil;
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                failureBlock ? failureBlock(task, error) : nil;
//            }];
        }
            break;
        case kHTTPRequestTypePOST:
        {
            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:nil];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody: jsonData];
            request.timeoutInterval = 60;
            [self.manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
                QDLog(@"uploadProgress");
            } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                QDLog(@"downloadProgress");
            } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
            }];
//            [self.manager POST:urlString parameters:jsonStr progress:^(NSProgress * _Nonnull uploadProgress) {
//                progress ? progress(uploadProgress) : nil;
//            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseData) {
//                NSInteger errorCode = 200;
//                @try {
//                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
//                    NSDictionary *allHeaders = response.allHeaderFields;
//                    NSNumber *code = [allHeaders objectForKey:@"error_code"];
//                    if (code != nil) {
//                        errorCode = [code integerValue];
//                    }
//                } @catch (NSException *exception) {
//
//                } @finally {
//
//                }
//                if (errorCode == 200) {
//                    if (isCached) {
//                        [QDNetworkCache setHttpCache:responseData URL:urlString paramenters:insetParams];
//                    }
//                    QDResponseObject *responseObj = [QDResponseObject yy_modelWithDictionary:responseData];
//                    successBlock ? successBlock(task, responseObj) : nil;
//                }else{
//                    [QDServiceErrorHandler handleError:errorCode];
//                    failureBlock ? failureBlock(task, nil) : nil;
//                }
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                QDLog(@"网络调用失败%@", task.response);
//                failureBlock ? failureBlock(task, error) : nil;
//            }];
        }
            break;
        case kHTTPRequestTypePUT:
        {
//            [self.manager PUT:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                successBlock ? successBlock(task, responseObject) : nil;
//            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                failureBlock ? failureBlock(task, error) : nil;
//            }];
        }
            break;
        case kHTTPRequestTypeDELETE:
        {
            
        }
            break;
        case kHTTPRequestTypeHEAD:
        {
            
        }
            break;
        default:
            break;
    }
}

- (NSString *)getUploadUrlWithServiceName:(NSString *)serviceName functionName:(NSString *)funcName type:(NSString *)type
{
    NSString *urlString;
    if (type && ![type isEqualToString:@""]) {
        urlString = [self getFullUrlByUrl:[NSString stringWithFormat:@"upload/%@/%@?params=[%%22%@%%22,null]", serviceName, funcName, type]];
    }
    else {
        urlString = [self getFullUrlByUrl:[NSString stringWithFormat:@"upload/%@/%@", serviceName, funcName]];
    }
    return urlString;
}

- (NSString *)getMD5String:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
