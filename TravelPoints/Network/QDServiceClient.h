//
//  QDServiceClient.h
//  QDINFI
//
//  Created by ZengTark on 2017/10/21.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class QDResponseObject;

/**
 网络请求类型

 - kHTTPRequestTypeGET: GET
 - kHTTPRequestTypePOST: POST
 - kHTTPRequestTypePUT: PUT
 - kHTTPRequestTypeDELETE: DELETE
 - kHTTPRequestTypeHEAD: HEAD
 */
typedef NS_ENUM(NSUInteger, HTTPRequestType) {
    kHTTPRequestTypeGET = 0,
    kHTTPRequestTypePOST,
    kHTTPRequestTypePUT,
    kHTTPRequestTypeDELETE,
    kHTTPRequestTypeHEAD
};

//缓存的block
typedef void(^RequestCache)(id jsonCache);
//请求成功的block
typedef void(^RequestSuccess)(QDResponseObject *responseObject);

//请求失败的block
typedef void(^RequestFailure)(NSError *error);
//上传进度block
typedef void(^UploadProgress)(NSProgress *progress);
//下载进度block
typedef void(^DownloadProgress)(NSProgress *progress);

@interface QDServiceClient : NSObject

/**
 网络请求管理类
 */
@property (nonatomic, strong)AFHTTPSessionManager *manager;

+ (instancetype)shareClient;
+ (instancetype)shareMarketClient;

+ (void)startMonitoringNetworking;

/**
 根据url获取完整的urlString

 @param urlString url
 @return urlString
 */
- (NSString *)getFullUrlByUrl:(NSString *)urlString;

#pragma mark - 新增
- (NSString *)getMarkFullUrlByUrl:(NSString *)urlString;


/**
 网络请求

 @param serviceName 服务名
 @param funcName 方法名
 @param paraments 参数
 @param successBlock 成功block
 @param failureBlock 失败block
 @param progressBlock 进度
 */
- (void)requestWithServiceName:(NSString *)serviceName functionName:(NSString *)funcName paraments:(NSArray *)paraments successBlock:(RequestSuccess)successBlock failureBlock:(RequestFailure)failureBlock progress:(DownloadProgress)progressBlock;

/**
 网络请求
 
 @param serviceName 服务名
 @param funcName 方法名
 @param paraments 参数
 @param successBlock 成功block
 @param failureBlock 失败block
 @param progressBlock 进度
 @param isCached 是否缓存数据
 */
- (void)requestWithServiceName:(NSString *)serviceName functionName:(NSString *)funcName paraments:(NSArray *)paraments successBlock:(RequestSuccess)successBlock failureBlock:(RequestFailure)failureBlock progress:(DownloadProgress)progressBlock isCached:(BOOL)isCached;

- (void)requestWithMarketService:(NSString *)serviceName functionName:(NSString *)funcName paraments:(NSArray *)paraments successBlock:(RequestSuccess)successBlock failureBlock:(RequestFailure)failureBlock progress:(DownloadProgress)progressBlock isCached:(BOOL)isCached;

/**
 用户登录

 @param userName 用户名
 @param password 密码
 @param extendsParams 扩展参数
 @param successBlock 成功block
 @param failureBlock 失败block
 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password extendsParams:(id)extendsParams successBlock:(RequestSuccess)successBlock failureBlock:(RequestFailure)failureBlock;

- (NSString *)getVerifyCodeImgUrlString;


/**
 上传图片至服务器

 @param uploadType 上传图片的类型
                idFrontPhoto:身份证(或者护照)正面; idBackPhoto:身份证(或者护照)反面; selfCardPhoto:手持身份证照;
                businessCardPhoto:营业执照;
 @param image 图片
 @param service 服务名
 @param funcName 方法名
 @param successBlock 成功block
 @param failureBlock 失败block
 @param progress 进度block
 */
- (void)uploadImageWithType:(NSString *)uploadType withImage:(UIImage *)image withServiceName:(NSString *)service withFunctionName:(NSString *)funcName withSuccessBlock:(RequestSuccess)successBlock withFailurBlock:(RequestFailure)failureBlock withUpLoadProgress:(UploadProgress)progress;

- (void)getCloudDataWithStr:(NSString *)str SuccessBlock:(RequestSuccess)successBlock withFailurBlock:(RequestFailure)failureBlock withUpLoadProgress:(UploadProgress)progress;
/**
 文件下载
 
 @param operations 文件下载预留参数
 @param savePath 下载文件保存路径
 @param urlString 请求的URL
 @param successBlock 请求成功的block
 @param failureBlock 请求失败的block
 @param progress 下载文件的进度
 */
- (void)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString withSuccessBlock:(RequestSuccess)successBlock withFailureBlock:(RequestFailure)failureBlock withDownLoadProgress:(DownloadProgress)progress;


/**
 取消所有网络请求
 */
- (void)cancelAllRequest;


/**
 取消指定URL请求
 
 @param requestType 该请求的请求类型
 @param string 该请求的URL
 */
- (void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string;

/*
 退出登录
 */
- (void)logoutSuccessBlock:(RequestSuccess)successBlock failureBlock:(RequestFailure)failureBlock;


@end
