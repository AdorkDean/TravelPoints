//
//  QDMineHeaderFinancialAccountView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/15.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDMineHeaderFinancialAccountView.h"

@implementation QDMineHeaderFinancialAccountView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _settingBtn = [[UIButton alloc] init];
        [_settingBtn setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
        [self addSubview:_settingBtn];
        
        _voiceBtn = [[UIButton alloc] init];
        [_voiceBtn setImage:[UIImage imageNamed:@"icon_info"] forState:UIControlStateNormal];
        [self addSubview:_voiceBtn];
        
        _picView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.06, SCREEN_HEIGHT*0.1, SCREEN_WIDTH*0.12, SCREEN_WIDTH*0.12)];
        _picView.layer.cornerRadius = SCREEN_WIDTH*0.06;
        _picView.layer.masksToBounds = YES;
        [_picView setImage:[UIImage imageNamed:@"icon_headerPic"]];
        [self addSubview:_picView];
        
        _userNameLab = [[UILabel alloc] init];
        _userNameLab.text = @"风式幽助";
        _userNameLab.textColor = APP_BLACKCOLOR;
        _userNameLab.font = QDFont(17);
        [self addSubview:_userNameLab];
        
        _levelPic = [[UIImageView alloc] init];
        [_levelPic setImage:[UIImage imageNamed:@"icon_crown"]];
        [self addSubview:_levelPic];
        
        _levelLab = [[UILabel alloc] init];
        _levelLab.text = @"Lv2";
        _levelLab.textColor = APP_WHITECOLOR;
        _levelLab.font = QDFont(12);
        [_levelPic addSubview:_levelLab];
        
        _vipRightsBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
        _vipRightsBtn.frame = CGRectMake(SCREEN_WIDTH*0.72, SCREEN_HEIGHT*0.12, SCREEN_WIDTH*0.29, SCREEN_HEIGHT*0.05);
        [_vipRightsBtn setTitle:@"会员权益 >" forState:UIControlStateNormal];
        [_vipRightsBtn setImage:[UIImage imageNamed:@"icon_rights"] forState:UIControlStateNormal];
        [_vipRightsBtn setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        _vipRightsBtn.titleLabel.font = QDFont(12);
        _vipRightsBtn.backgroundColor = APP_GRAYBUTTONCOLOR;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_vipRightsBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(SCREEN_HEIGHT*0.025, SCREEN_HEIGHT*0.025)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _vipRightsBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        _vipRightsBtn.layer.mask = maskLayer;
        [self addSubview:_vipRightsBtn];
        
        
        _financialPic = [[UIImageView alloc] init];
        [_financialPic setImage:[UIImage imageNamed:@"vipLevel"]];
        [self addSubview:_financialPic];
        
        _info1Lab = [[UILabel alloc] init];
        _info1Lab.text = @"升级还需";
        _info1Lab.textColor = APP_GRAYLINECOLOR;
        _info1Lab.font = QDFont(13);
        [_financialPic addSubview:_info1Lab];
        
        _info2Lab = [[UILabel alloc] init];
        _info2Lab.text = @"75";
        _info2Lab.textColor = APP_BLUECOLOR;
        _info2Lab.font = QDFont(13);
        [_financialPic addSubview:_info2Lab];
        
        _info3Lab = [[UILabel alloc] init];
        _info3Lab.text = @"成长值";
        _info3Lab.textColor = APP_GRAYLINECOLOR;
        _info3Lab.font = QDFont(13);
        [_financialPic addSubview:_info3Lab];
        
        _progressView = [[MQGradientProgressView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.09, SCREEN_HEIGHT*0.28, SCREEN_WIDTH*0.63, SCREEN_HEIGHT*0.008)];
        [self addSubview:_progressView];
        
        _info4Lab = [[UILabel alloc] init];
        _info4Lab.text = @"LV5";
        _info4Lab.textColor = APP_BLACKCOLOR;
        _info4Lab.font = QDFont(12);
        [_financialPic addSubview:_info4Lab];
        
        _info5Lab = [[UILabel alloc] init];
        _info5Lab.text = @"(425)";
        _info5Lab.textColor = APP_GRAYTEXTCOLOR;
        _info5Lab.font = QDFont(11);
        [_financialPic addSubview:_info5Lab];
        
        _info6Lab = [[UILabel alloc] init];
        _info6Lab.text = @"LV6";
        _info6Lab.textColor = APP_BLACKCOLOR;
        _info6Lab.font = QDFont(12);
        [_financialPic addSubview:_info6Lab];
        
        _info7Lab = [[UILabel alloc] init];
        _info7Lab.text = @"(500)";
        _info7Lab.textColor = APP_GRAYLINECOLOR;
        _info7Lab.font = QDFont(11);
        [_financialPic addSubview:_info7Lab];
        
        _info8Lab = [[UILabel alloc] init];
        _info8Lab.text = @"我的玩贝(个)";
        _info8Lab.textColor = APP_GRAYLINECOLOR;
        _info8Lab.font = QDFont(13);
        [_financialPic addSubview:_info8Lab];
        
        
        _info9Lab = [[UILabel alloc] init];
        _info9Lab.text = @"--";
        _info9Lab.textColor = APP_BLACKCOLOR;
        _info9Lab.font = QDBoldFont(18);
        [_financialPic addSubview:_info9Lab];
        
        _accountInfo = [[UIButton alloc] init];
        [_accountInfo setTitle:@"查看账户" forState:UIControlStateNormal];
        _accountInfo.titleLabel.font = QDFont(14);
        [_accountInfo setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        [self addSubview:_accountInfo];
        
        _balanceLab = [[UILabel alloc] init];
        _balanceLab.text = @"我的余额(元)";
        _balanceLab.textColor = APP_GRAYLINECOLOR;
        _balanceLab.font = QDFont(13);
        [self addSubview:_balanceLab];
        
        _balance = [[UILabel alloc] init];
        _balance.text = @"0.00";
        _balance.textColor = APP_BLACKCOLOR;
        _balance.font = QDBoldFont(18);
        [self addSubview:_balance];
        
        _rechargeBtn = [[UIButton alloc] init];
        _rechargeBtn.backgroundColor = APP_BLUECOLOR;
        _rechargeBtn.layer.cornerRadius = 6;
        _rechargeBtn.layer.masksToBounds = YES;
        [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_rechargeBtn setTitleColor:APP_WHITECOLOR forState:UIControlStateNormal];
        _rechargeBtn.titleLabel.font = QDFont(15);
        [self addSubview:_rechargeBtn];
        
        _withdrawBtn = [[UIButton alloc] init];
        _withdrawBtn.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _withdrawBtn.layer.cornerRadius = 6;
        _withdrawBtn.layer.masksToBounds = YES;
        [_withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawBtn setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        _withdrawBtn.titleLabel.font = QDFont(15);
        [self addSubview:_withdrawBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.06);
        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.16));
    }];
    [_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.settingBtn);
        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.05));
    }];
    
    [_userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.1);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.2);
    }];
    
    
    [_levelPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.21);
        make.top.equalTo(_userNameLab.mas_bottom).offset(3);
    }];
    
    [_levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_levelPic.mas_right).offset(-10);
        make.centerY.equalTo(_levelPic);
    }];
    
    [_financialPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.18);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.05);
        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.05));
        make.height.mas_equalTo(SCREEN_HEIGHT*0.25);
    }];
    
    [_info1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_financialPic.mas_left).offset(SCREEN_WIDTH*0.06);
        make.top.equalTo(_financialPic.mas_top).offset(SCREEN_HEIGHT*0.06);
        
    }];
    
    [_info2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_info1Lab);
        make.left.equalTo(_info1Lab.mas_right);
    }];
    
    [_info3Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_info2Lab);
        make.left.equalTo(_info2Lab.mas_right);
    }];
    
    
    [_info4Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_financialPic.mas_top).offset(SCREEN_HEIGHT*0.12);
        make.left.equalTo(_info1Lab);
    }];
    
    [_info5Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_info4Lab);
        make.left.equalTo(_info4Lab.mas_right);
    }];
    
    [_info6Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_info4Lab);
        make.left.equalTo(_financialPic.mas_left).offset(SCREEN_WIDTH*0.54);
    }];
    
    [_info7Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_info6Lab);
        make.left.equalTo(_info6Lab.mas_right);
    }];
    
    [_info8Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_info1Lab);
        make.bottom.equalTo(_financialPic.mas_bottom).offset(-(SCREEN_HEIGHT*0.06));
    }];
    
    [_info9Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_info8Lab);
        make.bottom.equalTo(_financialPic.mas_bottom).offset(-(SCREEN_HEIGHT*0.02));
    }];
    
    [_accountInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_info9Lab);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.34);
    }];
    
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.08);
        make.top.equalTo(_financialPic.mas_bottom).offset(SCREEN_WIDTH*0.05);
    }];
    
    [_balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_balanceLab);
        make.top.equalTo(_balanceLab.mas_bottom).offset(SCREEN_HEIGHT*0.007);
    }];
    
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_financialPic.mas_bottom).offset(SCREEN_HEIGHT*0.04);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.54);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
        make.width.mas_equalTo(SCREEN_WIDTH*0.19);
    }];
    
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.and.height.equalTo(_rechargeBtn);
        make.left.equalTo(_rechargeBtn.mas_right).offset(SCREEN_WIDTH*0.03);
    }];
}

@end
