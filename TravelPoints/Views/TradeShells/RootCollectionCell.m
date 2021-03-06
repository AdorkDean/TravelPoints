//
//  TestCollectionCell.m
//  DKSTableCollcetionView
//
//  Created by aDu on 2017/10/10.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import "RootCollectionCell.h"

@interface RootCollectionCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation RootCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.text = @"¥";
        _priceLab.font = QDBoldFont(18);
        _priceLab.textColor = APP_ORANGETEXTCOLOR;
        [self.contentView addSubview:_priceLab];

        _price = [[UILabel alloc] init];
        _price.text = @"34.00";
        _price.font = QDBoldFont(24);
        _price.textColor = APP_ORANGETEXTCOLOR;
        [self.contentView addSubview:_price];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = APP_LIGHTGRAYCOLOR;
        _lineView.alpha = 0.4;
        [self.contentView addSubview:_lineView];
        
        _headPic = [[UIImageView alloc] init];
        _headPic.image = [UIImage imageNamed:@"icon_headerPic"];
        _headPic.layer.cornerRadius = SCREEN_WIDTH*0.03;
        _headPic.layer.masksToBounds = YES;
        [self.contentView addSubview:_headPic];

        _nameLab = [[UILabel alloc] init];
        _nameLab.text = @"四叶草8766";
        _nameLab.font = QDFont(12);
        [self.contentView addSubview:_nameLab];
        
        _amountLab = [[UILabel alloc] init];
        _amountLab.text = @"数量";
        _amountLab.font = QDFont(12);
        _amountLab.textColor = APP_GRAYLINECOLOR;
        [self.contentView addSubview:_amountLab];
        
        _amount = [[UILabel alloc] init];
        _amount.text = @"1000";
        _amount.font = QDFont(12);
        _amount.textColor = APP_BLUECOLOR;
        [self.contentView addSubview:_amount];
        
        _statusLab = [[UILabel alloc] init];
        _statusLab.text = @"可部分成交";
        _statusLab.textColor = APP_BLUECOLOR;
        _statusLab.font = QDFont(12);
        [self.contentView addSubview:_statusLab];
        
        _sell = [[UIButton alloc] init];
        _sell.backgroundColor = APP_GRAYBUTTONCOLOR;
        [_sell setTitle:@"购买" forState:UIControlStateNormal];
        [_sell setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        _sell.titleLabel.font = QDBoldFont(16);
        _sell.layer.cornerRadius = 4;
        _sell.layer.masksToBounds = YES;
        [self.contentView addSubview:_sell];
        
        //shadowColor阴影颜色
        self.contentView.layer.cornerRadius = 6;
        self.layer.shadowColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
        self.contentView.backgroundColor = APP_WHITECOLOR;
        //shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOffset = CGSizeMake(0,0);
        
        //阴影透明度，默认0
        self.layer.shadowOpacity = 1;
        
        //阴影半径，默认3
        self.layer.shadowRadius = 3;
        
        //路径阴影(借助贝塞尔曲线)
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        float width = self.bounds.size.width;
        float height = self.bounds.size.height;
        float x = self.bounds.origin.x;
        float y = self.bounds.origin.y;
        float addWH = 10;
        
        CGPoint topLeft      = self.bounds.origin;
        CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
        CGPoint topRight     = CGPointMake(x+width,y);
        
        CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
        
        CGPoint bottomRight  = CGPointMake(x+width,y+height);
        CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
        CGPoint bottomLeft   = CGPointMake(x,y+height);
        
        
        CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
        
        [path moveToPoint:topLeft];
        //添加四个二元曲线
        [path addQuadCurveToPoint:topRight
                     controlPoint:topMiddle];
        [path addQuadCurveToPoint:bottomRight
                     controlPoint:rightMiddle];
        [path addQuadCurveToPoint:bottomLeft
                     controlPoint:bottomMiddle];
        [path addQuadCurveToPoint:topLeft
                     controlPoint:leftMiddle];
        //设置阴影路径
        self.layer.shadowPath = path.CGPath;

    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [_headPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.and.height.mas_equalTo(18);
    }];
    
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headPic);
        make.left.equalTo(_headPic.mas_right).offset(5);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headPic.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(1);
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(75);
    }];
    
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLab.mas_right);
        make.bottom.equalTo(_priceLab);
    }];
    
    [_amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(111);
    }];
    
    [_amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_amountLab);
        make.top.equalTo(_amountLab.mas_bottom);
    }];
    
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_amount);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [_sell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(36);
    }];
}

- (void)loadDataWithDataArr:(BiddingPostersDTO *)infoModel andTypeStr:(NSString *)str{
    self.nameLab.text = infoModel.userId;
    self.price.text = infoModel.price;
    self.amount.text = infoModel.surplusVolume;
    if ([str isEqualToString:@"1"]) {
        [self.sell setTitle:@"买入" forState:UIControlStateNormal];
    }else{
        [self.sell setTitle:@"卖出" forState:UIControlStateNormal];
    }
    if ([infoModel.isPartialDeal isEqualToString:@"0"]) {
        self.statusLab.text = @"不可部分成交";
        self.statusLab.textColor = APP_GRAYLINECOLOR;
    }else{
        self.statusLab.text = @"可部分成交";
        self.statusLab.textColor = APP_BLUECOLOR;
    }
}
@end
