//
//  QDTradeShellsSectionHeaderView.h
//  TravelPoints
//
//  Created by 冉金 on 2019/2/15.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface QDTradeShellsSectionHeaderView : UIView

@property (nonatomic, strong) SPButton *amountBtn;
@property (nonatomic, strong) SPButton *priceBtn;
@property (nonatomic, strong) SPButton *filterBtn;

@end

NS_ASSUME_NONNULL_END
