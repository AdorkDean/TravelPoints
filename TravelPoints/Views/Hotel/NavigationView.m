//
//  navigationView.m
//  DelskApp
//
//  Created by Tiger on 2017/7/25.
//  Copyright © 2017年 Delsk. All rights reserved.
//

#import "NavigationView.h"
@interface NavigationView ()

@property (nonatomic, strong) UIView *parting;
@property (nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic, assign) BOOL animatFinsh;

@end

@implementation NavigationView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    WS(ws);
    _addressBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
    _addressBtn.imageTitleSpace = SCREEN_WIDTH*0.02;
    [_addressBtn setTitle:@"云南大理" forState:UIControlStateNormal];
    [_addressBtn setImage:[UIImage imageNamed:@"icon_selectAddress"] forState:UIControlStateNormal];
    [_addressBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
    _addressBtn.titleLabel.font = QDBoldFont(20);
    [self addSubview:_addressBtn];
    
    [self.addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top).offset(25);
        make.left.equalTo(self.mas_left).offset(SCREEN_WIDTH*0.05);
    }];
    
    _iconBtn = [[UIButton alloc] init];
    [_iconBtn setImage:[UIImage imageNamed:@"icon_litleMap"] forState:UIControlStateNormal];
    [self addSubview:_iconBtn];
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_addressBtn);
        make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.05));
    }];
    
//    _topBackView = [[UIView alloc] init];
//    _topBackView.backgroundColor = APP_GRAYBUTTONCOLOR;
//    _topBackView.layer.masksToBounds = YES;
//    _topBackView.layer.cornerRadius = SCREEN_WIDTH*0.04;
//    [self addSubview:_topBackView];
//    [_topBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_addressBtn);
//        make.right.equalTo(self.iconBtn.mas_left).offset(-(SCREEN_WIDTH*0.008));
//        make.width.mas_equalTo(SCREEN_WIDTH*0.29);
//        make.height.mas_equalTo(SCREEN_HEIGHT*0.06);
//    }];
//
//    _imgView = [[UIImageView alloc] init];
//    [_imgView setImage:[UIImage imageNamed:@"icon_search"]];
//    [_topBackView addSubview:_imgView];
//    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.topBackView);
//        make.left.equalTo(self.topBackView.mas_left).offset(SCREEN_WIDTH*0.04);
//    }];
//
//
//    _inputTF = [[UITextField alloc] init];
//    _inputTF.placeholder = @"搜索";
//    [_inputTF setValue:APP_GRAYLINECOLOR forKeyPath:@"_placeholderLabel.textColor"];
//    [_inputTF setValue:QDFont(15) forKeyPath:@"_placeholderLabel.font"];
//    _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//    [_topBackView addSubview:_inputTF];
//    [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.topBackView);
//        make.left.equalTo(self.imgView.mas_right).offset(SCREEN_WIDTH*0.02);
//    }];
    
}

- (void)resetBtns
{
    for (UIView *btn in self.scrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)btn;
            [button setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        }
    }
}

//- (void)navigationAnimation{
//
//    WS(ws);
//
//    if (_animatFinsh == NO) {
//
//        for (int i = 0; i<4; i++) {
//            switch (i) {
//                case 0:{
//                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
//                        [ws.addressBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                            make.centerY.equalTo(self);
//                            make.left.equalTo(ws).offset(39);
//                        }];
//                        [self layoutIfNeeded];
//                    } completion:nil];
//                    break;
//                }
//                case 1:{
//                    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
//                        [_iconBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                            make.centerY.equalTo(self);
//                            make.right.equalTo(self.mas_right).offset(-(SCREEN_WIDTH*0.05));
//                        }];
//                        [self layoutIfNeeded];
//                    } completion:nil];
//                    break;
//                }
//                case 2:{
//                    [UIView animateWithDuration:0.5 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
//                        [ws.parting mas_remakeConstraints:^(MASConstraintMaker *make) {
//                            make.left.equalTo(_iconBtn.mas_right).offset(25);
//                            make.centerY.equalTo(ws);
//                            make.width.mas_equalTo(0.5);
//                            make.height.mas_equalTo(14);
//                        }];
//                        [self layoutIfNeeded];
//                    } completion:nil];
//                    break;
//                }
//                case 3:{
//                    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
//                        [ws.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                            make.left.equalTo(ws.parting.mas_right);
//                            make.bottom.equalTo(ws);
//                            make.right.equalTo(ws);
//                            make.height.mas_equalTo(44);
//                        }];
//                        [ws layoutIfNeeded];
//                    } completion:^(BOOL finished) {
//                        _animatFinsh = YES;
//                    }];
//                    break;
//                }
//                default:
//                    break;
//            }
//        }
//    }
//}

//- (void)resetFrame{
//
//    WS(ws);
//    if (_animatFinsh == YES) {
//        for (int i = 0; i<4; i++) {
//            switch (i) {
//                case 0:{
//                    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
//                        [ws.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                            make.left.equalTo(ws.mas_right);
//                            make.bottom.equalTo(ws);
//                            make.size.mas_equalTo(CGSizeMake(100, 44));
//                        }];
//                        [ws layoutIfNeeded];
//                    } completion:nil];
//
//                    break;
//                }
//                case 1:{
//                    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
//                        [ws.parting mas_remakeConstraints:^(MASConstraintMaker *make) {
//                            make.left.equalTo(ws.mas_right);
//                            make.centerY.equalTo(ws);
//                            make.width.mas_equalTo(0.5);
//                            make.height.mas_equalTo(14);
//                        }];
//                        [self layoutIfNeeded];
//                    } completion:^(BOOL finished) {
//
//                    }];
//
//                    break;
//                }
//                case 2:{
//                    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^{
//                        [_addressBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                            make.centerY.equalTo(ws);
//                            make.right.equalTo(ws).offset(-30);
//                        }];
//                        [self layoutIfNeeded];
//                    } completion:nil];
//                    break;
//                }
//                case 3:{
//                    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
//                        [self.addressBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//                            make.centerY.equalTo(ws);
//                            make.right.equalTo(ws).offset(-73);
//                        }];
//                        [self layoutIfNeeded];
//                    } completion:^(BOOL finished) {
//                        _animatFinsh = NO;
//                    }];
//                    break;
//                }
//                default:
//                    break;
//            }
//        }
//    }
//}

- (void)touchBtn:(UIButton *)btn{
    DebugLog(@"yyyyyyyyyyyyyyyyyyyyyyyy");
    if ([_naviDelegate respondsToSelector:@selector(NavigationViewWithScrollerButton:)]) {
        [_naviDelegate NavigationViewWithScrollerButton:btn];
    }
}

- (void)backViewController{
    if ([self.naviDelegate respondsToSelector:@selector(NavigationViewGoBack)]) {
        [self.naviDelegate NavigationViewGoBack];
    }
}

- (void)shareHouse{
    if ([self.naviDelegate respondsToSelector:@selector(NavigationViewGoShare)]) {
        [self.naviDelegate NavigationViewGoShare];
    }
}

- (void)collecHouse{
    if ([self.naviDelegate respondsToSelector:@selector(NavigationViewGoCollect)]) {
        [self.naviDelegate NavigationViewGoCollect];
    }
}

@end
