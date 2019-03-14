//
//  QDOrderDetailVC.h
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QDPickUpOrderCell.h"
#import "QDOrderDetailView.h"
#import "QDMyPickOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDOrderDetailVC : UIViewController

@property (nonatomic, strong) UILabel *clockLab;
@property (nonatomic, strong) UILabel *infoLab;

@property (nonatomic, strong) UIView *orderInfoView;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) QDOrderDetailView *detailView;

@property (nonatomic, strong) UILabel *bdNumLab;
@property (nonatomic, strong) UILabel *bdNum;
@property (nonatomic, strong) UILabel *zdNumLab;
@property (nonatomic, strong) UILabel *zdNum;
@property (nonatomic, strong) UILabel *bdTimeLab;
@property (nonatomic, strong) UILabel *bdTime;
@property (nonatomic, strong) UILabel *zdTimeLab;
@property (nonatomic, strong) UILabel *zdTime;

@property (nonatomic, strong) QDMyPickOrderModel *orderModel;
@end

NS_ASSUME_NONNULL_END
