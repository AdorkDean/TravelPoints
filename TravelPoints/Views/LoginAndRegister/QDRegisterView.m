//
//  QDRegisterView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/14.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDRegisterView.h"
@implementation QDRegisterView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
//        _cancelBtn = [[UIButton alloc] init];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self addSubview:_cancelBtn];
//
//        _loginBtn = [[UIButton alloc] init];
//        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
//        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self addSubview:_loginBtn];
        
        _registerLab = [[UILabel alloc] init];
        _registerLab.text = @"注册行点";
        _registerLab.font = QDFont(32);
        [self addSubview:_registerLab];
        
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

        _infoLab = [[UILabel alloc] init];
        _infoLab.textColor = [UIColor colorWithHexString:@"CCCCCC"];
        _infoLab.text = @"支持6-20个字符";
        _infoLab.font = QDFont(13);
        [self addSubview:_infoLab];
        
        
        _nextBtn = [[QDButton alloc] init];
        [_nextBtn setBackgroundColor:[UIColor colorWithHexString:@"#DDDDDD"] forState:UIControlStateNormal];
//        #72BB37
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = QDFont(21);
        [self addSubview:_nextBtn];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor redColor];
        _imgView.image = [UIImage imageNamed:@"icon_tabbar_homepage"];
        _imgView.hidden = YES;
        [self addSubview:self.imgView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.054);
//        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.056);
//    }];
//    
//    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.cancelBtn);
//        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.056));
//    }];
//    
    [_registerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.156);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.registerLab);
        make.top.equalTo(self.registerLab.mas_bottom).offset(SCREEN_HEIGHT*0.012);
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
    
    [_infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userNameTF);
        make.right.equalTo(self.userNameLine);
    }];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.userNameLine);
        make.top.equalTo(self.userNameLine.mas_bottom).offset(SCREEN_HEIGHT*0.12);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.075);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.userNameLine);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.075);
        make.top.equalTo(self.userNameLine.mas_bottom).offset(SCREEN_HEIGHT*0.12);
    }];
}

@end
