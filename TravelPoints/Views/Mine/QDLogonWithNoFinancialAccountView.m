//
//  QDMineHeaderNotLoginView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/15.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDLogonWithNoFinancialAccountView.h"

@implementation QDLogonWithNoFinancialAccountView

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
        
        _whiteBackView = [[UIView alloc] init];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_whiteBackView];
        
        _balanceLab = [[UILabel alloc] init];
        _balanceLab.text = @"余额";
        _balanceLab.textColor = APP_GRAYCOLOR;
        _balanceLab.font = QDFont(13);
        [_whiteBackView addSubview:_balanceLab];
        
        _infoLab = [[UILabel alloc] init];
        _infoLab.text = @"暂未开通资金账户";
        _infoLab.textColor = APP_GRAYCOLOR;
        _infoLab.font = QDFont(13);
        [_whiteBackView addSubview:_infoLab];
        
        _vipRightsLab = [[UILabel alloc] init];
        _vipRightsLab.text = @"会员权益";
        _vipRightsLab.textColor = [UIColor whiteColor];
        _vipRightsLab.font = QDFont(13);
        [self addSubview:_vipRightsLab];
        
        
        _openFinancialBtn = [[UIButton alloc] init];
        [_openFinancialBtn setTitle:@"开通资金账户" forState:UIControlStateNormal];
        _openFinancialBtn.backgroundColor = [UIColor whiteColor];
        _openFinancialBtn.titleLabel.font = QDFont(15);
        _openFinancialBtn.layer.borderColor = APP_GREENCOLOR.CGColor;
        _openFinancialBtn.layer.borderWidth = 1;
        [_openFinancialBtn setTitleColor:APP_GREENCOLOR forState:UIControlStateNormal];
        [_whiteBackView addSubview:_openFinancialBtn];
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
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.11);
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

    [_whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.238);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.1);
    }];
    
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteBackView);
        make.left.equalTo(self.whiteBackView.mas_left).offset(SCREEN_WIDTH*0.053);
    }];

    [_infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteBackView);
        make.left.equalTo(self.whiteBackView.mas_left).offset(SCREEN_WIDTH*0.157);
    }];

    [_openFinancialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteBackView);
        make.right.equalTo(self.whiteBackView.mas_right).offset(-(SCREEN_WIDTH*0.053));
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
        make.width.mas_equalTo(SCREEN_WIDTH*0.346);
    }];
}

@end
