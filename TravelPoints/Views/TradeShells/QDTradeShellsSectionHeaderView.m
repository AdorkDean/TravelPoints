//
//  QDTradeShellsSectionHeaderView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/15.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDTradeShellsSectionHeaderView.h"

@implementation QDTradeShellsSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _amountBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
        [_amountBtn setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
        [_amountBtn setTitle:@"数量" forState:UIControlStateNormal];
        [_amountBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        _amountBtn.titleLabel.font = QDFont(13);
        [self addSubview:_amountBtn];
        
        _priceBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
        [_priceBtn setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
        [_priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        [_priceBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        _priceBtn.titleLabel.font = QDFont(13);
        [self addSubview:_priceBtn];
        
        _filterBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
        [_filterBtn setImage:[UIImage imageNamed:@"icon_filter"] forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = QDFont(13);
        [_filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [_filterBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        [self addSubview:_filterBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_amountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.05);
    }];
    
    [_priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.25);
    }];
    
    [_filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.81);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
