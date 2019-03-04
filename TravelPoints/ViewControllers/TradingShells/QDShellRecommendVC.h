//
//  QDShellRecommendVC.h
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDBaseViewController.h"
#import "BiddingPostersDTO.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDShellRecommendVC : QDBaseViewController

@property (nonatomic, assign) int recommendType;
@property (nonatomic, strong) BiddingPostersDTO *recommendModel;
@property (nonatomic, assign) int volume;    //购买数量
@property (nonatomic, assign) double price;     //购买价格
@property (nonatomic, strong) NSString *postersType;     //挂单类型

@end

NS_ASSUME_NONNULL_END
