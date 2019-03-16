//
//  QDVipPurchaseView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/17.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDVipPurchaseView.h"

@implementation QDVipPurchaseView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _returnBtn = [[UIButton alloc] init];
        [_returnBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        [self addSubview:_returnBtn];
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"会员申购";
        _titleLab.textColor = APP_BLACKCOLOR;
        _titleLab.font = QDFont(17);
        [self addSubview:_titleLab];
        
        _picView = [[UIImageView alloc] init];
        _picView.image = [UIImage imageNamed:@"icon_headerPic"];
        _picView.layer.cornerRadius = SCREEN_WIDTH*0.065;
        _picView.layer.masksToBounds = YES;
        [self addSubview:_picView];
        
        _info1Lab = [[UILabel alloc] init];
        _info1Lab.text = @"您当前是";
        _info1Lab.textColor = APP_GRAYLINECOLOR;
        _info1Lab.font = QDFont(11);
        [self addSubview:_info1Lab];
        
        _info2Lab = [[UILabel alloc] init];
        _info2Lab.text = @"白金会员";
        _info2Lab.textColor = APP_BLACKCOLOR;
        _info2Lab.font = QDBoldFont(17);
        [self addSubview:_info2Lab];
        
        _info3Lab = [[UILabel alloc] init];
        _info3Lab.text = @"升级还需";
        _info3Lab.textColor = APP_GRAYLINECOLOR;
        _info3Lab.font = QDFont(13);
        [self addSubview:_info3Lab];
        
        _info4Lab = [[UILabel alloc] init];
        _info4Lab.text = @"75";
        _info4Lab.textColor = APP_BLUECOLOR;
        _info4Lab.font = QDFont(13);
        [self addSubview:_info4Lab];
        
        _info5Lab = [[UILabel alloc] init];
        _info5Lab.text = @"成长值";
        _info5Lab.textColor = APP_GRAYLINECOLOR;
        _info5Lab.font = QDFont(13);
        [self addSubview:_info5Lab];
        
        _leftCircleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_circleImg"]];
        [self addSubview:_leftCircleImg];
        
        _rightCircleImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_circleImg"]];
        [self addSubview:_rightCircleImg];
        
        _progressView = [[MQGradientProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.56, 2)];
        _progressView.colorArr = @[(id)[UIColor colorWithHexString:@"#3CC8B1"].CGColor,(id)[UIColor colorWithHexString:@"#159095"].CGColor];

        [self addSubview:_progressView];
        
        _leftLevelLab = [[UILabel alloc] init];
        _leftLevelLab.text = @"LV5";
        _leftLevelLab.textColor = APP_BLACKCOLOR;
        _leftLevelLab.font = QDBoldFont(12);
        [self addSubview:_leftLevelLab];
        
        _leftLevel = [[UILabel alloc] init];
        _leftLevel.text = @"(425)";
        _leftLevel.textColor = APP_GRAYTEXTCOLOR;
        _leftLevel.font = QDFont(11);
        [self addSubview:_leftLevel];
        
        _rightLevelLab = [[UILabel alloc] init];
        _rightLevelLab.text = @"LV6";
        _rightLevelLab.textColor = APP_BLACKCOLOR;
        _rightLevelLab.font = QDBoldFont(12);
        [self addSubview:_rightLevelLab];
        
        _rightLevel = [[UILabel alloc] init];
        _rightLevel.text = @"(500)";
        _rightLevel.textColor = APP_GRAYTEXTCOLOR;
        _rightLevel.font = QDFont(11);
        [self addSubview:_rightLevel];
        
        _priceTextLab = [[UILabel alloc] init];
        _priceTextLab.text = @"金额";
        _priceTextLab.textColor = APP_GRAYLINECOLOR;
        _priceTextLab.font = QDFont(14);
        [self addSubview:_priceTextLab];
        
        _priceLab = [[UILabel alloc] init];
        _priceLab.text = @"¥";
        _priceLab.textColor = APP_BLACKCOLOR;
        _priceLab.font = QDBoldFont(18);
        [self addSubview:_priceLab];
        
        _price = [[UILabel alloc] init];
        _price.text = @"3000";
        _price.textColor = APP_BLACKCOLOR;
        _price.font = QDBoldFont(24);
        [self addSubview:_price];
        
        _priceTF = [[UITextField alloc] init];
        _priceTF.placeholder = @"请输入金额";
        [_priceTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _priceTF.clearButtonMode = UITextFieldViewModeAlways;
        _priceTF.keyboardType = UIKeyboardTypeDecimalPad;
        _priceTF.hidden = YES;
        [_priceTF setValue:APP_GRAYLINECOLOR forKeyPath:@"placeholderLabel.textColor"];
        [_priceTF setValue:QDFont(24) forKeyPath:@"_placeholderLabel.font"];
        [self addSubview:_priceTF];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = APP_LIGHTGRAYCOLOR;
        [self addSubview:_lineView];
        
        _bottomLab1 = [[UILabel alloc] init];
        _bottomLab1.text = @"折合玩贝";
        _bottomLab1.font = QDFont(14);
        _bottomLab1.textColor = APP_GRAYTEXTCOLOR;
        [self addSubview:_bottomLab1];
        
        
        _bottomLab2 = [[UILabel alloc] init];
        _bottomLab2.text = @"";
        _bottomLab2.font = QDFont(14);
        _bottomLab2.textColor = APP_GRAYTEXTCOLOR;
        [self addSubview:_bottomLab2];
        
//        _bottomLab3 = [[UILabel alloc] init];
//        _bottomLab3.text = @"+0";
//        _bottomLab3.font = QDFont(14);
//        _bottomLab3.textColor = APP_BLUECOLOR;
//        [self addSubview:_bottomLab3];
        
        _bottomLab4 = [[UILabel alloc] init];
        _bottomLab4.text = @"个";
        _bottomLab4.font = QDFont(14);
        _bottomLab4.textColor = APP_GRAYTEXTCOLOR;
        [self addSubview:_bottomLab4];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.06);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.02);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(_returnBtn);
    }];
    
    [_picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.05);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.10);
        make.width.mas_equalTo(SCREEN_WIDTH*0.13);
        make.height.mas_equalTo(SCREEN_WIDTH*0.13);
    }];
    
    [_info1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.26);
        make.top.equalTo(_picView);
    }];

    [_info2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_info1Lab);
        make.top.equalTo(_info1Lab.mas_bottom);
    }];

    [_info3Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_info2Lab);
        make.left.equalTo(_info2Lab.mas_right).offset(SCREEN_WIDTH*0.01);
    }];

    [_info4Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_info3Lab);
        make.left.equalTo(_info3Lab.mas_right);
    }];

    [_info5Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_info4Lab);
        make.left.equalTo(_info4Lab.mas_right);
    }];

    [_leftCircleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.26);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.18);
    }];

    [_rightCircleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftCircleImg);
        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.14));
    }];

    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftCircleImg);
        make.left.equalTo(_leftCircleImg.mas_centerX);
        make.right.equalTo(_rightCircleImg.mas_centerX);
        make.height.mas_equalTo(2);
    }];

    [_leftLevelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftCircleImg.mas_bottom).offset(SCREEN_HEIGHT*0.01);
        make.left.equalTo(_leftCircleImg);
    }];

    [_leftLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftLevelLab);
        make.left.equalTo(_leftLevelLab.mas_right);
    }];

    [_rightLevelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_leftLevelLab);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.79);
    }];

    [_rightLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_rightLevelLab);
        make.left.equalTo(_rightLevelLab.mas_right);
    }];

    [_priceTextLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.05);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.8);
    }];

    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceTextLab);
        make.top.equalTo(_priceTextLab.mas_bottom).offset(8);
    }];

    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLab);
        make.left.equalTo(_priceLab.mas_right).offset(2);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_price.mas_bottom).offset(7);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(1);
    }];

    [_priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLab);
        make.left.equalTo(_priceLab.mas_right).offset(5);
        make.right.equalTo(_lineView);
    }];
    
    [_bottomLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineView.mas_bottom).offset(10);
        make.left.equalTo(_lineView);
    }];
    
    [_bottomLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomLab1);
        make.left.equalTo(_bottomLab1.mas_right).offset(5);
    }];
    
//    [_bottomLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_bottomLab1);
//        make.left.equalTo(_bottomLab2.mas_right).offset(1);
//    }];

    [_bottomLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomLab1);
        make.left.equalTo(_bottomLab2.mas_right).offset(1);
    }];
}

- (void)textFieldChanged:(UITextField *)textField{
    _bottomLab2.text = [NSString stringWithFormat:@"%.lf", [_priceTF.text doubleValue] / _basePrice];
}
@end
