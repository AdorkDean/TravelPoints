//
//  QDPickUpOrderCell.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDPickUpOrderCell.h"

@implementation QDPickUpOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.shadowColor = APP_GRAYLINECOLOR.CGColor;
        // 阴影偏移，默认(0, -3)
        _backView.layer.shadowOffset = CGSizeMake(2,3);
        // 阴影透明度，默认0
        _backView.layer.shadowOpacity = 3;
        // 阴影半径，默认3
        _backView.layer.shadowRadius = 2;
        [self.contentView addSubview:_backView];
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [self.contentView addSubview:_shadowView];
        
        _operationTypeLab = [[UILabel alloc] init];
        _operationTypeLab.text = @"卖出";
        _operationTypeLab.font = QDFont(13);
        [_shadowView addSubview:_operationTypeLab];
        
        _statusLab = [[UILabel alloc] init];
        _statusLab.text = @"部分成交";
        _statusLab.textColor = APP_BLUECOLOR;
        _statusLab.font = QDFont(13);
        [_shadowView addSubview:_statusLab];
        
        _totalPriceLab = [[UILabel alloc] init];
        _totalPriceLab.text = @"金额(元)";
        _totalPriceLab.textColor = APP_GRAYTEXTCOLOR;
        _totalPriceLab.font = QDFont(12);
        [_backView addSubview:_totalPriceLab];
        
        _totalPrice = [[UILabel alloc] init];
        _totalPrice.text = @"¥15,000.00";
        _totalPrice.textColor = APP_BLUECOLOR;
        _totalPrice.font = QDBoldFont(15);
        [_backView addSubview:_totalPrice];
        
        _amountLab = [[UILabel alloc] init];
        _amountLab.text = @"数量1000";
        _amountLab.font = QDFont(12);
        _amountLab.textColor = APP_GRAYTEXTCOLOR;
        [_backView addSubview:_amountLab];
        
        _priceLab = [[UILabel alloc] init];
        _priceLab.text = @"价格¥15.00";
        _priceLab.font = QDFont(12);
        _priceLab.textColor = APP_GRAYTEXTCOLOR;
        
        [_backView addSubview:_priceLab];
        
        _dealAmountLab = [[UILabel alloc] init];
        _dealAmountLab.text = @"成交(个)";
        _dealAmountLab.textColor = APP_GRAYTEXTCOLOR;
        _dealAmountLab.font = QDFont(12);
        [_backView addSubview:_dealAmountLab];
        
        _dealAmount = [[UILabel alloc] init];
        _dealAmount.text = @"200";
        _dealAmount.font = QDBoldFont(15);
        _dealAmount.textColor = APP_BLUECOLOR;
        [_backView addSubview:_dealAmount];
        
        _transferLab = [[UILabel alloc] init];
        _transferLab.text = @"手续费¥100.00";
        _transferLab.font = QDFont(12);
        _transferLab.textColor = APP_GRAYTEXTCOLOR;
        [_backView addSubview:_transferLab];
        
        _centerLine = [[UIView alloc] init];
        _centerLine.backgroundColor = APP_GRAYLINECOLOR;
        _centerLine.alpha = 0.2;
        [_backView addSubview:_centerLine];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(SCREEN_HEIGHT*0.02);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-(SCREEN_HEIGHT*0.02));
        make.left.equalTo(self.contentView.mas_left).offset(SCREEN_WIDTH*0.05);
        make.right.equalTo(self.contentView.mas_right).offset(-(SCREEN_WIDTH*0.05));
    }];
    
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(_backView);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.04);
    }];
    
    [_operationTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shadowView);
        make.left.equalTo(_shadowView.mas_left).offset(SCREEN_WIDTH*0.04);
    }];
    
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_shadowView);
        make.right.equalTo(_shadowView.mas_right).offset(-(SCREEN_WIDTH*0.04));
    }];
    
    [_totalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shadowView.mas_bottom).offset(SCREEN_HEIGHT*0.03);
        make.left.equalTo(_operationTypeLab);
    }];
    
    [_totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalPriceLab.mas_bottom).offset(SCREEN_HEIGHT*0.015);
        make.left.equalTo(_operationTypeLab);
    }];
    
    [_amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_totalPrice.mas_bottom).offset(SCREEN_HEIGHT*0.015);
        make.left.equalTo(_operationTypeLab);
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_amountLab);
        make.left.equalTo(_backView.mas_left).offset(SCREEN_WIDTH*0.19);
    }];
    
    [_centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView);
        make.top.equalTo(_shadowView.mas_bottom).offset(SCREEN_HEIGHT*0.03);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.07);
    }];
    
    [_dealAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_totalPriceLab);
        make.left.equalTo(_centerLine.mas_left).offset(SCREEN_WIDTH*0.04);
    }];
    
    [_dealAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_totalPrice);
        make.left.equalTo(_dealAmountLab);
    }];
    
    [_transferLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_amountLab);
        make.left.equalTo(_dealAmount.mas_left);
    }];
}

- (void)loadSaleDataWithModel:(QDMyPickOrderModel *)model{
    
}

@end
