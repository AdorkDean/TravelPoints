//
//  navigationView.h
//  DelskApp
//
//  Created by Tiger on 2017/7/25.
//  Copyright © 2017年 Delsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPButton.h"

@protocol NavigationViewDelegate <NSObject>

- (void)NavigationViewWithScrollerButton:(UIButton *)btn;
- (void)NavigationViewGoBack;
- (void)NavigationViewGoShare;
- (void)NavigationViewGoCollect;

@end

@interface NavigationView : UIView
@property (nonatomic, strong) SPButton *addressBtn;
@property (nonatomic, strong) UIButton *iconBtn;

@property(nonatomic, strong) UIView *topBackView;
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UITextField *inputTF;
@property (nonatomic, weak) id<NavigationViewDelegate> naviDelegate;

////向左移动
- (void)navigationAnimation;
////恢复原位
//- (void)resetFrame;
////选中恢复
//- (void)resetBtns;
@end
