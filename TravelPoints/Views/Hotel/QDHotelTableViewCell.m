//
//  QDHotelTableViewCell.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/17.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDHotelTableViewCell.h"

@implementation QDHotelTableViewCell

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
        _hotelImg = [[UIImageView alloc] init];
        _hotelImg.image = [UIImage imageNamed:@"hotel"];
        [self.contentView addSubview:_hotelImg];
        
        _hotelName = [[UILabel alloc] init];
        _hotelName.text = @"路易斯湖费尔蒙酒店";
        _hotelName.font = QDBoldFont(17);
        [self.contentView addSubview:_hotelName];
        
        _starLab = [[UILabel alloc] init];
        _starLab.text = @"66人收藏";
        _starLab.font = QDFont(12);
        _starLab.textColor = APP_GRAYCOLOR;
        [self.contentView addSubview:_starLab];
        
        _priceLab = [[UILabel alloc] init];
        _priceLab.text = @"588FT 起";
        _priceLab.font = QDBoldFont(15);
        _priceLab.textColor = APP_GREENCOLOR;
        [self.contentView addSubview:_priceLab];
        
        _priceRMBLab = [[UILabel alloc] init];
        _priceRMBLab.text = @"折合人民币500元";
        _priceRMBLab.font = QDBoldFont(15);
        _priceRMBLab.textColor = APP_GRAYCOLOR;
        [self.contentView addSubview:_priceRMBLab];
        
        _locationLab = [[UILabel alloc] init];
        _locationLab.text = @"陆家嘴 | 浦东新区";
        _locationLab.font = QDBoldFont(15);
        _locationLab.textColor = APP_GRAYCOLOR;
        [self.contentView addSubview:_locationLab];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_hotelImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(SCREEN_WIDTH*0.054);
        make.width.mas_equalTo(SCREEN_WIDTH*0.35);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.165);
    }];
    
    [_hotelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(SCREEN_HEIGHT*0.036);
        make.left.equalTo(self.hotelImg.mas_right).offset(SCREEN_WIDTH*0.037);
    }];
    [_starLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hotelName.mas_bottom).offset(SCREEN_HEIGHT*0.01);
        make.left.equalTo(self.hotelName);
    }];

    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starLab.mas_bottom).offset(SCREEN_HEIGHT*0.01);
        make.left.equalTo(self.hotelName);
    }];

    [_priceRMBLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.priceLab);
        make.left.equalTo(self.priceLab.mas_right).offset(SCREEN_HEIGHT*0.01);
    }];

    [_locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLab.mas_bottom).offset(SCREEN_HEIGHT*0.01);
        make.left.equalTo(self.hotelName);
    }];
}

@end
