//
//  QDResponseObject.h
//  QDINFI
//
//  Created by ZengTark on 2017/10/24.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDResponseObject : NSObject

@property (nonatomic, assign)NSInteger errorCode;

@property (nonatomic, strong)NSString * errorMsg;

@property (nonatomic, strong)NSString * version;

@property (nonatomic, strong)id data;

@property (nonatomic, assign)NSInteger pageCount;

@property (nonatomic, assign)NSInteger totalCount;

@end
