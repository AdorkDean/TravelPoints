//
//  QDFilterTypeTwoView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDFilterTypeTwoView.h"

@implementation QDFilterTypeTwoView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _direction = [[UILabel alloc] init];
        _direction.text = @"买卖方向";
        _direction.font = QDFont(13);
        [self addSubview:_direction];
        
        _buyBtn = [[UIButton alloc] init];
        _buyBtn.backgroundColor = [UIColor whiteColor];
        [_buyBtn setTitle:@"买" forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = QDFont(13);
        [_buyBtn setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        _buyBtn.layer.borderWidth = 1;
        _buyBtn.layer.borderColor = APP_BLUECOLOR.CGColor;
        [self addSubview:_buyBtn];
        
        
        _sellBtn = [[UIButton alloc] init];
        _sellBtn.backgroundColor = [UIColor whiteColor];
        [_sellBtn setTitle:@"卖" forState:UIControlStateNormal];
        _sellBtn.titleLabel.font = QDFont(13);
        [_sellBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _sellBtn.layer.borderWidth = 1;
        _sellBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        [self addSubview:_sellBtn];
        
        _orderStatusLab = [[UILabel alloc] init];
        _orderStatusLab.text = @"报单状态";
        _orderStatusLab.font = QDFont(13);
        [self addSubview:_orderStatusLab];
        
        _wcjBtn = [[UIButton alloc] init];
        _wcjBtn.backgroundColor = [UIColor whiteColor];
        [_wcjBtn setTitle:@"未成交" forState:UIControlStateNormal];
        _wcjBtn.titleLabel.font = QDFont(13);
        [_wcjBtn setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        _wcjBtn.layer.borderWidth = 1;
        _wcjBtn.layer.borderColor = APP_BLUECOLOR.CGColor;
        [self addSubview:_wcjBtn];
        
        _bfcjBtn = [[UIButton alloc] init];
        _bfcjBtn.backgroundColor = [UIColor whiteColor];
        [_bfcjBtn setTitle:@"部分成交" forState:UIControlStateNormal];
        _bfcjBtn.titleLabel.font = QDFont(13);
        [_bfcjBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _bfcjBtn.layer.borderWidth = 1;
        _bfcjBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        [self addSubview:_bfcjBtn];
        
        _qbcjBtn = [[UIButton alloc] init];
        _qbcjBtn.backgroundColor = [UIColor whiteColor];
        [_qbcjBtn setTitle:@"全部成交" forState:UIControlStateNormal];
        _qbcjBtn.titleLabel.font = QDFont(13);
        [_qbcjBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _qbcjBtn.layer.borderWidth = 1;
        _qbcjBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        [self addSubview:_qbcjBtn];
        
        _yqxBtn = [[UIButton alloc] init];
        _yqxBtn.backgroundColor = [UIColor whiteColor];
        [_yqxBtn setTitle:@"已取消" forState:UIControlStateNormal];
        _yqxBtn.titleLabel.font = QDFont(13);
        [_yqxBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _yqxBtn.layer.borderWidth = 1;
        _yqxBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        [self addSubview:_yqxBtn];
        
        _qbcxBtn = [[UIButton alloc] init];
        _qbcxBtn.backgroundColor = [UIColor whiteColor];
        [_qbcxBtn setTitle:@"全部撤销" forState:UIControlStateNormal];
        _qbcxBtn.titleLabel.font = QDFont(13);
        [_qbcxBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _qbcxBtn.layer.borderWidth = 1;
        _qbcxBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        [self addSubview:_qbcxBtn];
        
        _bcbcBtn = [[UIButton alloc] init];
        _bcbcBtn.backgroundColor = [UIColor whiteColor];
        [_bcbcBtn setTitle:@"部分成交部分撤销" forState:UIControlStateNormal];
        _bcbcBtn.titleLabel.font = QDFont(13);
        [_bcbcBtn setTitleColor:APP_GRAYBUTTONTEXTCOLOR forState:UIControlStateNormal];
        _bcbcBtn.layer.borderWidth = 1;
        _bcbcBtn.layer.borderColor = APP_GRAYLAYERCOLOR.CGColor;
        [self addSubview:_bcbcBtn];
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = APP_LIGHTGRAYCOLOR;
        _bottomLine.alpha = 0.5;
        [self addSubview:_bottomLine];
        
        _resetbtn = [[UIButton alloc] init];
        _resetbtn.backgroundColor = APP_WHITECOLOR;
        [_resetbtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetbtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        _resetbtn.titleLabel.font = QDFont(19);
        [self addSubview:_resetbtn];
        
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:APP_WHITECOLOR forState:UIControlStateNormal];
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.087);
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

- (void)layoutSubviews{
    [super layoutSubviews];
    [_direction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.05);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.05);
    }];
    
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_direction);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.26);
        make.width.mas_equalTo(SCREEN_WIDTH*0.16);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
    }];
    
    [_sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.and.height.equalTo(_direction);
        make.left.equalTo(_buyBtn.mas_right).offset(SCREEN_WIDTH*0.08);
    }];
    
    [_orderStatusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_direction);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.16);
    }];
    
    [_wcjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.height.equalTo(_orderStatusLab);
        make.width.mas_equalTo(SCREEN_WIDTH*0.21);
        make.left.equalTo(_buyBtn);
    }];
    
    [_bfcjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.and.height.equalTo(_wcjBtn);
        make.left.equalTo(_sellBtn);
        make.width.mas_equalTo(SCREEN_WIDTH*0.26);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
    }];
    
    [_qbcjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.and.height.equalTo(_bfcjBtn);
        make.left.equalTo(_bfcjBtn.mas_right).offset(SCREEN_WIDTH*0.02);
    }];
    
    [_yqxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_wcjBtn.mas_bottom).offset(SCREEN_HEIGHT*0.02);
        make.left.width.and.height.equalTo(_wcjBtn);
    }];
    
    [_qbcxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_yqxBtn);
        make.left.width.and.height.equalTo(_bfcjBtn);
    }];
    
    [_bcbcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yqxBtn.mas_bottom).offset(SCREEN_HEIGHT*0.02);
        make.left.and.height.equalTo(_wcjBtn);
        make.width.mas_equalTo(SCREEN_WIDTH*0.45);
    }];
    
    [_resetbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.087);
    }];
    
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-(SCREEN_HEIGHT*0.09));
        make.left.equalTo(_resetbtn.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH/2);
        make.height.equalTo(_resetbtn);
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
    [textField setValue:QDFont(13) forKeyPath:@"_placeholderLabel.font"];
    textField.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
}

@end
