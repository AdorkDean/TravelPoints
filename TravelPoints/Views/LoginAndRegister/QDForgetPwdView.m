//
//  QDForgetPwdView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/15.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDForgetPwdView.h"

@implementation QDForgetPwdView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _loginLab = [[UILabel alloc] init];
        _loginLab.text = @"找回密码";
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
        
        _nextStepBtn = [[QDButton alloc] init];
        [_nextStepBtn setBackgroundColor:[UIColor colorWithHexString:@"#DDDDDD"] forState:UIControlStateNormal];
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextStepBtn.titleLabel.font = QDFont(21);
        [self addSubview:_nextStepBtn];
        
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
    
    [_nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.equalTo(self.phoneLine);
        make.top.equalTo(self.phoneLine.mas_bottom).offset(SCREEN_HEIGHT*0.068);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.075);
    }];
}

@end
