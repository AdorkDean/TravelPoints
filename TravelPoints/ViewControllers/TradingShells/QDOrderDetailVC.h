//
//  QDOrderDetailVC.h
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDPickUpOrderCell.h"
#import "QDMyPickOrderModel.h"
#import "BiddingPostersDTO.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDOrderDetailVC : UIViewController

@property (nonatomic, strong) QDMyPickOrderModel *orderModel;
@property (nonatomic, strong) BiddingPostersDTO *posterDTO;
@property (nonatomic, strong) NSString *typeStr;    //0为我的报单 1为我的摘单
@end

NS_ASSUME_NONNULL_END
