//
//  QDHomeTopView.h
//  TravelPoints
//
//  Created by 冉金 on 2019/1/18.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDHomeTopView : UIView<UISearchBarDelegate>

@property (nonatomic, strong) UIImageView *backImg;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *goWhereLab;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

NS_ASSUME_NONNULL_END
