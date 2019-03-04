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
#import "QDHotelTypeView.h"
#import "QDBridgeViewController.h"
#import "QDCalendarViewController.h"
#import "QDHotelListInfoModel.h"
#import "QDRefreshHeader.h"
#import "QDRefreshFooter.h"
#import "TFDropDownMenu.h"
#import "SDWebImageManager.h"

typedef enum : NSUInteger {
    QDFilterArea,
    QDFilterHotelType,
    QDFilterHotelPrice,
    QDFilterLevel
} QDFilterType;
@interface QDHotelVC ()<UITableViewDelegate, UITableViewDataSource, NavigationViewDelegate, TFDropDownMenuViewDelegate>{
    UITableView *_tableView;
    QDHotelHeaderView *_headView;
    QDHotelTypeView *_typeView;
    NSMutableArray *_hotelListInfoArr;
    NSMutableArray *_hotelImgArr;
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
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self requestHotelInfoWithURL:api_GetHotelCondition];
}

- (void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController.tabBarController.tabBar setHidden:YES];
//    self.navigationController.tabBarController.tabBar.frame = CGRectZero;
}
- (void)requestHotelInfoWithURL:(NSString *)urlStr{
    if (_hotelListInfoArr.count) {
        [_hotelListInfoArr removeAllObjects];
        [_hotelImgArr removeAllObjects];
    }
    NSDictionary * dic1 = @{@"label":@"",
                            @"pageNum":@1,
                            @"pageSize":@20
                            };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:dic1 successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *hotelArr = [dic objectForKey:@"result"];
            if (hotelArr.count) {
                for (NSDictionary *dic in hotelArr) {
                    QDHotelListInfoModel *infoModel = [QDHotelListInfoModel yy_modelWithDictionary:dic];
                    [_hotelListInfoArr addObject:infoModel];
                    
                    NSDictionary *dic = [infoModel.imageList firstObject];
                    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", QD_Domain, [dic objectForKey:@"imageUrl"]];
                    QDLog(@"urlStr = %@", urlStr);
//                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
                    [_hotelImgArr addObject:urlStr];
                }
                [_tableView reloadData];
            }
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);//所需高度
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self configNavigationBar];
    _hotelListInfoArr = [[NSMutableArray alloc] init];
    _hotelImgArr = [[NSMutableArray alloc] init];
    [self.view addSubview:self.navgationView];
}

#pragma mark - UI
//导航栏
- (void)configNavigationBar{
    WS(ws);
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-48) style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
       _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = view;
    _tableView.mj_footer = [QDRefreshFooter footerWithRefreshingBlock:^{
        QDLog(@"sss");
        [self endRefreshing];
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    _headView = [[QDHotelHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.6)];
    [_headView.searchView.locateBtn addTarget:self action:@selector(myLocation:) forControlEvents:UIControlEventTouchUpInside];
    [_headView.searchView.dateIn addTarget:self action:@selector(chooseRoomInOrOut:) forControlEvents:UIControlEventTouchUpInside];
    _tableView.tableHeaderView = _headView;
}

#pragma mark - 定位:我的位置
- (void)myLocation:(UIButton *)sender{
    QDCitySelectedViewController *locationVC = [[QDCitySelectedViewController alloc] init];
    [self presentViewController:locationVC animated:YES completion:nil];
}

#pragma mark - 选择入住时间(自定义日历)
- (void)chooseRoomInOrOut:(UIButton *)sender{
    QDCalendarViewController * calendar = [[QDCalendarViewController alloc] init];
    [self presentViewController:calendar animated:YES completion:nil];
}
#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _hotelListInfoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_HEIGHT*0.075;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.225;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"QDHotelTableViewCell";
    QDHotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[QDHotelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    [cell fillContentWithModel:_hotelListInfoArr[indexPath.row] andImgURLStr:_hotelImgArr[indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"全部区域", nil];
    NSMutableArray *array2 = [NSMutableArray arrayWithObjects:@"酒店类型",@"不限",@"主题乐园",@"亲子酒店",@"休闲度假",@"公寓",@"商务出行",@"客栈", nil];
    NSMutableArray *array3 = [NSMutableArray arrayWithObjects:@"价格", nil];
    NSMutableArray *array4 = [NSMutableArray arrayWithObjects:@"星级",@"经济型",@"舒适/三星",@"高档/四星",@"豪华/五星", nil];
    
    NSMutableArray *data1 = [NSMutableArray arrayWithObjects:array1, array2, array3, array4, nil];
    NSMutableArray *data2 = [NSMutableArray arrayWithObjects:@[], @[], @[], @[], nil];

    TFDropDownMenuView *menu = [[TFDropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40) firstArray:data1 secondArray:data2];
//    menu.separatorColor = [UIColor greenColor];
    menu.cellTextSelectColor = APP_BLUECOLOR;
    menu.itemFontSize = 12;
    menu.cellTitleFontSize = 12;
    menu.itemTextSelectColor = APP_BLUECOLOR;
    
    /*风格*/
//    menu.menuStyleArray = [NSMutableArray arrayWithObjects:
//                           [NSNumber numberWithInteger:TFDropDownMenuStyleTableView],
//                           [NSNumber numberWithInteger:TFDropDownMenuStyleTableView],
//                           [NSNumber numberWithInteger:TFDropDownMenuStyleTableView],
//                           [NSNumber numberWithInteger:TFDropDownMenuStyleCustom],nil];
    
    menu.delegate = self;
    return menu;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    QDHotelListInfoModel *model = _hotelListInfoArr[indexPath.row];
    //传递ID
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?id=%ld", QD_JSURL, JS_HOTELDETAIL, (long)model.id];
    QDLog(@"urlStr = %@", bridgeVC.urlStr);
    bridgeVC.infoModel = model;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bridgeVC animated:YES];
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
    
//    if (scrollView.contentOffset.y > threholdHeight &&
//        self.navigationView.alpha == 1.0) {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//        [self.navigationView navigationAnimation];
//        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    }else{
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//        [self.navigationView resetFrame];
//    }
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
- (void)endRefreshing
{
    if (_tableView) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}

#pragma mark - TFDropDownMenuView Delegate

- (void)menuView:(TFDropDownMenuView *)menu selectIndex:(TFIndexPatch *)index{
    QDLog(@"index: %@",index);
}

- (void)menuView:(TFDropDownMenuView *)menu tfColumn:(NSInteger)column{
    QDLog(@"column:%ld", (long)column);
    switch (column) {
        case 0:
            //选择全部区域
        {
//            QDCitySelectedViewController *locationVC = [[QDCitySelectedViewController alloc] init];
//            [self presentViewController:locationVC animated:YES completion:nil];

        }
            break;
            
        default:
            break;
    }
}


@end
