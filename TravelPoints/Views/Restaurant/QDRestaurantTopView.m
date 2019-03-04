//
//  QDRestaurantTopView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/19.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDRestaurantTopView.h"

@implementation QDRestaurantTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _backView = [[UIView alloc] init];
        _backView.layer.borderWidth = 1.0f;
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.borderColor = APP_GRAYCOLOR.CGColor;
        [self addSubview:_backView];
        
        _cityBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
        [_cityBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        [_cityBtn setTitle:@"上海" forState:UIControlStateNormal];
        [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backView addSubview:_cityBtn];
        
        _locationTF = [[UITextField alloc] init];
        _locationTF.placeholder = @"请输入城市或景点";
        [_locationTF setValue:APP_LIGHTGRAYCOLOR forKeyPath:@"_placeholderLabel.textColor"];
        [_locationTF setValue:QDFont(16) forKeyPath:@"_placeholderLabel.font"];
        [_backView addSubview:_locationTF];
        
        _searchBtn = [[UIButton alloc] init];
        [_searchBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        [_backView addSubview:_searchBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(22);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.048);
    }];
    
    [_cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backView);
        make.left.equalTo(self.backView.mas_left).offset(SCREEN_WIDTH*0.053);
    }];
    
    [_locationTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.height.equalTo(self.backView);
        make.left.equalTo(self.backView.mas_left).offset(SCREEN_WIDTH*0.22);
    }];
    
    [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.height.equalTo(self.backView);
        make.right.equalTo(self.backView.mas_right).offset(-(SCREEN_WIDTH*0.045));
    }];
}

@end
