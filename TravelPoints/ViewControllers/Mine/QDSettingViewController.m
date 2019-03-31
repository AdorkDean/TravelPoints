//
//  QDSettingViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/16.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDSettingViewController.h"
#import "QDLoginAndRegisterVC.h"
#import <TYAlertView.h>

@interface QDSettingViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
    UILabel *_exitCurrent;
    UILabel *_versionLab;
}

@end

@implementation QDSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)setLeftBtnItem{
    UIImage *backImage = [UIImage imageNamed:@"icon_return"];
    UIImage *selectedImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:selectedImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBtn)];
    [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
}
- (void)leftBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    [self initTableView];
    [self setLeftBtnItem];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.015 + SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.09;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    //设置cell点击时的颜色
    UIView *backgroundViews = [[UIView alloc]initWithFrame:cell.frame];
    backgroundViews.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.textLabel.font = QDFont(15);
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"检查";
//            _versionLab = [[UILabel alloc] init];
//            _versionLab.text = @"当前版本1.0.3";
//            _versionLab.font = QDFont(13);
//            [cell.contentView addSubview:_versionLab];
//            [_versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(cell.contentView);
//                make.right.equalTo(cell.contentView.mas_right).offset(-(SCREEN_WIDTH*0.054));
//            }];
//        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            cell.textLabel.text = @"关于我们";
//        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        _exitCurrent = [[UILabel alloc] init];
        _exitCurrent.text = @"退出当前用户";
        _exitCurrent.font = QDFont(15);
        [cell.contentView addSubview:_exitCurrent];
        [_exitCurrent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.height.equalTo(@(SCREEN_HEIGHT*0.03));
        }];
    }
    return cell;
}

#pragma mark - 用户登出接口
- (void)logout{
    //先判断用户是否登录
    [[QDServiceClient shareClient] logoutWitStr:api_UserLogout SuccessBlock:^(QDResponseObject *responseObject) {
        [WXProgressHUD hideHUD];
        if (responseObject.code == 0) {
            //移除cookie
            [WXProgressHUD showSuccessWithTittle:@"退出登录成功"];
            [QDUserDefaults setObject:@"0" forKey:@"loginType"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLoginView" object:nil];
            [QDUserDefaults removeCookies];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [WXProgressHUD showInfoWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}
- (void)showAlertView{
    TYAlertView *alertView = [[TYAlertView alloc] initWithTitle:@"提示" message:@"确定退出当前账户?"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        [self logout];
    }]];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleCancel forState:UIControlStateNormal];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleBlod forState:UIControlStateNormal];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleDestructive forState:UIControlStateNormal];
    [alertView show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else{
            
        }
    }
    if (indexPath.section == 1) {
        NSString *str = [QDUserDefaults getObjectForKey:@"loginType"];
        if ([str isEqualToString:@"0"] || str == nil) { //未登录
            [WXProgressHUD showInfoWithTittle:@"当前无用户登录"];
        }else{
            [self showAlertView];
        }
    }
}

@end
