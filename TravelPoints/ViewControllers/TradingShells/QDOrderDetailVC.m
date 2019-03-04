//
//  QDOrderDetailVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDOrderDetailVC.h"
@interface QDOrderDetailVC ()

@end

@implementation QDOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self showBack:YES];
//    self.navigationController.navigationBar.barTintColor = APP_WHITECOLOR;
    self.view.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
    [self initUI];
}

- (void)initUI{
    _clockLab = [[UILabel alloc] init];
    _clockLab.text = @"111";
    _clockLab.backgroundColor = [UIColor redColor];
    _clockLab.textColor = APP_BLUECOLOR;
    [self.view addSubview:_clockLab];
    [_clockLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT*0.14);
        make.left.equalTo(self.view.mas_left).offset(SCREEN_WIDTH*0.31);
        make.right.equalTo(self.view.mas_right).offset(-(SCREEN_WIDTH*0.31));
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
    }];
    _infoLab = [[UILabel alloc] init];
    _infoLab.text = @"超时自动关闭订单";
    _infoLab.font = QDFont(12);
    _infoLab.textColor = APP_GRAYCOLOR;
    [self.view addSubview:_infoLab];
    [_infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_clockLab);
        make.top.equalTo(_clockLab.mas_bottom).offset(SCREEN_HEIGHT*0.006);
    }];
    
    _detailView = [[QDOrderDetailView alloc] init];
    _detailView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_detailView];

    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT*0.28);
        make.left.equalTo(self.view.mas_left).offset(SCREEN_WIDTH*0.05);
        make.right.equalTo(self.view.mas_right).offset(-(SCREEN_WIDTH*0.05));
        make.height.mas_equalTo(SCREEN_HEIGHT*0.22);
    }];
    
    _orderInfoView = [[UIView alloc] init];
    _orderInfoView.backgroundColor = APP_WHITECOLOR;
    [self.view addSubview:_orderInfoView];

    [_orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_detailView.mas_bottom).offset(SCREEN_HEIGHT*0.015);
        make.left.and.right.equalTo(_detailView);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.18);
    }];
    
    _bdNumLab = [[UILabel alloc] init];
    _bdNumLab.text = @"报单编号:";
    _bdNumLab.textColor = APP_GRAYTEXTCOLOR;
    _bdNumLab.font = QDFont(13);
    [_orderInfoView addSubview:_bdNumLab];
    [_bdNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderInfoView.mas_left).offset(SCREEN_WIDTH*0.04);
        make.top.equalTo(_orderInfoView.mas_top).offset(SCREEN_WIDTH*0.04);
    }];

    _bdNum = [[UILabel alloc] init];
    _bdNum.text = @"O181204B13855";
    _bdNum.textColor = APP_GRAYTEXTCOLOR;
    _bdNum.font = QDFont(13);
    [_orderInfoView addSubview:_bdNum];
    [_bdNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bdNumLab);
        make.left.equalTo(_bdNumLab.mas_right).offset(3);
    }];

    _zdNumLab = [[UILabel alloc] init];
    _zdNumLab.text = @"摘单编号:";
    _zdNumLab.textColor = APP_GRAYTEXTCOLOR;
    _zdNumLab.font = QDFont(13);
    [_orderInfoView addSubview:_zdNumLab];
    [_zdNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bdNumLab);
        make.top.equalTo(_bdNumLab.mas_bottom).offset(3);
    }];

    _zdNum = [[UILabel alloc] init];
    _zdNum.text = @"123009240NDF0GFFD";
    _zdNum.textColor = APP_GRAYTEXTCOLOR;
    _zdNum.font = QDFont(13);
    [_orderInfoView addSubview:_zdNum];
    [_zdNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zdNumLab);
        make.left.equalTo(_zdNumLab.mas_right).offset(3);
    }];

    _bdTimeLab = [[UILabel alloc] init];
    _bdTimeLab.text = @"报单时间:";
    _bdTimeLab.textColor = APP_GRAYTEXTCOLOR;
    _bdTimeLab.font = QDFont(13);
    [_orderInfoView addSubview:_bdTimeLab];
    [_bdTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bdNumLab);
        make.top.equalTo(_zdNumLab.mas_bottom).offset(3);
    }];
    _bdTime = [[UILabel alloc] init];
    _bdTime.text = @"2018-11-20 11:30:11";
    _bdTime.textColor = APP_GRAYTEXTCOLOR;
    _bdTime.font = QDFont(13);
    [_orderInfoView addSubview:_bdTime];
    [_bdTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bdTimeLab);
        make.left.equalTo(_bdTimeLab.mas_right).offset(3);
    }];
    _zdTimeLab = [[UILabel alloc] init];
    _zdTimeLab.text = @"摘单时间:";
    _zdTimeLab.textColor = APP_GRAYTEXTCOLOR;
    _zdTimeLab.font = QDFont(13);
    [_orderInfoView addSubview:_zdTimeLab];
    [_zdTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bdNumLab);
        make.top.equalTo(_bdTimeLab.mas_bottom).offset(3);
    }];
    _zdTime = [[UILabel alloc] init];
    _zdTime.text = @"2018-11-20 11:30:11";
    _zdTime.textColor = APP_GRAYTEXTCOLOR;
    _zdTime.font = QDFont(13);
    [_orderInfoView addSubview:_zdTime];
    [_zdTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_zdTimeLab);
        make.left.equalTo(_zdTimeLab.mas_right).offset(3);
    }];

    _payBtn = [[UIButton alloc] init];
    [_payBtn setTitle:@"付款" forState:UIControlStateNormal];
    [_payBtn setTitleColor:APP_WHITECOLOR forState:UIControlStateNormal];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.89, SCREEN_HEIGHT*0.08);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#159095"] CGColor],(id)[[UIColor colorWithHexString:@"#3CC8B1"] CGColor]]];//渐变数组
    [_payBtn.layer addSublayer:gradientLayer];
    _payBtn.titleLabel.font = QDFont(17);
    [self.view addSubview:_payBtn];
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderInfoView.mas_bottom).offset(SCREEN_HEIGHT*0.06);
        make.left.and.right.equalTo(_orderInfoView);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.08);
    }];
}

@end
