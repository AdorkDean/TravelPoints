//
//  QDHotelVC.m
//  QDINFI
//
//  Created by 冉金 on 2017/12/8.
//  Copyright © 2017年 quantdo. All rights reserved.
//

#import "QDHotelVC.h"
#import "QDHotelTableViewCell.h"
#import "NavigationView.h"
#import "QDHotelHeaderView.h"
#import "QDCitySelectedViewController.h"
@interface QDHotelVC ()<UITableViewDelegate, UITableViewDataSource, NavigationViewDelegate>{
    UITableView *_tableView;
    QDHotelHeaderView *_headView;
}
@property (nonatomic, strong) NavigationView *navigationView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *collectBtn;

@property (nonatomic, assign) CGFloat alpha;
@end

@implementation QDHotelVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 导航栏透明
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    // 导航栏不透明
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self showBack:YES];
    self.title = @"酒店";
    [self initTableView];
    [self configNavigationBar];
    [self.view addSubview:self.navgationView];
}

#pragma mark - UI
//导航栏
- (void)configNavigationBar{
    WS(ws);
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setImage:[UIImage imageNamed:@"ad_back_white"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"ad_share_white"] forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:@"ad_share_red"] forState:UIControlStateSelected];
    [_shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_collectBtn setImage:[UIImage imageNamed:@"ad_collection_white"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"ad_collection_red"] forState:UIControlStateSelected];

    [self.view addSubview:_shareBtn];
    [self.view addSubview:_collectBtn];
    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).offset(35);
        make.right.equalTo(ws.view).offset(-73);
        make.size.mas_offset(CGSizeMake(22, 22));
    }];
    
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareBtn);
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
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    _headView = [[QDHotelHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.6)];
    [_headView.searchView.locateBtn addTarget:self action:@selector(myLocation:) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableHeaderView = _headView;
}

#pragma mark - 定位:我的位置
- (void)myLocation:(UIButton *)sender{
    QDCitySelectedViewController *locationVC = [[QDCitySelectedViewController alloc] init];
    [self presentViewController:locationVC animated:YES completion:nil];
}
#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.225;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"QDHotelTableViewCell";
    QDHotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[QDHotelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //设置cell点击时的颜色
//    UIView *backgroundViews = [[UIView alloc]initWithFrame:cell.frame];
//    backgroundViews.backgroundColor = [UIColor whiteColor];
//    [cell setSelectedBackgroundView:backgroundViews];
//    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.085)];
    view.backgroundColor = [UIColor redColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationView navigationAnimation];
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.navigationView.alpha = 0;
    self.shareBtn.alpha = 0.0f;
    self.collectBtn.alpha = 0.0f;
    QDLog(@"back");
}
- (void)NavigationViewGoShare{
    
}
- (void)NavigationViewGoCollect{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
