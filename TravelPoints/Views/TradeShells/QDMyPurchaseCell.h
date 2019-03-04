//
//  QDMyPurchaseCell.h
//  TravelPoints
//
//  Created by WJ-Shao on 2019/2/25.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiddingPostersDTO.h"
#import "QDMyPickOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDMyPurchaseCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UILabel *operationTypeLab;

@property (nonatomic, strong) UILabel *priceTextLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *status;

@property (nonatomic, strong) UILabel *amountLab;
@property (nonatomic, strong) UILabel *amount;

@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UILabel *balance;

@property (nonatomic, strong) UILabel *transferLab;
@property (nonatomic, strong) UILabel *transfer;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *orderStatusLab;
@property (nonatomic, strong) UIButton *withdrawBtn;

- (void)loadPurchaseDataWithModel:(BiddingPostersDTO *)DTO;

- (void)loadMyPickPurchaseDataWithModel:(QDMyPickOrderModel *)model;

@end

NS_ASSUME_NONNULL_END
