//
//  QDMineInfoViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/22.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDMineInfoViewController.h"
#import "QDMineHeaderNotLoginView.h"
#import "QDLoginAndRegisterVC.h"
#import "QDSettingViewController.h"
#import "QDMineInfoTableViewCell.h"
#import "QDLogonWithNoFinancialAccountView.h"
#import "QDMineHeaderFinancialAccountView.h"
@interface QDMineInfoViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
    QDMineHeaderNotLoginView *_headerView;
    QDLogonWithNoFinancialAccountView *_noFinancialView;
    QDMineHeaderFinancialAccountView *_haveFinancialView;
}

@end

@implementation QDMineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self initTableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 67, 0);
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    //未登录
    _headerView = [[QDMineHeaderNotLoginView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.366)];
    _headerView.backgroundColor = APP_LIGHTGRAYCOLOR;
    [_headerView.settingBtn addTarget:self action:@selector(userSettings:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    //未开通资金帐户
    _noFinancialView = [[QDLogonWithNoFinancialAccountView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.366)];
    _noFinancialView.backgroundColor = APP_LIGHTGRAYCOLOR;
    [_noFinancialView.settingBtn addTarget:self action:@selector(userSettings:) forControlEvents:UIControlEventTouchUpInside];
    [_noFinancialView.openFinancialBtn addTarget:self action:@selector(openFinancialAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _haveFinancialView = [[QDMineHeaderFinancialAccountView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.5)];
    _haveFinancialView.backgroundColor = APP_LIGHTGRAYCOLOR;
    [_haveFinancialView.settingBtn addTarget:self action:@selector(userSettings:) forControlEvents:UIControlEventTouchUpInside];
    [_haveFinancialView.rechargeBtn addTarget:self action:@selector(rechargeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_haveFinancialView.withdrawBtn addTarget:self action:@selector(withdrawAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString *str = [QDUserDefaults getObjectForKey:@"loginType"];
    if ([str isEqualToString:@"0"] || str == nil) {
        _tableView.tableHeaderView = _headerView;
    }else if([str isEqualToString:@"1"]){
        _tableView.tableHeaderView = _noFinancialView;
    }else{
        _tableView.tableHeaderView = _haveFinancialView;
    }
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

#pragma mark - 开通资金账户
- (void)openFinancialAction:(UIButton *)sender{
    
}
- (void)myOrders:(UIButton *)sender{
    QDLog(@"123");
}

#pragma mark - 充值
- (void)rechargeAction:(UIButton *)sender{
}

#pragma mark - 提现
- (void)withdrawAction:(UIButton *)sender{
}

#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_HEIGHT*0.075;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.57;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"QDMineInfoTableViewCell";
    QDMineInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[QDMineInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell点击时的颜色
    //    UIView *backgroundViews = [[UIView alloc]initWithFrame:cell.frame];
    //    backgroundViews.backgroundColor = [UIColor whiteColor];
    //    [cell setSelectedBackgroundView:backgroundViews];
    //    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
//    [self.navigationController pushViewController:bridgeVC animated:YES];
//
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
