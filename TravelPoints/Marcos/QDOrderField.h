//
//  QDOrderField.h
//  TravelPoints
//
//  Created by WJ-Shao on 2019/2/25.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    QDHotelReserve = 0,     //酒店预订
    QDCustomTour = 1,       //定制游
    QDMall = 2,             //商场
    QDRankList = 3,         //榜单
    QDStrategy = 4          //攻略
} QDPlayShellType;

typedef enum: NSUInteger{
    QD_ORDERSTATUS_NOTTRADED = 0,    //未成交
    QD_ORDERSTATUS_PARTTRADED = 1,   //部分成交
    QD_ORDERSTATUS_ALLTRADED = 2,    //全部成交
    QD_ORDERSTATUS_ALLCANCELED = 3,  //全部撤单
    QD_ORDERSTATUS_PARTCANCELED = 4, //部成部撤
    QD_ORDERSTATUS_ISCANCELED = 5,   //已取消
    QD_ORDERSTATUS_INTENTION = 6     //意向单
}QDORDERSTATUS;


typedef enum: NSUInteger{
    QD_ORDERSTATUS_CANNOTPARTTRADED = 0,    //已部分成交
    QD_ORDERSTATUS_CANPARTTRADED = 1,       //不可部分成交
}QD_ORDER_DEALSTATUS;

typedef enum: NSUInteger{
    QD_WaitForPurchase = 0,    //待付款
    QD_HavePurchased = 1,      //已付款
    QD_HaveFinished = 2,       //已完成
    QD_OverTimeCanceled = 3,   //超时取消
    QD_ManualCanceled = 4      //手工取消
}QDPickOrderStatus;

//导航 附近餐厅 附近景区
typedef enum : NSUInteger {
    QDNavigation = 0,
    QDNearByRestaurant = 1,
    QDNearSpot = 2
} QDRouteType;
@interface QDOrderField : NSObject

@end

NS_ASSUME_NONNULL_END
