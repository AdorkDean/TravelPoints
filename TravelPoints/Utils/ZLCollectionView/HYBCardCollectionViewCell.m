//
//  HYBCardCollectionViewCell.m
//  CollectionViewDemos
//
//  Created by huangyibiao on 16/3/26.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBCardCollectionViewCell.h"

@interface HYBCardCollectionViewCell ()

@property (nonatomic, strong) UIView *imageView;

@end

@implementation HYBCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
      self.contentView.backgroundColor = APP_WHITECOLOR;
      self.pic = [[UIImageView alloc] init];
//    self.imageView.layer.cornerRadius = 12;
//    self.imageView.layer.masksToBounds = YES;
      _pic.backgroundColor = APP_BLUECOLOR;
      [self.contentView addSubview:_pic];
      
      _descLab = [[UILabel alloc] init];
      _descLab.text = @"揭秘中国设计NO.1究竟是怎样一个宝藏酒店?";
      _descLab.textColor = APP_WHITECOLOR;
      _descLab.font = QDBoldFont(17);
      _descLab.numberOfLines = 0;
      [self.contentView addSubview:_descLab];
      
      _titleLab = [[UILabel alloc] init];
      _titleLab.text = @"中国大神设计酒店云南TOP10排行榜";
      _titleLab.textColor = APP_BLACKCOLOR;
      _titleLab.font = QDFont(17);
      [self.contentView addSubview:_titleLab];
      
      _lineView = [[UIView alloc] init];
      _lineView.backgroundColor = APP_LIGHTGRAYCOLOR;
      [self.contentView addSubview:_lineView];
      
      _warnLab1 = [[UILabel alloc] init];
      _warnLab1.text = @"过滤无效评价";
      _warnLab1.textColor = APP_GRAYTEXTCOLOR;
      _warnLab1.font = QDFont(12);
      [self.contentView addSubview:_warnLab1];
      
      _hates = [[UILabel alloc] init];
      _hates.text = @"2080";
      _hates.textColor = APP_BLUECOLOR;
      _hates.font = QDFont(13);
      [self.contentView addSubview:_hates];
      
      _warnLab2 = [[UILabel alloc] init];
      _warnLab2.text = @"筛选优质评价";
      _warnLab2.textColor = APP_GRAYTEXTCOLOR;
      _warnLab2.font = QDFont(12);
      [self.contentView addSubview:_warnLab2];
      
      _likes = [[UILabel alloc] init];
      _likes.text = @"2080";
      _likes.textColor = APP_BLUECOLOR;
      _likes.font = QDFont(13);
      [self.contentView addSubview:_likes];
  }
  
  return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_pic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.43);
    }];

    [_descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pic.mas_top).offset(SCREEN_HEIGHT*0.03);
        make.left.equalTo(_pic.mas_left).offset(SCREEN_WIDTH*0.24);
        make.right.equalTo(_pic.mas_right).offset(-(SCREEN_WIDTH*0.05));
    }];

    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_pic.mas_bottom).offset(SCREEN_HEIGHT*0.02);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.mas_bottom).offset(SCREEN_HEIGHT*0.07);
        make.left.equalTo(self.contentView.mas_left).offset(SCREEN_WIDTH*0.44);
        make.width.mas_equalTo(SCREEN_WIDTH*0.003);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.03);
    }];
    
    [_warnLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(SCREEN_WIDTH*0.12);
        make.top.equalTo(_titleLab.mas_bottom).offset(SCREEN_HEIGHT*0.07);
    }];
    
    [_hates mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_warnLab1);
        make.left.equalTo(_warnLab1.mas_right).offset(SCREEN_WIDTH*0.01);
    }];
    

    [_warnLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_warnLab1);
        make.left.equalTo(_lineView.mas_right).offset(SCREEN_WIDTH*0.02);
        make.top.equalTo(_pic.mas_bottom).offset(SCREEN_HEIGHT*0.02);
    }];

    [_likes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_warnLab2);
        make.left.equalTo(_warnLab2.mas_right).offset(SCREEN_WIDTH*0.01);
    }];
}

- (void)configWithImage:(id)image {
//  self.imageView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:image].CGImage);
}

@end
