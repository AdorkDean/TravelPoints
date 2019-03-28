//
//  AllHouseCouponCell.h
//  TravelPoints
//
//  Created by WJ-Shao on 2019/3/28.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface AllHouseCouponCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *couponNo;
@property (nonatomic, strong) UILabel *deadLineLab;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) SPButton *ruleBtn;

@end

NS_ASSUME_NONNULL_END
