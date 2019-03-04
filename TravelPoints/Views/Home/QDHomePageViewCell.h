//
//  QDHomePageViewCell.h
//  TravelPoints
//
//  Created by 冉金 on 2019/2/17.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDHomePageViewCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UIImageView *pic;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *warnLab1;
@property (nonatomic, strong) UIButton *hates;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *warnLab2;
@property (nonatomic, strong) UIButton *likes;

@end

NS_ASSUME_NONNULL_END
