//
//  QDLoginView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/15.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDLoginView.h"

@implementation QDLoginView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _loginLab = [[UILabel alloc] init];
        _loginLab.text = @"登录行点";
        _loginLab.font = QDFont(32);
        [self addSubview:_loginLab];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#50C533"];
        [self addSubview:_lineView];
        
        _phoneLine = [[UIView alloc] init];
        _phoneLine.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [self addSubview:_phoneLine];
        
        _areaBtn = [[UIButton alloc] init];
        [_areaBtn setTitle:@"+86" forState:UIControlStateNormal];
        [_areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:_areaBtn];
        
        _phoneTF = [[UITextField alloc] init];
        _phoneTF.placeholder = @"请输入手机号";
        [_phoneTF setValue:[UIColor colorWithHexString:@"#CCCCCC"] forKeyPath:@"placeholderLabel.textColor"];
        [_phoneTF setValue:[UIFont systemFontOfSize:17] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_phoneTF];
        
        _userNameLine = [[UIView alloc] init];
        _userNameLine.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [self addSubview:_userNameLine];
        
        _userNameTF = [[UITextField alloc] init];
        _userNameTF.placeholder = @"请输入用户名";
        [_userNameTF setValue:[UIColor colorWithHexString:@"#CCCCCC"] forKeyPath:@"placeholderLabel.textColor"];
        [_userNameTF setValue:[UIFont systemFontOfSize:17] forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_userNameTF];
        
        _forgetPWD = [[UIButton alloc] init];
        [_forgetPWD setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPWD setTitleColor:[UIColor colorWithHexString:@"CCCCCC"] forState:UIControlStateNormal];
        _forgetPWD.titleLabel.font = QDFont(13);
        [self addSubview:_forgetPWD];
        
        
        _gotologinBtn = [[QDButton alloc] init];
        [_gotologinBtn setBackgroundColor:[UIColor colorWithHexString:@"#DDDDDD"] forState:UIControlStateNormal];
        //        #72BB37
        [_gotologinBtn setTitle:@"登录" forState:UIControlStateNormal];
        _gotologinBtn.titleLabel.font = QDFont(21);
        [self addSubview:_gotologinBtn];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_loginLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.156);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loginLab);
        make.top.equalTo(self.loginLab.mas_bottom).offset(SCREEN_HEIGHT*0.012);
        make.width.mas_equalTo(SCREEN_WIDTH*0.097);
        make.height.mas_equalTo(SCREEN_WIDTH*0.01);
    }];
    
    [_phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.35);
        make.height.equalTo(@1);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
    }];
    
    [_areaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.053);
        make.bottom.equalTo(self.phoneLine.mas_top).offset(-(SCREEN_HEIGHT*0.01));
    }];
    
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCREEN_WIDTH*0.22);
        make.centerY.equalTo(self.areaBtn);
    }];
    
    [_userNameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.and.left.equalTo(self.phoneLine);
        make.top.equalTo(self.phoneLine.mas_bottom).offset(SCREEN_HEIGHT*0.1);
    }];
    
    [_userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTF);
        make.bottom.equalTo(self.userNameLine.mas_top).offset(-(SCREEN_HEIGHT*0.01));
    }];
    
    [_forgetPWD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userNameTF);
        make.right.equalTo(self.userNameLine);
    }];
    
    [_gotologinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.userNameLine);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.075);
        make.top.equalTo(self.userNameLine.mas_bottom).offset(SCREEN_HEIGHT*0.067);
    }];
}


@end
