//
//  QDPickOrderView.m
//  TravelPoints
//
//  Created by WJ-Shao on 2019/3/14.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDPickOrderView.h"

@implementation QDPickOrderView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = APP_WHITECOLOR;
        [self addSubview:_topView];
        
        _statusLab = [[UILabel alloc] init];
        _statusLab.text = @"待付款";
        _statusLab.font = QDFont(17);
        [_topView addSubview:_statusLab];
        
        _infoLab = [[UILabel alloc] init];
        _infoLab.text = @"超时将自动关闭订单";
        _infoLab.textColor = APP_BLUECOLOR;
        _infoLab.font = QDFont(13);
        [_topView addSubview:_infoLab];
        
        _remainLab = [[UILabel alloc] init];
        _remainLab.text = @"剩余";
        _remainLab.textColor = APP_GRAYTEXTCOLOR;
        _remainLab.font = QDFont(13);
        [_topView addSubview:_remainLab];
        
        _remain = [[UILabel alloc] init];
        _remain.text = @"00:58:47";
        _remain.textColor = APP_GRAYTEXTCOLOR;
        _remain.font = QDFont(12);
        [_topView addSubview:_remain];
        
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = APP_WHITECOLOR;
        [self addSubview:_centerView];

        
        _operationType = [[UILabel alloc] init];
        _operationType.text = @"买入";
        _operationType.font = QDFont(12);
        _operationType.textColor = APP_GRAYTEXTCOLOR;
        [_centerView addSubview:_operationType];
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = APP_LIGHTGRAYCOLOR;
        [_centerView addSubview:_topLine];
        
        _lab1 = [[UILabel alloc] init];
        _lab1.text = @"金额";
        _lab1.font = QDFont(14);
        _lab1.textColor = APP_GRAYLINECOLOR;
        [_centerView addSubview:_lab1];
        
        _lab2 = [[UILabel alloc] init];
        _lab2.text = @"¥";
        _lab2.font = QDFont(20);
        _lab2.textColor = APP_ORANGETEXTCOLOR;
        [_centerView addSubview:_lab2];
        
        _lab3 = [[UILabel alloc] init];
        _lab3.text = @"20000";
        _lab3.font = QDFont(24);
        _lab3.textColor = APP_ORANGETEXTCOLOR;
        [_centerView addSubview:_lab3];
        
        _lab4 = [[UILabel alloc] init];
        _lab4.text = @"数量";
        _lab4.font = QDFont(14);
        _lab4.textColor = APP_GRAYLINECOLOR;
        [_centerView addSubview:_lab4];
        
        _lab5 = [[UILabel alloc] init];
        _lab5.text = @"2000";
        _lab5.font = QDFont(13);
        _lab5.textColor = APP_GRAYTEXTCOLOR;
        [_centerView addSubview:_lab5];
        
        _lab6 = [[UILabel alloc] init];
        _lab6.text = @"单价";
        _lab6.font = QDFont(13);
        _lab6.textColor = APP_GRAYLINECOLOR;
        [_centerView addSubview:_lab6];
        
        _lab7 = [[UILabel alloc] init];
        _lab7.text = @"¥10.00";
        _lab7.font = QDFont(13);
        _lab7.textColor = APP_GRAYTEXTCOLOR;
        [_centerView addSubview:_lab7];
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = APP_LIGHTGRAYCOLOR;
        [_centerView addSubview:_bottomLine];
        
        _bdNumLab = [[UILabel alloc] init];
        _bdNumLab.text = @"报单编号:";
        _bdNumLab.textColor = APP_GRAYTEXTCOLOR;
        _bdNumLab.font = QDFont(13);
        [_centerView addSubview:_bdNumLab];
        
        _bdNum = [[UILabel alloc] init];
        _bdNum.text = @"O181204B13855";
        _bdNum.textAlignment = NSTextAlignmentRight;
        _bdNum.textColor = APP_GRAYTEXTCOLOR;
        _bdNum.font = QDFont(13);
        [_centerView addSubview:_bdNum];
        
        _zdNumLab = [[UILabel alloc] init];
        _zdNumLab.text = @"摘单编号:";
        _zdNumLab.textColor = APP_GRAYTEXTCOLOR;
        _zdNumLab.font = QDFont(13);
        [_centerView addSubview:_zdNumLab];
        
        _zdNum = [[UILabel alloc] init];
        _zdNum.text = @"123009240NDF0GFFD";
        _zdNum.textColor = APP_GRAYTEXTCOLOR;
        _zdNum.textAlignment = NSTextAlignmentRight;
        _zdNum.font = QDFont(13);
        [_centerView addSubview:_zdNum];
        
        _bdTimeLab = [[UILabel alloc] init];
        _bdTimeLab.text = @"报单时间:";
        _bdTimeLab.textColor = APP_GRAYTEXTCOLOR;
        _bdTimeLab.font = QDFont(13);
        [_centerView addSubview:_bdTimeLab];
        
        _bdTime = [[UILabel alloc] init];
        _bdTime.text = @"2018-11-20 11:30:11";
        _bdTime.textAlignment = NSTextAlignmentRight;
        _bdTime.textColor = APP_GRAYTEXTCOLOR;
        _bdTime.font = QDFont(13);
        [_centerView addSubview:_bdTime];
        
        _zdTimeLab = [[UILabel alloc] init];
        _zdTimeLab.text = @"摘单时间:";
        _zdTimeLab.textColor = APP_GRAYTEXTCOLOR;
        _zdTimeLab.font = QDFont(13);
        [_centerView addSubview:_zdTimeLab];
 
        _zdTime = [[UILabel alloc] init];
        _zdTime.text = @"2018-11-20 11:30:11";
        _zdTime.textAlignment = NSTextAlignmentRight;
        _zdTime.textColor = APP_GRAYTEXTCOLOR;
        _zdTime.font = QDFont(13);
        [_centerView addSubview:_zdTime];
 
        _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(21, 505, 155, 50)];
        [_payBtn setTitle:@"付款" forState:UIControlStateNormal];
        [_payBtn setTitleColor:APP_WHITECOLOR forState:UIControlStateNormal];
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 155, 50);
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
        [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#159095"] CGColor],(id)[[UIColor colorWithHexString:@"#3CC8B1"] CGColor]]];//渐变数组
        [_payBtn.layer addSublayer:gradientLayer];
        _payBtn.titleLabel.font = QDFont(17);
        [self addSubview:_payBtn];
        
        _withdrawBtn = [[UIButton alloc] init];
        [_withdrawBtn setTitle:@"撤单" forState:UIControlStateNormal];
        [_withdrawBtn setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        _withdrawBtn.layer.borderColor = APP_BLUECOLOR.CGColor;
        _withdrawBtn.layer.borderWidth = 1;
        _withdrawBtn.backgroundColor = APP_WHITECOLOR;
        _withdrawBtn.titleLabel.font = QDFont(17);
        [self addSubview:_withdrawBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(20);
        make.height.mas_equalTo(90);
        make.width.mas_equalTo(335);
    }];
    
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_top).offset(20);
        make.left.equalTo(_topView.mas_left).offset(15);
    }];
    
    [_infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_statusLab);
        make.left.equalTo(_statusLab.mas_right).offset(10);
    }];
    
    [_remainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_statusLab.mas_bottom).offset(2);
        make.left.equalTo(_statusLab);
    }];
    
    [_remain mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_remainLab);
        make.left.equalTo(_remainLab.mas_right);
    }];
    
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.equalTo(_topView);
        make.top.equalTo(_topView.mas_bottom).offset(20);
        make.height.mas_equalTo(281);
    }];

    [_operationType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_top).offset(13);
        make.left.equalTo(_centerView.mas_left).offset(15);
    }];

    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_centerView);
        make.top.equalTo(_centerView.mas_top).offset(48);
        make.width.mas_equalTo(305);
        make.height.mas_equalTo(1);
    }];

    [_lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_operationType);
        make.top.equalTo(_topLine.mas_bottom).offset(20);
    }];

    [_lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lab1);
        make.top.equalTo(_lab1.mas_bottom).offset(8);
    }];

    [_lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lab2);
        make.left.equalTo(_lab2.mas_right);
    }];

    [_lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_centerView.mas_left).offset(180);
        make.centerY.equalTo(_lab1);
    }];

    [_lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lab4.mas_right);
        make.centerY.equalTo(_lab4);
    }];

    [_lab6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lab2);
        make.left.equalTo(_lab4);
    }];

    [_lab7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lab6.mas_right);
        make.centerY.equalTo(_lab6);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.and.height.equalTo(_topLine);
        make.top.equalTo(_topLine.mas_bottom).offset(88);
    }];

    [_bdNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomLine);
        make.top.equalTo(_bottomLine.mas_bottom).offset(20);
    }];

    [_bdNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bdNumLab);
        make.right.equalTo(_bottomLine);
    }];

    [_zdNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bdNumLab);
        make.top.equalTo(_bdNumLab.mas_bottom).offset(3);
    }];

    [_zdNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zdNumLab);
        make.right.equalTo(_topLine);
    }];

    [_bdTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bdNumLab);
        make.top.equalTo(_zdNumLab.mas_bottom).offset(3);
    }];

    [_bdTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bdTimeLab);
        make.right.equalTo(_topLine);
    }];

    [_zdTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bdNumLab);
        make.top.equalTo(_bdTimeLab.mas_bottom).offset(3);
    }];

    [_zdTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zdTimeLab);
        make.right.equalTo(_topLine);
    }];

    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_bottom).offset(30);
        make.left.equalTo(_centerView);
        make.width.mas_equalTo(155);
        make.height.mas_equalTo(50);
    }];
    
    [_withdrawBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_centerView.mas_bottom).offset(30);
        make.right.equalTo(_centerView);
        make.width.mas_equalTo(155);
        make.height.mas_equalTo(50);
    }];
}

- (void)loadViewWithModel:(QDMyPickOrderModel *)model{
    if
}
@end