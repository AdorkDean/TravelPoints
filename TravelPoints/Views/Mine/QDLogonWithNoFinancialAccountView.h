//
//  QDLogonWithNoFinancialAccountView.h
//  TravelPoints
//
//  Created by 冉金 on 2019/1/22.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDLogonWithNoFinancialAccountView : UIView

@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UIButton *voiceBtn;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *picBtn;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *vipLab;
@property (nonatomic, strong) UILabel *vipRightsLab;

@property (nonatomic, strong) UIView *whiteBackView;
@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UIButton *openFinancialBtn;
@end

NS_ASSUME_NONNULL_END
