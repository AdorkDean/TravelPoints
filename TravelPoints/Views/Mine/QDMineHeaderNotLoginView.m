//
//  QDMineHeaderNotLoginView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/15.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDMineHeaderNotLoginView.h"

@implementation QDMineHeaderNotLoginView

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
        
        _whiteBackView = [[UIView alloc] init];
        _whiteBackView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_whiteBackView];
        
        _picBtn = [[UIButton alloc] init];
        [_picBtn setImage:[UIImage imageNamed:@"icon_tabbar_merchant_normal"] forState:UIControlStateNormal];
        _picBtn.layer.borderWidth = SCREEN_WIDTH*0.01;
        _picBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _picBtn.layer.masksToBounds = YES;
        _picBtn.layer.cornerRadius = SCREEN_WIDTH*0.085;
        [self addSubview:_picBtn];
        
        _infoLab = [[UILabel alloc] init];
        _infoLab.text = @"登录后查看更多服务及权益";
        _infoLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _infoLab.font = QDFont(13);
        [self addSubview:_infoLab];
        
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor colorWithHexString:@"#72BB37"];
        _loginBtn.titleLabel.font = QDFont(15);
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 10;
        [self addSubview:_loginBtn];
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
        make.height.mas_equalTo(SCREEN_HEIGHT*0.225);
    }];
    
    [_whiteBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.12);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.225);
    }];
    
    [_picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteBackView);
        make.top.equalTo(self.whiteBackView.mas_top).offset(-(SCREEN_HEIGHT*0.048));
        make.width.and.height.equalTo(@(SCREEN_WIDTH*0.17));
    }];

    [_infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteBackView);
        make.top.equalTo(self.whiteBackView.mas_top).offset(SCREEN_HEIGHT*0.087);
    }];

    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.whiteBackView);
        make.bottom.equalTo(self.whiteBackView.mas_bottom).offset(-(SCREEN_HEIGHT*0.03));
        make.height.mas_equalTo(SCREEN_HEIGHT*0.057);
        make.width.mas_equalTo(SCREEN_WIDTH*0.43);
    }];
}

@end
