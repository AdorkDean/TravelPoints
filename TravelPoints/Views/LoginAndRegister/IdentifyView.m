//
//  IdentifyView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/15.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "IdentifyView.h"

@implementation IdentifyView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _identifyLab = [[UILabel alloc] init];
        _identifyLab.text = @"验证身份，请输入图中验证码";
        _identifyLab.font = QDFont(22);
        [self addSubview:_identifyLab];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#50C533"];
        [self addSubview:_lineView];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor redColor];
        [self addSubview:_imgView];
        
        _refreshBtn = [[UIButton alloc] init];
        [_refreshBtn setTitle:@"看不清? 点击刷新" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:[UIColor colorWithHexString:@"CCCCCC"] forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font = QDFont(13);
        [self addSubview:_refreshBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_identifyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_top).offset(SCREEN_HEIGHT*0.156);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.identifyLab);
        make.top.equalTo(self.identifyLab.mas_bottom).offset(SCREEN_HEIGHT*0.012);
        make.width.mas_equalTo(SCREEN_WIDTH*0.097);
        make.height.mas_equalTo(SCREEN_WIDTH*0.01);
    }];

    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.lineView.mas_bottom).offset(SCREEN_HEIGHT*0.06);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.067);
        make.width.mas_equalTo(SCREEN_WIDTH*0.53);
    }];

    [_refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgView);
        make.top.equalTo(self.imgView.mas_bottom).offset(SCREEN_HEIGHT*0.022);
    }];
}

@end
