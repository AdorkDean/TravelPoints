//
//  QDHomePageViewCell.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/17.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDHomePageViewCell.h"

@implementation QDHomePageViewCell

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
        _backView.backgroundColor = [UIColor greenColor];
        _backView.layer.shadowColor = APP_GRAYLINECOLOR.CGColor;
        // 阴影偏移，默认(0, -3)
        _backView.layer.shadowOffset = CGSizeMake(2,3);
        // 阴影透明度，默认0
        _backView.layer.shadowOpacity = 3;
        // 阴影半径，默认3
        _backView.layer.shadowRadius = 2;
        _backView.layer.cornerRadius = 8;
        _backView.layer.masksToBounds = YES;
        [self.contentView addSubview:_backView];
        
        _pic = [[UIImageView alloc] init];
        //    self.imageView.layer.cornerRadius = 12;
        //    self.imageView.layer.masksToBounds = YES;
        _pic.backgroundColor = APP_BLUECOLOR;
        [_backView addSubview:_pic];
        
        _descLab = [[UILabel alloc] init];
        _descLab.text = @"揭秘中国设计NO.1究竟是怎样一个宝藏酒店?";
        _descLab.textColor = APP_WHITECOLOR;
        _descLab.font = QDBoldFont(17);
        _descLab.numberOfLines = 0;
        [_backView addSubview:_descLab];
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"中国大神设计酒店云南TOP10排行榜";
        _titleLab.textColor = APP_BLACKCOLOR;
        _titleLab.font = QDFont(17);
        [self.contentView addSubview:_titleLab];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = APP_BLUECOLOR;
        [_backView addSubview:_lineView];
        
        _warnLab1 = [[UILabel alloc] init];
        _warnLab1.text = @"过滤无效评价";
        _warnLab1.textColor = APP_GRAYTEXTCOLOR;
        _warnLab1.font = QDFont(12);
        [_backView addSubview:_warnLab1];
        
        _warnLab2 = [[UILabel alloc] init];
        _warnLab2.text = @"筛选优质评价";
        _warnLab2.textColor = APP_GRAYTEXTCOLOR;
        _warnLab2.font = QDFont(12);
        [_backView addSubview:_warnLab2];
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
    
    [_pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(_backView);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.4);
    }];

    [_descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pic.mas_top).offset(SCREEN_HEIGHT*0.03);
        make.left.equalTo(_pic.mas_left).offset(SCREEN_WIDTH*0.24);
        make.right.equalTo(_pic.mas_right).offset(-(SCREEN_WIDTH*0.05));
    }];

    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_backView);
        make.top.equalTo(_pic.mas_bottom).offset(SCREEN_HEIGHT*0.02);
    }];

    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.mas_bottom).offset(SCREEN_HEIGHT*0.07);
        make.left.equalTo(_backView.mas_left).offset(SCREEN_WIDTH*0.44);
        make.width.mas_equalTo(SCREEN_WIDTH*0.003);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.03);
    }];
    
    //    [_warnLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.contentView.mas_left).offset(SCREEN_WIDTH*0.12);
    //        make.top.equalTo(_titleLab.mas_bottom).offset(SCREEN_HEIGHT*0.07);
    //    }];
    //    [_warnLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(_warnLab1);
    //        make.top.equalTo(_pic.mas_bottom).offset(SCREEN_HEIGHT*0.02);
    //    }];
}


@end
