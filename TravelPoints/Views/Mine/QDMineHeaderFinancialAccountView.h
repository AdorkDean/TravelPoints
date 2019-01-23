//
//  QDMineHeaderFinancialAccountView.h
//  TravelPoints
//
//  Created by 冉金 on 2019/1/15.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDMineHeaderFinancialAccountView : UIView

@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *voiceBtn;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *picBtn;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *vipLab;
@property (nonatomic, strong) UILabel *vipRightsLab;
@property (nonatomic, strong) UILabel *deadLineLab;


@property (nonatomic, strong) UIView *whiteBackView;
@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UILabel *balanceDetailLab;
@property (nonatomic, strong) UIButton *tradeDetailBtn;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UIButton *rechargeBtn;
@property (nonatomic, strong) UIButton *withdrawBtn;


@end

NS_ASSUME_NONNULL_END
