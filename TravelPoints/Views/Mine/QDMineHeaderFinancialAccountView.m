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
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = APP_GREENCOLOR;
        [self addSubview:_imgView];
        
        _settingBtn = [[UIButton alloc] init];
        [_settingBtn setImage:[UIImage imageNamed:@"icon_tabbar_homepage"] forState:UIControlStateNormal];
        _settingBtn.backgroundColor = [UIColor redColor];
        [self addSubview:_settingBtn];
        
        _voiceBtn = [[UIButton alloc] init];
        [_voiceBtn setImage:[UIImage imageNamed:@"icon_tabbar_homepage"] forState:UIControlStateNormal];
        _voiceBtn.backgroundColor = [UIColor blueColor];
        [self addSubview:_voiceBtn];
        
        _picBtn = [[UIButton alloc] init];
        [_picBtn setImage:[UIImage imageNamed:@"icon_tabbar_merchant_normal"] forState:UIControlStateNormal];
        _picBtn.layer.borderWidth = SCREEN_WIDTH*0.01;
        _picBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _picBtn.layer.masksToBounds = YES;
        _picBtn.layer.cornerRadius = SCREEN_WIDTH*0.085;
        [self addSubview:_picBtn];
        
        
        _userNameLab = [[UILabel alloc] init];
        _userNameLab.text = @"风式幽助";
        _userNameLab.textColor = [UIColor whiteColor];
        _userNameLab.font = QDFont(19);
        [self addSubview:_userNameLab];
        
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = SCREEN_WIDTH*0.024;
        _whiteView.layer.masksToBounds = YES;
        [self addSubview:_whiteView];
        
        _vipLab = [[UILabel alloc] init];
        _vipLab.text = @"白金卡会员";
        _vipLab.textColor = [UIColor whiteColor];
        _vipLab.font = QDFont(12);
        [self addSubview:_vipLab];
        
        _vipRightsLab = [[UILabel alloc] init];
        _vipRightsLab.text = @"会员权益";
        _vipRightsLab.textColor = [UIColor whiteColor];
        _vipRightsLab.font = QDFont(13);
        [self addSubview:_vipRightsLab];
        
        _deadLineLab = [[UILabel alloc] init];
        _deadLineLab.text = @"到期时间：2019-12-31";
        _deadLineLab.textColor = [UIColor whiteColor];
        _deadLineLab.font = QDFont(12);
        [self addSubview:_deadLineLab];
        
        _whiteBackView = [[UIView alloc] init];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_whiteBackView];
        
        _balanceLab = [[UILabel alloc] init];
        _balanceLab.text = @"余额:(元)";
        _balanceLab.textColor = APP_GRAYCOLOR;
        _balanceLab.font = QDFont(13);
        [_whiteBackView addSubview:_balanceLab];
        
        _balanceDetailLab = [[UILabel alloc] init];
        _balanceDetailLab.text = @"999.00";
        _balanceDetailLab.textColor = APP_GREENCOLOR;
        _balanceDetailLab.font = QDFont(30);
        [_whiteBackView addSubview:_balanceDetailLab];
        
        _tradeDetailBtn = [[UIButton alloc] init];
        [_tradeDetailBtn setTitle:@"查看明细" forState:UIControlStateNormal];
        _tradeDetailBtn.titleLabel.font = QDFont(13);
        [_tradeDetailBtn setTitleColor:APP_GRAYCOLOR forState:UIControlStateNormal];
        [_whiteBackView addSubview:_tradeDetailBtn];
        
        _vipRightsLab = [[UILabel alloc] init];
        _vipRightsLab.text = @"会员权益";
        _vipRightsLab.textColor = [UIColor whiteColor];
        _vipRightsLab.font = QDFont(13);
        [self addSubview:_vipRightsLab];
        
        _rechargeBtn = [[UIButton alloc] init];
        [_rechargeBtn setTitle:@"提现" forState:UIControlStateNormal];
        _rechargeBtn.titleLabel.font = QDFont(17);
        _rechargeBtn.backgroundColor = [UIColor colorWithHexString:@"#DFF4D7"];
        [_rechargeBtn setTitleColor:[UIColor colorWithHexString:@"#72BB37"] forState:UIControlStateNormal];
        [_whiteBackView addSubview:_rechargeBtn];
        
        _withdrawBtn = [[UIButton alloc] init];
        [_withdrawBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _withdrawBtn.titleLabel.font = QDFont(17);
        _withdrawBtn.backgroundColor = APP_GREENCOLOR;
        [_whiteBackView addSubview:_withdrawBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.06);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.79);
    }];
    [_voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.settingBtn);
        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.05));
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.26);
    }];
    
    [_picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.1);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.055);
        make.width.and.height.mas_equalTo(SCREEN_WIDTH*0.167);
    }];
    
    [_userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.117);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.26);
    }];
    
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.17);
        make.left.equalTo(self.userNameLab);
        make.width.and.height.mas_equalTo(SCREEN_WIDTH*0.048);
    }];
    
    [_vipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteView);
        make.left.equalTo(self.whiteView.mas_right).offset(SCREEN_WIDTH*0.013);
    }];
    
    [_vipRightsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.117);
        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.054));
    }];
    
    [_deadLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLab);
        make.top.equalTo(self.vipLab.mas_bottom).offset(SCREEN_HEIGHT*0.01);
    }];
    
    [_whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.236);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.247);
    }];
    
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBackView.mas_top).offset(SCREEN_WIDTH*0.053);
        make.left.equalTo(self.whiteBackView.mas_left).offset(SCREEN_WIDTH*0.053);
    }];
    
    [_balanceDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceLab.mas_bottom);
        make.left.equalTo(self.balanceLab);
    }];
    
    [_tradeDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.balanceDetailLab);
        make.right.equalTo(self.whiteBackView.mas_right).offset(-(SCREEN_WIDTH*0.053));
    }];
    
    
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBackView.mas_left).offset(SCREEN_WIDTH*0.053);
        make.right.equalTo(self.mas_left).offset(SCREEN_WIDTH/2);
        make.bottom.equalTo(self.whiteBackView.mas_bottom).offset(-(SCREEN_HEIGHT*0.03));
        make.height.mas_equalTo(SCREEN_HEIGHT*0.075);
    }];
    
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rechargeBtn);
        make.right.equalTo(self.whiteBackView.mas_right).offset(-(SCREEN_WIDTH*0.053));
        make.left.equalTo(self.rechargeBtn.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.075);
    }];
}

@end
