//
//  QDPopMenuCell.m
//  QDINFI
//
//  Created by ZengTark on 2017/12/8.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#import "QDPopMenuCell.h"

@implementation QDPopMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _menuTitleLabel = [[UILabel alloc] init];
        _menuTitleLabel.font = QDFont(15);
        _menuTitleLabel.textColor = [UIColor whiteColor];
        _menuTitleLabel.numberOfLines = 0;
        _menuTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_menuTitleLabel];
        
        [_menuTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = APP_WHITECOLOR;
        self.selectedBackgroundView = bgView;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

