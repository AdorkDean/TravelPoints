//
//  QDMineViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/14.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDMineViewController.h"
#import "QDLoginViewController.h"
#import "QDRegisterViewController.h"
#import "QDLoginAndRegisterVC.h"
#import "QDBackgroundView.h"
#import "UIColor+CustomFunctions.h"
#import "XBGradientColorView.h"
#import "QDMineView.h"
#import "QDMineHeaderNotLoginView.h"
#import "QDSettingViewController.h"
#import "QDBridgeViewController.h"
@interface QDMineViewController ()

@end

@implementation QDMineViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
////    QDBackgroundView *view = [[QDBackgroundView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.293)];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = view.bounds;
//    gradient.colors = [NSArray arrayWithObjects:
//                       (id)[UIColor colorWithHexString:@"#ABCC1E"].CGColor,
//                       (id)[UIColor colorWithHexString:@"#71BA33"].CGColor,
//                       (id)[UIColor whiteColor].CGColor, nil];
//    gradient.startPoint = CGPointMake(0, 1);
//    gradient.endPoint = CGPointMake(1, 0);
////    gradient.locations = @[@0.0, @0.2, @0.5];
//    [view.layer addSublayer:gradient];
    
//    XBGradientColorView *grv=[XBGradientColorView new];
//    [self.view addSubview:grv];
//    grv.frame=CGRectMake(0, 0, SCREEN_WIDTH, 200);
//    grv.fromColor=[UIColor colorWithHex:@"#71BA33"];
//    grv.toColor=[UIColor colorWithHex:@"#ABCC1E"];
//    grv.direction=0;//设置渐变方向
//    [self.view addSubview:grv];
    QDMineView *mineView = [[QDMineView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [mineView.btn1 addTarget:self action:@selector(myOrders:) forControlEvents:UIControlEventTouchUpInside];
    [mineView.settingBtn addTarget:self action:@selector(userSettings:) forControlEvents:UIControlEventTouchUpInside];
    [mineView.btn8 addTarget:self action:@selector(toWebView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mineView];
    
    QDMineHeaderNotLoginView *headerView = [[QDMineHeaderNotLoginView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.053, SCREEN_HEIGHT*0.12, SCREEN_WIDTH*0.89, SCREEN_HEIGHT*0.225)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView.loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    [mineView addSubview:headerView];
    [self.view addSubview:headerView];
}

#pragma mark - 用户登录注册
- (void)userLogin:(UIButton *)sender{
    QDLog(@"userLogin");
    QDLoginAndRegisterVC *loginVC = [[QDLoginAndRegisterVC alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}


#pragma mark - 设置页面
- (void)userSettings:(UIButton *)sender{
    QDSettingViewController *settingVC = [[QDSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)myOrders:(UIButton *)sender{
    QDLog(@"123");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
//    btn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)login:(UIButton *)sender{
//    QDLoginViewController *loginVC = [[QDLoginViewController alloc] init];

    QDLoginAndRegisterVC *loginVC = [[QDLoginAndRegisterVC alloc] init];
//    QDRegisterViewController *loginVC = [[QDRegisterViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
    }];
}

#pragma mark - JSBridge测试
- (void)toWebView:(UIButton *)sender{
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    [self.navigationController pushViewController:bridgeVC animated:YES];
}

@end
