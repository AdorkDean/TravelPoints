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
@property (nonatomic, strong) UILabel *info2Lab;
@property (nonatomic, strong) UILabel *info3Lab;

@property (nonatomic, strong) SPButton *ruleBtn;


//默认cell高度
//+ (CGFloat)cellDefaultHeight:(TextEntity *)entity;
//
////展开后的高度
//+ (CGFloat)cellMoreHeight:(TextEntity *)entity;
@end

NS_ASSUME_NONNULL_END
