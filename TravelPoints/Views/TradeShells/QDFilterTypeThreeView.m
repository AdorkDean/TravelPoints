//
//  QDFilterTypeThreeView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDFilterTypeThreeView.h"

@implementation QDFilterTypeThreeView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _direction = [[UILabel alloc] init];
        _direction.text = @"买卖方向";
        _direction.font = QDFont(14);
        [self addSubview:_direction];
        
        _buyBtn = [[UIButton alloc] init];
        _buyBtn.backgroundColor = [UIColor whiteColor];
        [_buyBtn setTitle:@"买" forState:UIControlStateNormal];
        [_buyBtn addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.titleLabel.font = QDFont(14);
        _buyBtn.tag = 204;
        [_buyBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _buyBtn.layer.borderWidth = 1;
        _buyBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        _buyBtn.layer.cornerRadius = 2;
        _buyBtn.layer.masksToBounds = YES;
        [self addSubview:_buyBtn];
        
        
        _sellBtn = [[UIButton alloc] init];
        _sellBtn.backgroundColor = [UIColor whiteColor];
        [_sellBtn setTitle:@"卖" forState:UIControlStateNormal];
        [_sellBtn addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
        _sellBtn.tag = 205;
        _sellBtn.titleLabel.font = QDFont(14);
        [_sellBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _sellBtn.layer.borderWidth = 1;
        _sellBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        _sellBtn.layer.cornerRadius = 2;
        _sellBtn.layer.masksToBounds = YES;
        [self addSubview:_sellBtn];
        
        _orderStatusLab = [[UILabel alloc] init];
        _orderStatusLab.text = @"摘单状态";
        _orderStatusLab.font = QDFont(14);
        [self addSubview:_orderStatusLab];
        
        _dfkBtn = [[UIButton alloc] init];
        _dfkBtn.backgroundColor = [UIColor whiteColor];
        [_dfkBtn setTitle:@"待付款" forState:UIControlStateNormal];
        [_dfkBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _dfkBtn.titleLabel.font = QDFont(14);
        _dfkBtn.tag = 201;
        [_dfkBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _dfkBtn.layer.borderWidth = 1;
        _dfkBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        _dfkBtn.layer.cornerRadius = 2;
        _dfkBtn.layer.masksToBounds = YES;
        [self addSubview:_dfkBtn];
        
        _ycjBtn = [[UIButton alloc] init];
        _ycjBtn.backgroundColor = [UIColor whiteColor];
        [_ycjBtn setTitle:@"已成交" forState:UIControlStateNormal];
        [_ycjBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _ycjBtn.tag = 202;
        _ycjBtn.titleLabel.font = QDFont(14);
        [_ycjBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _ycjBtn.layer.borderWidth = 1;
        _ycjBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        _ycjBtn.layer.cornerRadius = 2;
        _ycjBtn.layer.masksToBounds = YES;
        [self addSubview:_ycjBtn];
        
        _yqxBtn = [[UIButton alloc] init];
        _yqxBtn.backgroundColor = [UIColor whiteColor];
        [_yqxBtn setTitle:@"已取消" forState:UIControlStateNormal];
        [_yqxBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _yqxBtn.tag = 203;
        _yqxBtn.titleLabel.font = QDFont(14);
        [_yqxBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _yqxBtn.layer.borderWidth = 1;
        _yqxBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        _yqxBtn.layer.cornerRadius = 2;
        _yqxBtn.layer.masksToBounds = YES;
        [self addSubview:_yqxBtn];
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = APP_LIGHTGRAYCOLOR;
        _bottomLine.alpha = 0.5;
        [self addSubview:_bottomLine];
        
        _resetbtn = [[UIButton alloc] init];
        _resetbtn.backgroundColor = APP_WHITECOLOR;
        [_resetbtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetbtn addTarget:self action:@selector(resetAction:) forControlEvents:UIControlEventTouchUpInside];
        [_resetbtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        _resetbtn.titleLabel.font = QDFont(19);
        [self addSubview:_resetbtn];
        
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:APP_WHITECOLOR forState:UIControlStateNormal];
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 58);
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
        [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#159095"] CGColor],(id)[[UIColor colorWithHexString:@"#3CC8B1"] CGColor]]];//渐变数组
        [_confirmBtn.layer addSublayer:gradientLayer];
        _confirmBtn.titleLabel.font= QDFont(19);
        [self addSubview:_confirmBtn];
    }
    return self;
}

#pragma mark - 重置
- (void)resetAction:(UIButton *)sender{
    for (int i = 201; i <= 205; i++) {
        UIButton *btn = [self viewWithTag:i];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        [btn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        btn.selected = NO;
    }
}

#pragma mark - 按钮点击
- (void)btnClick:(UIButton *)sender{
    for (int i = 201; i <= 203; i++) {
        UIButton *btn = [self viewWithTag:i];
        if (btn.tag != sender.tag) {
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
            [btn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
            btn.selected=NO;
        }else{
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = APP_BLUECOLOR.CGColor;
            [btn setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
            btn.selected = YES;
        }
    }
    if (self.sdStatusStatusBlock) {
        NSString *statusStr;
        QDLog(@"text = %@", sender.titleLabel.text);
        if ([sender.titleLabel.text isEqualToString:@"待付款"]) {
            statusStr = @"0";
        }else if ([sender.titleLabel.text isEqualToString:@"已成交"]){
            statusStr = @"1";
        }else if ([sender.titleLabel.text isEqualToString:@"已取消"]){
            statusStr = @"2";
        }
        self.sdStatusStatusBlock(statusStr);
    }
}

#pragma mark - 选择方向
- (void)directionAction:(UIButton *)sender{
    for (int i = 204; i <= 205; i++) {
        UIButton *btn = [self viewWithTag:i];
        if (btn.tag != sender.tag) {
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
            [btn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
            btn.selected=NO;
        }else{
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = APP_BLUECOLOR.CGColor;
            [btn setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
            btn.selected = YES;
        }
    }
    if (self.sdDirectionBlock) {
        NSString *directionStr;
        QDLog(@"text = %@", sender.titleLabel.text);
        if ([sender.titleLabel.text isEqualToString:@"买"]) {
            directionStr = @"0";
        }else if ([sender.titleLabel.text isEqualToString:@"卖"]){
            directionStr = @"1";
        }
        self.sdDirectionBlock(directionStr);
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_direction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(36);
    }];
    
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_direction);
        make.left.equalTo(_direction.mas_right).offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(32);
    }];
    
    [_sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_direction);
        make.left.equalTo(_buyBtn.mas_right).offset(10);
        make.width.and.height.equalTo(_buyBtn);
    }];

    [_orderStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_direction);
        make.top.equalTo(self.mas_top).offset(108);
    }];

    //待付款 已成交 已取消
    [_dfkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_orderStatusLab);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(32);
        make.left.equalTo(_orderStatusLab.mas_right).offset(20);
    }];

    [_ycjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.and.height.equalTo(_dfkBtn);
        make.left.equalTo(_dfkBtn.mas_right).offset(10);
        make.width.mas_equalTo(SCREEN_WIDTH*0.26);
    }];

    [_yqxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.and.height.equalTo(_ycjBtn);
        make.left.equalTo(_ycjBtn.mas_right).offset(10);
    }];

    [_resetbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(58);
    }];

    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_resetbtn);
        make.right.equalTo(self);
        make.width.and.height.equalTo(_resetbtn);
    }];

    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_resetbtn.mas_top);
        make.left.and.width.equalTo(self);
        make.height.mas_equalTo(@1);
    }];
}

- (void)setUpTextFieldWithHolderStr:(UITextField *)textField andHolderStr:(NSString *)holderStr{
    textField.font = QDFont(14);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:holderStr attributes:@{NSForegroundColorAttributeName:APP_GRAYCOLOR,NSFontAttributeName:QDFont(14), NSParagraphStyleAttributeName:style}];
    textField.attributedPlaceholder = attri;
    textField.layer.borderColor = APP_BLUECOLOR.CGColor;
    [textField setValue:QDFont(14) forKeyPath:@"_placeholderLabel.font"];
    textField.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
}

@end
