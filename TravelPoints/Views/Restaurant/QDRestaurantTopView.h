//
//  QDRestaurantTopView.h
//  TravelPoints
//
//  Created by 冉金 on 2019/1/19.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDRestaurantTopView : UIView

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) SPButton *cityBtn;
@property (nonatomic, strong) UITextField *locationTF;
@property (nonatomic, strong) UIButton *searchBtn;

@end

NS_ASSUME_NONNULL_END
