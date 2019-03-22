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
#import "QDBridgeViewController.h"
#import "QDMemberDTO.h"
#import "QDRefreshHeader.h"
#import "QDMineSectionHeaderView.h"
#import "QDBuyOrSellViewController.h"
#import "QDBridgeViewController.h"
@interface QDMineInfoViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
    QDMineHeaderNotLoginView *_notLoginHeaderView;
    QDLogonWithNoFinancialAccountView *_noFinancialView;
    QDMineHeaderFinancialAccountView *_haveFinancialView;
    NSArray *_cellTitleArr;
    QDMineSectionHeaderView *_sectionHeaderView;
    UIView *_cellSeparateLineView;
    QDMemberDTO *_currentQDMemberTDO;
}

@end

@implementation QDMineInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLoginView) name:@"reloadLoginView" object:nil];
    [self isLogin];
    
//    NSString *str = [QDUserDefaults getObjectForKey:@"loginType"];
//    if (![str isEqualToString:@"0"] && str != nil) { //未登录
//        [self queryUserStatus:api_GetUserDetail isViewWillAppear:NO];
//    }
}

- (void)reloadLoginView{
    QDLog(@"退出登录成功返回");
    [self queryUserStatus:api_GetUserDetail];
}
- (void)isLogin{
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_IsLogin params:nil successBlock:^(QDResponseObject *responseObject) {
        NSString *cookie = [NSString stringWithFormat:@"%@", [QDUserDefaults getCookies]];
        if ([responseObject.result intValue] == 0) {
            [QDUserDefaults setObject:@"0" forKey:@"loginType"];
            QDLog(@"未登录, cookie = %@", cookie);
            [QDUserDefaults removeCookies]; //未登录的时候移除cookie
            [self showTableHeadView];
        }else if ([responseObject.result intValue] == 1){
            QDLog(@"已登录,cookie = %@", cookie);
            [self requestUserStatus];
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadLoginView" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cellTitleArr = [[NSArray alloc] initWithObjects:@"邀请好友",@"收藏",@"我的银行卡",@"房券", @"地址",@"安全中心", nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    _tableView.mj_header = [QDRefreshHeader headerWithRefreshingBlock:^{
        [self queryUserStatus:api_GetUserDetail isViewWillAppear:NO];
    }];
}

#pragma mark - 刷新请求用户状态
- (void)requestUserStatus{
    QDLog(@"requestUserStatus");
    [self queryUserStatus:api_GetUserDetail isViewWillAppear:NO];
    [_tableView.mj_header endRefreshing];
}

#pragma mark - 个人积分账户详情
- (void)queryUserStatus:(NSString *)urlStr isViewWillAppear:(BOOL)isAppear{
    NSString *cookie = [NSString stringWithFormat:@"%@", [QDUserDefaults getCookies]];
    QDLog(@"cookie = %@", cookie);
    if (!cookie || [cookie isEqualToString:@"(null)"] || [cookie isEqualToString:@""]) {
        [QDUserDefaults setObject:@"0" forKey:@"loginType"];
        [self showTableHeadView];
        [self endRefreshing];
    }else{
        [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:nil successBlock:^(QDResponseObject *responseObject) {
            [self endRefreshing];
            QDLog(@"responseObject = %@", responseObject);
            //ieYePay 0否 1是
            if (responseObject.code == 0) {
                if (responseObject.result != nil) {
                    _currentQDMemberTDO = [QDMemberDTO yy_modelWithDictionary:responseObject.result];
                    if ([_currentQDMemberTDO.isYepay isEqualToString:@"0"] || _currentQDMemberTDO.isYepay == nil) {
                        [QDUserDefaults setObject:@"1" forKey:@"loginType"];
                        [_noFinancialView loadViewWithModel:_currentQDMemberTDO];
                    }else{
                        [QDUserDefaults setObject:@"2" forKey:@"loginType"];
                        [_haveFinancialView loadFinancialViewWithModel:_currentQDMemberTDO];
                    }
                }
            }else{
                [QDUserDefaults setObject:@"0" forKey:@"loginType"];
                if (!isAppear) {
                    [WXProgressHUD showErrorWithTittle:@"未登录"];
                }else{
                    [WXProgressHUD showErrorWithTittle:responseObject.message];
                }
            }
            [self showTableHeadView];
        } failureBlock:^(NSError *error) {
            [WXProgressHUD showErrorWithTittle:@"网络异常"];
            [self endRefreshing];
            [self showTableHeadView];
        }];
    }
}

#pragma mark - 个人积分账户详  情
- (void)queryUserStatus:(NSString *)urlStr{
    NSString *cookie = [NSString stringWithFormat:@"%@", [QDUserDefaults getCookies]];
    QDLog(@"cookie = %@", cookie);
    if (!cookie || [cookie isEqualToString:@"(null)"] || [cookie isEqualToString:@""]) {
        [QDUserDefaults setObject:@"0" forKey:@"loginType"];
        [self showTableHeadView];
        [self endRefreshing];
    }else{
        [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:nil successBlock:^(QDResponseObject *responseObject) {
            [self endRefreshing];
            QDLog(@"responseObject = %@", responseObject);
            //ieYePay 0否 1是
            if (responseObject.code == 0) {
                if (responseObject.result != nil) {
                    _currentQDMemberTDO = [QDMemberDTO yy_modelWithDictionary:responseObject.result];
                    UserMoneyDTO *moneyDTO = _currentQDMemberTDO.userMoneyDTO;
                    UserCreditDTO *creditDTO = _currentQDMemberTDO.userCreditDTO;
                    if ([_currentQDMemberTDO.isYepay isEqualToString:@"0"] || _currentQDMemberTDO.isYepay == nil) {
                        //未开通资金帐户
                        [QDUserDefaults setObject:@"1" forKey:@"loginType"];
                        _noFinancialView.info9Lab.text = [creditDTO.available stringValue];
                        _noFinancialView.balance.text = [NSString stringWithFormat:@"%.2f", [moneyDTO.available doubleValue]];
                    }else{
                        [QDUserDefaults setObject:@"2" forKey:@"loginType"];
                        _haveFinancialView.info9Lab.text = [creditDTO.available stringValue];
                        _haveFinancialView.balance.text = [NSString stringWithFormat:@"%.2f",[moneyDTO.available doubleValue]];
                    }
                }
            }else{
                [QDUserDefaults setObject:@"0" forKey:@"loginType"];

            }
            [self showTableHeadView];
        } failureBlock:^(NSError *error) {
            [WXProgressHUD showErrorWithTittle:@"网络异常"];
            [self showTableHeadView];
        }];
    }
}
- (void)showTableHeadView{
    NSString *str = [QDUserDefaults getObjectForKey:@"loginType"];
    if ([str isEqualToString:@"0"] || str == nil) {
        _tableView.tableHeaderView = _notLoginHeaderView;
    }else if([str isEqualToString:@"1"]){
        _noFinancialView.userNameLab.text = _currentQDMemberTDO.userName;
        //会员等级
        _tableView.tableHeaderView = _noFinancialView;
    }else{
        _haveFinancialView.userNameLab.text = _currentQDMemberTDO.userName;
        _tableView.tableHeaderView = _haveFinancialView;
    }
    [_tableView reloadData];
}

-(void)customSeparateLineToCell:(UITableViewCell *)cell{
    UIView *separateLineBottom = [[UIView alloc] init];
    [separateLineBottom setBackgroundColor:[UIColor colorWithHexString:@"#DDDDDD"]];
    [cell.contentView addSubview:separateLineBottom];
    [separateLineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.contentView);
        make.centerX.equalTo(cell.contentView);
        make.width.mas_equalTo(335);
        make.height.mas_equalTo(0.5);
    }];
    
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
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaTopHeight, 0);
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    //未登录
    _notLoginHeaderView = [[QDMineHeaderNotLoginView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.2)];
    _notLoginHeaderView.backgroundColor = APP_WHITECOLOR;
    [_notLoginHeaderView.settingBtn addTarget:self action:@selector(userSettings:) forControlEvents:UIControlEventTouchUpInside];
    [_notLoginHeaderView.loginBtn addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    //未开通资金帐户
    _noFinancialView = [[QDLogonWithNoFinancialAccountView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.54)];
    _noFinancialView.backgroundColor = APP_WHITECOLOR;
    [_noFinancialView.settingBtn addTarget:self action:@selector(userSettings:) forControlEvents:UIControlEventTouchUpInside];
    [_noFinancialView.voiceBtn addTarget:self action:@selector(notices:) forControlEvents:UIControlEventTouchUpInside];

    [_noFinancialView.openFinancialBtn addTarget:self action:@selector(openFinancialAction:) forControlEvents:UIControlEventTouchUpInside];
    [_noFinancialView.accountInfo addTarget:self action:@selector(lookAccountInfo:) forControlEvents:UIControlEventTouchUpInside];
    //已经开通资金账户的
    _haveFinancialView = [[QDMineHeaderFinancialAccountView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.55)];
    _haveFinancialView.backgroundColor = APP_WHITECOLOR;
    [_haveFinancialView.voiceBtn addTarget:self action:@selector(notices:) forControlEvents:UIControlEventTouchUpInside];
    [_haveFinancialView.accountInfo addTarget:self action:@selector(lookAccountInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_haveFinancialView.settingBtn addTarget:self action:@selector(userSettings:) forControlEvents:UIControlEventTouchUpInside];
    [_haveFinancialView.rechargeBtn addTarget:self action:@selector(rechargeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_haveFinancialView.withdrawBtn addTarget:self action:@selector(withdrawAction:) forControlEvents:UIControlEventTouchUpInside];
    NSString *str = [QDUserDefaults getObjectForKey:@"loginType"];
    if ([str isEqualToString:@"0"] || str == nil) {
        _tableView.tableHeaderView = _notLoginHeaderView;
    }else if([str isEqualToString:@"1"]){
        _tableView.tableHeaderView = _noFinancialView;
    }else{
        _tableView.tableHeaderView = _haveFinancialView;
    }
    [_tableView reloadData];
}

- (void)lookAccountInfo:(UIButton *)sender{
    QDLog(@"lookAccountInfo");
    
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_INTEGRAL];
    QDLog(@"urlStr = %@", bridgeVC.urlStr);
    [self.navigationController pushViewController:bridgeVC animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _sectionHeaderView = [[QDMineSectionHeaderView alloc] init];
    [_sectionHeaderView.btn1 addTarget:self action:@selector(ordersAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sectionHeaderView.btn2 addTarget:self action:@selector(ordersAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sectionHeaderView.btn3 addTarget:self action:@selector(ordersAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sectionHeaderView.btn4 addTarget:self action:@selector(ordersAction:) forControlEvents:UIControlEventTouchUpInside];

    _sectionHeaderView.backgroundColor = APP_WHITECOLOR;
    return _sectionHeaderView;
}

- (void)notices:(UIButton *)sender{
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_NOTICE];
    QDLog(@"urlStr = %@", bridgeVC.urlStr);
    [self.navigationController pushViewController:bridgeVC animated:YES];
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
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_OPENACCOUNT];
    QDLog(@"urlStr = %@", bridgeVC.urlStr);
    [self.navigationController pushViewController:bridgeVC animated:YES];
}
- (void)myOrders:(UIButton *)sender{
    QDLog(@"123");
}

#pragma mark - 充值
- (void)rechargeAction:(UIButton *)sender{
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@", [QDUserDefaults getObjectForKey:@"QD_TESTJSURL"], JS_RECHARGE];
    QDLog(@"urlStr = %@", bridgeVC.urlStr);
    [self.navigationController pushViewController:bridgeVC animated:YES];
}

#pragma mark - 提现
- (void)withdrawAction:(UIButton *)sender{
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@", [QDUserDefaults getObjectForKey:@"QD_TESTJSURL"], JS_WITHDRAW];
    QDLog(@"urlStr = %@", bridgeVC.urlStr);
    [self.navigationController pushViewController:bridgeVC animated:YES];
}

#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cellTitleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_HEIGHT*0.12;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.075;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"QDMineInfoTableViewCell";
    QDMineInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[QDMineInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [self customSeparateLineToCell:cell];
    cell.textLabel.text = _cellTitleArr[indexPath.row];
    cell.textLabel.textColor = APP_BLACKCOLOR;
    cell.textLabel.font = QDFont(16);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0: //邀请好友
            [self inviteFriends];
            break;
        case 1: //收藏
            [self gotoLoginWithAction:JS_COLLECTION];
            break;
        case 2: //我的银行卡
            [self gotoLoginWithAction:JS_BANKCARD];
            break;
        case 3: //房券
            [self gotoLoginWithAction:JS_MYHOURSE];
            break;
        case 4: //地址
            [self gotoLoginWithAction:JS_ADDRESS];
            break;
        case 5: //安全中心
            [self gotoLoginWithAction:JS_SECURITYCENTER];
            break;
        default:
            break;
    }
}

- (void)gotoLoginWithAction:(NSString *)jsStr{
    NSString *str = [QDUserDefaults getObjectForKey:@"loginType"];
    if ([str isEqualToString:@"0"] || str == nil) { //未登录
        QDLoginAndRegisterVC *loginVC = [[QDLoginAndRegisterVC alloc] init];
        loginVC.pushVCTag = @"0";
        [self presentViewController:loginVC animated:YES completion:nil];
    }else{
        [self pushBridgeVCWithStr:[[QDUserDefaults getObjectForKey:@"QD_JSURL"] stringByAppendingString:jsStr]];
    }
}
    
#pragma mark - 邀请好友
- (void)inviteFriends{
    if ([[QDUserDefaults getObjectForKey:@"loginType"] isEqualToString:@"0"]) {
        QDLoginAndRegisterVC *loginVC = [[QDLoginAndRegisterVC alloc] init];
        loginVC.pushVCTag = @"0";
        [self presentViewController:loginVC animated:YES completion:nil];
    }else{
        [self pushBridgeVCWithStr:[[QDUserDefaults getObjectForKey:@"QD_TESTJSURL"] stringByAppendingString:JS_INVITEFRIENDS]];
    }
}
#pragma mark - 全部订单
- (void)ordersAction:(UIButton *)sender{
    if ([[QDUserDefaults getObjectForKey:@"loginType"] isEqualToString:@"0"]) {
        [WXProgressHUD showErrorWithTittle:@"未登录"];
        QDLoginAndRegisterVC *loginVC = [[QDLoginAndRegisterVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
    }else{
        [self pushBridgeVCWithStr:[[QDUserDefaults getObjectForKey:@"QD_JSURL"] stringByAppendingString:JS_ORDERS]];
    }
}

#pragma mark - 积分账户
- (void)integralAction:(UIButton *)sender{
    if ([[QDUserDefaults getObjectForKey:@"loginType"] isEqualToString:@"0"]) {
        [WXProgressHUD showErrorWithTittle:@"未登录"];
    }else{
        [self pushBridgeVCWithStr:[[QDUserDefaults getObjectForKey:@"QD_JSURL"] stringByAppendingString:JS_INTEGRAL]];
    }
}


#pragma mark - 系统信息
- (void)voiceAction:(UIButton *)sender{
    if ([[QDUserDefaults getObjectForKey:@"loginType"] isEqualToString:@"0"]) {
        [WXProgressHUD showErrorWithTittle:@"未登录"];
    }else{
        [self pushBridgeVCWithStr:[[QDUserDefaults getObjectForKey:@"QD_JSURL"] stringByAppendingString:JS_NOTICE]];
    }
}


- (void)pushBridgeVCWithStr:(NSString *)urlStr{
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    bridgeVC.urlStr = urlStr;
    self.navigationController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bridgeVC animated:YES];
}

- (void)endRefreshing
{
    if (_tableView) {
        [_tableView.mj_header endRefreshing];
    }
}

@end
