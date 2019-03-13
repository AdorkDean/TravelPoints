//
//  QDMallTableHeaderView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/19.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDMallTableHeaderView.h"

@implementation QDMallTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = APP_GRAYLINECOLOR;
        _topLineView.alpha = 0.5;
        [self addSubview:_topLineView];
        
        _topBackView = [[UIView alloc] init];
        _topBackView.backgroundColor = [UIColor colorWithHexString:@"#EEF3F6"];
        _topBackView.layer.masksToBounds = YES;
        _topBackView.layer.cornerRadius = 8;
        [self addSubview:_topBackView];
        
        _imgView = [[UIImageView alloc] init];
        [_imgView setImage:[UIImage imageNamed:@"icon_search"]];
        [_topBackView addSubview:_imgView];
        
        
        _inputTF = [[UITextField alloc] init];
        _inputTF.placeholder = @"搜索关键字";
        [_inputTF setValue:APP_GRAYLINECOLOR forKeyPath:@"_placeholderLabel.textColor"];
        [_inputTF setValue:QDFont(14) forKeyPath:@"_placeholderLabel.font"];
        _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_topBackView addSubview:_inputTF];
        
        _carBtn = [[UIButton alloc] init];
        [_carBtn setImage:[UIImage imageNamed:@"icon_shopCar"] forState:UIControlStateNormal];
        _carBtn.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
        _carBtn.layer.cornerRadius = 4;
        _carBtn.layer.masksToBounds = YES;
        [self addSubview:_carBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.05);
        make.width.mas_equalTo(SCREEN_WIDTH*0.73);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.05);
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBackView);
        make.left.equalTo(self.topBackView.mas_left).offset(SCREEN_WIDTH*0.04);
    }];
    
    [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topBackView);
        make.left.equalTo(self.imgView.mas_right).offset(SCREEN_WIDTH*0.02);
        make.right.equalTo(self.topBackView);
    }];
    
    [_carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.05));
    }];
}

@end