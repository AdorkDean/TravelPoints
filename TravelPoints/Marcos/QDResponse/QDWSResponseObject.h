//
//  QDWSResponseObject.h
//  QDINFI
//
//  Created by ZengTark on 2018/1/16.
//  Copyright © 2018年 quantdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDWSResponseObject : NSObject

/**
 数据
 */
@property (nonatomic, strong)NSString *data;

/**
 格式
 */
@property (nonatomic, strong)NSString *dataEncoding;

/**
 错误编码
 */
@property (nonatomic, assign)NSInteger errorCode;

/**
 错误信息
 */
@property (nonatomic, strong)NSString *errorMsg;

/**
 头部错误编码
 */
@property (nonatomic, assign)NSInteger headerErrorCode;

/**
 方法
 */
@property (nonatomic, strong)NSString *oper;

/**
 主题
 */
@property (nonatomic, strong)NSString *topic;
@end
