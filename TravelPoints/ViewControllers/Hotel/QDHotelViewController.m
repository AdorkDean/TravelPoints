//
//  SecondViewController.m
//  NaviAnimation
//
//  Created by Tiger Liu on 04/11/2017.
//  Copyright © 2017 Tiger Liu. All rights reserved.
//

#import "QDHotelViewController.h"
#import "NavigationView.h"

@interface QDHotelViewController ()<UITableViewDataSource,UITableViewDelegate,NavigationViewDelegate>

@property (nonatomic, strong) NavigationView *navigationView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *collectBtn;

@property (nonatomic, assign) CGFloat alpha;

@end

@implementation QDHotelViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.tableView];
    [self configNavigationBar];
    [self.view addSubview:self.navgationView];
    
}

#pragma mark - UI
//导航栏
- (void)configNavigationBar{
    WS(ws);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"ad_back_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"ad_share_white"] forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:@"ad_share_red"] forState:UIControlStateSelected];
    [_shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_collectBtn setImage:[UIImage imageNamed:@"ad_collection_white"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"ad_collection_red"] forState:UIControlStateSelected];
    
    [self.view addSubview:backBtn];
    [self.view addSubview:_shareBtn];
    [self.view addSubview:_collectBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(10);
        make.top.equalTo(ws.view).offset(35);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backBtn);
        make.right.equalTo(ws.view).offset(-73);
        make.size.mas_offset(CGSizeMake(22, 22));
    }];
    
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backBtn);
        make.right.equalTo(ws.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
}
//透明导航兰
- (NavigationView *)navgationView{
    if (!_navigationView) {
        _navigationView = [[NavigationView alloc]init];
        _navigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        _navigationView.backgroundColor = [UIColor whiteColor];
        _navigationView.alpha = 0.0;
        _navigationView.naviDelegate = self;
    }
    return _navigationView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}
#pragma mark - UITableViewDelegate, UITableViewDataSorce
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 12) {
        return 15;
    }else if (section == 2 || section == 3 || section == 4 || section == 9){
        return CGFLOAT_MIN;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3 || section == 4 || section == 5) {
        return 48;
    } else if (section == 10) {
        return CGFLOAT_MIN + 48;
    } else{
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return SCREEN_WIDTH * 9/16;
    }else if(indexPath.section == 1){
        return 100;
    }else if(indexPath.section == 2){
        return 45;
    }else if (indexPath.section == 6){
        return 120;
    }
    else if (indexPath.section == 8){
        return 100;
    }else if (indexPath.section == 9){
        return 62;
    }else if (indexPath.section == 10){
        return 60;
    }else if (indexPath.section == 11){
        return 161;
    }else if (indexPath.section == 12){
        return 222;
    }else if (indexPath.section == 3){
        return 88;
    }else if (indexPath.section == 4){
        return 88;
    }else if (indexPath.section == 5){
        return 88;
    }
    else{
        return adaptY(100);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor redColor];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    
    return headerView;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 计算当前偏移位置
    CGFloat threholdHeight = (SCREEN_WIDTH * 9 / 16) - 64;
    if (scrollView.contentOffset.y >= 0 &&
        scrollView.contentOffset.y <= threholdHeight) {
        self.alpha = scrollView.contentOffset.y / threholdHeight;
        self.navigationView.alpha = self.alpha;
    }
    else if (scrollView.contentOffset.y < 0){
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    else{
        self.navigationView.alpha = 1.0;
        self.shareBtn.alpha = 0.0f;
        self.collectBtn.alpha = 0.0f;
    }
    
    if (self.alpha == 0) {
        self.shareBtn.alpha = 1.0;
        self.collectBtn.alpha = 1.0;
    }
    
    if (scrollView.contentOffset.y > threholdHeight &&
        self.navigationView.alpha == 1.0) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        [self.navigationView navigationAnimation];
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [self.navigationView resetFrame];
    }
}

#pragma mark - NavigationViewDelegate
- (void)NavigationViewWithScrollerButton:(UIButton *)btn{
    
}
- (void)NavigationViewGoBack{
    
}
- (void)NavigationViewGoShare{
    
}
- (void)NavigationViewGoCollect{
    
}

@end
