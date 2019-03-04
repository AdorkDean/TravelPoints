//
//  QDFilterTypeOneView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/15.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDFilterTypeOneView.h"

@implementation QDFilterTypeOneView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.text = @"价格区间(元)";
        _priceLab.font = QDFont(13);
        [self addSubview:_priceLab];
        
        _lowPrice = [[UITextField alloc] init];
        [self setUpTextFieldWithHolderStr:_lowPrice andHolderStr:@"最低价"];
        [self addSubview:_lowPrice];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = APP_BLACKCOLOR;
        [self addSubview:_lineView];
        
        _hightPrice = [[UITextField alloc] init];
        [self setUpTextFieldWithHolderStr:_hightPrice andHolderStr:@"最高价"];
        [self addSubview:_hightPrice];
        
        _amountLab = [[UILabel alloc] init];
        _amountLab.text = @"数量区间(个)";
        _amountLab.font = QDFont(13);
        [self addSubview:_amountLab];
        
        _lowAmount = [[UITextField alloc] init];
        [self setUpTextFieldWithHolderStr:_lowAmount andHolderStr:@"最小量"];
        [self addSubview:_lowAmount];
        
        _lineViewT = [[UIView alloc] init];
        _lineViewT.backgroundColor = APP_BLACKCOLOR;
        [self addSubview:_lineViewT];
        
        _hightAmount = [[UITextField alloc] init];
        [self setUpTextFieldWithHolderStr:_hightAmount andHolderStr:@"最大量"];
        [self addSubview:_hightAmount];
        
        _infoLab = [[UILabel alloc] init];
        _infoLab.text = @"是否部分成交";
        _infoLab.font = QDFont(13);
        [self addSubview:_infoLab];
        
        _yesBtn = [[UIButton alloc] init];
        _yesBtn.backgroundColor = [UIColor whiteColor];
        [_yesBtn setTitle:@"是" forState:UIControlStateNormal];
        _yesBtn.titleLabel.font = QDFont(13);
        [_yesBtn setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        _yesBtn.layer.borderWidth = 1;
        _yesBtn.layer.borderColor = APP_BLUECOLOR.CGColor;
        [self addSubview:_yesBtn];
        
        _noBtn = [[UIButton alloc] init];
        _noBtn.backgroundColor = [UIColor whiteColor];
        [_noBtn setTitle:@"否" forState:UIControlStateNormal];
        _noBtn.titleLabel.font = QDFont(13);
        [_noBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        _noBtn.layer.borderWidth = 1;
        _noBtn.layer.borderColor = APP_GRAYCOLOR.CGColor;
        [self addSubview:_noBtn];
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = APP_LIGHTGRAYCOLOR;
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
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.05);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.05);
    }];
    
    [_lowPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceLab);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.33);
        make.width.mas_equalTo(SCREEN_WIDTH*0.26);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lowPrice);
        make.left.equalTo(_lowPrice.mas_right).offset(SCREEN_WIDTH*0.027);
        make.width.mas_equalTo(SCREEN_WIDTH*0.04);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.003);
    }];
    
    [_hightPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lowPrice);
        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.06));
        make.width.mas_equalTo(SCREEN_WIDTH*0.26);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
    }];
    
    [_amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.05);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.17);
    }];
    
    [_lowAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_amountLab);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.33);
        make.width.mas_equalTo(SCREEN_WIDTH*0.26);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
    }];
    
    [_lineViewT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lowAmount);
        make.left.equalTo(_lowAmount.mas_right).offset(SCREEN_WIDTH*0.027);
        make.width.mas_equalTo(SCREEN_WIDTH*0.04);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.003);
    }];
    
    [_hightAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lowAmount);
        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.06));
        make.width.mas_equalTo(SCREEN_WIDTH*0.26);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
    }];
    
    [_infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_amountLab);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.28);
    }];
    
    [_yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lowPrice);
        make.centerY.equalTo(_infoLab);
        make.width.mas_equalTo(SCREEN_WIDTH*0.16);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
    }];
    
    [_noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.57);
        make.centerY.width.and.height.equalTo(_yesBtn);
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
