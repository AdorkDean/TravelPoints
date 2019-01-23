//
//  QDRestaurantViewCell.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/19.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDRestaurantViewCell.h"

@implementation QDRestaurantViewCell

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
        _thePic = [[UIImageView alloc] init];
        _thePic.image = [UIImage imageNamed:@"test"];
        [self.contentView addSubview:_thePic];
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"上海3天2日游住一晚拈花小镇";
        _titleLab.font = QDBoldFont(17);
        [self.contentView addSubview:_titleLab];
        
        _ftLab = [[UILabel alloc] init];
        _ftLab.text = @"588FT";
        _ftLab.font = QDFont(15);
        _ftLab.textColor = APP_GREENCOLOR;
        [self.contentView addSubview:_ftLab];
        
        _rmbLab = [[UILabel alloc] init];
        _rmbLab.text = @"≈ ¥500.00";
        _rmbLab.font = QDBoldFont(11);
        _rmbLab.textColor = APP_GRAYCOLOR;
        [self.contentView addSubview:_rmbLab];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_thePic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.and.equalTo(self.contentView);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.24);
    }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(SCREEN_WIDTH*0.04);
        make.top.equalTo(self.thePic.mas_bottom).offset(SCREEN_WIDTH*0.04);
    }];

    [_ftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.titleLab.mas_bottom).offset(SCREEN_HEIGHT*0.015);
    }];

    [_rmbLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.ftLab);
        make.left.equalTo(self.ftLab.mas_right).offset(SCREEN_WIDTH*0.016);
    }];
}


@end
