//
//  QDPlayingShellsVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/15.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDPlayingShellsVC.h"
#import "QDSegmentControl.h"
#import "QDHotelReserveTableHeaderView.h"
#import "QDHotelTableViewCell.h"
#import "QDCustomTourCell.h"
#import "QDMallTableCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "QDLocationTopSelectView.h"
#import "QDCustomTourSectionHeaderView.h"
#import "QDRefreshHeader.h"
#import "QDRefreshFooter.h"
#import "QDMallTableHeaderView.h"
#import "QDMallModel.h"
#import "QDCalendarViewController.h"
#import "QDCitySelectedViewController.h"
#import "QDBridgeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "QDKeyWordsSearchVC.h"
#import "QDSearchViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
//预定酒店 定制游 商城
@interface QDPlayingShellsVC ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, CLLocationManagerDelegate, SendDateStrDelegate, UITextFieldDelegate, getChoosedAreaDelegate>{
    QDPlayShellType _playShellType;
    QDSegmentControl *_segmentControl;
    UITableView *_tableView;
    QDHotelReserveTableHeaderView *_headerView;
    QDMallTableHeaderView *_mallHeaderView;
    QDCustomTourSectionHeaderView *_customTourHeaderView;
    
    NSMutableArray *_hotelListInfoArr;
    NSMutableArray *_hotelImgArr;
    
    NSMutableArray *_dzyListInfoArr;
    NSMutableArray *_dzyImgArr;
    
    NSMutableArray *_mallInfoArr;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation QDPlayingShellsVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchSegmented:) name:@"switchSegmented" object:nil];
    QDLog(@"%f", self.tabBarController.tabBar.frame.size.height);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTabBarBtn) name:@"removeTabBarBtn" object:nil];
}

- (void)switchSegmented:(NSNotification *)noti{
    QDLog(@"===================");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];    //停止定位
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"switchSegmented" object:nil];
}

- (void)removeTabBarBtn
{
    //    NSArray *tSubviews = self.tabBarController.tabBar.subviews;
    //    for (int i = 0; i < tSubviews.count; i++) {
    //        Class parentVCClass = [tSubviews[i] class];
    //        NSString *className = NSStringFromClass(parentVCClass);
    //        ALog(@"%d---%@",i, className);
    //
    //    }
    
    for (UIView *tabBar in self.tabBarController.tabBar.subviews) {
        if ([tabBar isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBar removeFromSuperview];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_WHITECOLOR;
    _hotelListInfoArr = [[NSMutableArray alloc] init];
    _hotelImgArr = [[NSMutableArray alloc] init];
    
    _dzyListInfoArr = [[NSMutableArray alloc] init];
    _dzyImgArr = [[NSMutableArray alloc] init];
    
    _mallInfoArr = [[NSMutableArray alloc] init];
    
    //分段选择按钮
    NSArray *segmentedTitles = @[@"预定酒店",@"定制游",@"商城"];
    _segmentControl = [[QDSegmentControl alloc] initWithSectionTitles:segmentedTitles];
    [_segmentControl addTarget:self action:@selector(segmentedClicked:) forControlEvents:UIControlEventValueChanged];
    _segmentControl.selectionIndicatorColor = APP_BLUECOLOR;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: APP_BLACKCOLOR, NSFontAttributeName: QDFont(16)};
    _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName: APP_GRAYCOLOR, NSFontAttributeName: QDFont(15)};
    [self.view addSubview:_segmentControl];
    [_segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT*0.05);
        make.width.mas_equalTo(SCREEN_WIDTH*0.7);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.06);
    }];
    [self initTableView];
    [self locate];
    if (_segmentControl.selectedSegmentIndex == 0) {
        [self requestHotelInfoWithURL:api_GetHotelCondition andIsPushVC:NO];
    }else if (_segmentControl.selectedSegmentIndex == 1){
        [self requestDZYList:api_GetDZYList];
    }
}

#pragma mark - locate
- (void)locate{
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8){
            [_locationManager requestWhenInUseAuthorization];
        }
        [_locationManager startUpdatingLocation];   //开启定位
    }else{
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 开始定位
    [_locationManager startUpdatingLocation];
}

#pragma mark - 请求酒店信息
- (void)requestHotelInfoWithURL:(NSString *)urlStr andIsPushVC:(BOOL)pushVC{
    if (_hotelListInfoArr.count) {
        [_hotelListInfoArr removeAllObjects];
        [_hotelImgArr removeAllObjects];
    }
    NSDictionary * dic1 = @{@"hotelName":_headerView.locationTF.text,
                            @"cityName":_headerView.locationLab.text,
                            @"pageNum":@1,
                            @"pageSize":@10
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
                    NSString *urlStr = [dic objectForKey:@"imageFullUrl"];
                    QDLog(@"urlStr = %@", urlStr);
                    [_hotelImgArr addObject:urlStr];
                }
                if (pushVC) {
                    QDKeyWordsSearchVC *keyVC = [[QDKeyWordsSearchVC alloc] init];
                    keyVC.playShellType = QDHotelReserve;    //酒店预订的类型
                    NSString *ss = _headerView.dateIn.titleLabel.text;
                    NSString *sss = _headerView.dateOut.titleLabel.text;
                    if(ss.length >= 10 && sss.length >= 10){
                        keyVC.dateInStr = [_headerView.dateIn.titleLabel.text substringWithRange:NSMakeRange(5, 5)];
                        keyVC.dateOutStr = [_headerView.dateOut.titleLabel.text substringWithRange:NSMakeRange(5, 5)];
                    }else{
                        keyVC.dateInStr = [_headerView.dateIn.titleLabel.text substringWithRange:NSMakeRange(0, 5)];
                        keyVC.dateOutStr = [_headerView.dateOut.titleLabel.text substringWithRange:NSMakeRange(0, 5)];
                    }
                    keyVC.keyWords = _headerView.locationTF.text;
                    keyVC.cityName = _headerView.locationLab.text;
                    [self.navigationController pushViewController:keyVC animated:YES];
                }else{
                    [_tableView reloadData];
                }
                [self endRefreshing];
            }else{
                [WXProgressHUD showErrorWithTittle:@"无数据返回,请重试"];
            }
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
    }];
}

- (void)segmentedClicked:(QDSegmentControl *)segmentControl{
    //先将tableView置于顶部
    [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _playShellType = (QDPlayShellType)segmentControl.selectedSegmentIndex;
    switch (_playShellType) {
        case QDHotelReserve: //酒店预定
            [_tableView reloadData];
            _tableView.tableHeaderView = _headerView;
            [self requestHotelInfoWithURL:api_GetHotelCondition andIsPushVC:NO];
            QDLog(@"0");
            break;
        case QDCustomTour: //定制游
            QDLog(@"1");
            [_tableView reloadData];
            _customTourHeaderView = [[QDCustomTourSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.12)];
            [_customTourHeaderView.searchBtn addTarget:self action:@selector(customerTourSearchAction:) forControlEvents:UIControlEventTouchUpInside];
            _customTourHeaderView.backgroundColor = APP_WHITECOLOR;
            _tableView.tableHeaderView = _customTourHeaderView;
            [self requestDZYList:api_GetDZYList];
            break;
        case QDMall: //商城
        {
            [_tableView reloadData];
            _mallHeaderView = [[QDMallTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.08)];
            _mallHeaderView.backgroundColor = APP_WHITECOLOR;
            _tableView.tableHeaderView = _mallHeaderView;
            [self requestMallList:api_GetMallList];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 请求定制游列表信息
- (void)requestDZYList:(NSString *)urlStr{
    if (_dzyListInfoArr.count) {
        [_dzyListInfoArr removeAllObjects];
        [_dzyImgArr removeAllObjects];
    }
    NSDictionary * dic1 = @{@"travelName":@"",
                            @"pageNum":@1,
                            @"pageSize":@10
                            };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:dic1 successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *dzyArr = [dic objectForKey:@"result"];
            if (dzyArr.count) {
                for (NSDictionary *dic in dzyArr) {
                    CustomTravelDTO *infoModel = [CustomTravelDTO yy_modelWithDictionary:dic];
                    [_dzyListInfoArr addObject:infoModel];
                    NSDictionary *dic = [infoModel.imageList firstObject];
                    [_dzyImgArr addObject:[dic objectForKey:@"url"]];
                }
                QDLog(@"_dzyImgArr = %@", _dzyImgArr);
                [_tableView reloadData];
            }
        }else{
            [WXProgressHUD showErrorWithTittle:responseObject.message];
            [_tableView reloadData];
            [_tableView reloadEmptyDataSet];
        }
        [self endRefreshing];
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}


#pragma mark - 查询商城列表信息
- (void)requestMallList:(NSString *)urlStr{
    if (_mallInfoArr.count) {
        [_mallInfoArr removeAllObjects];
    }
    NSDictionary * dic1 = @{@"sortColumn":@"",
                            @"sortType":@"desc",
                            @"pageNum":@1,
                            @"pageSize":@10
                            };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:dic1 successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *mallArr = [dic objectForKey:@"result"];
            if (mallArr.count) {
                for (NSDictionary *dic in mallArr) {
                    QDMallModel *mallModel = [QDMallModel yy_modelWithDictionary:dic];
                    [_mallInfoArr addObject:mallModel];
                }
                QDLog(@"_mallInfoArr = %@", _mallInfoArr);
                [_tableView reloadData];
            }
        }
        [self endRefreshing];
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.11+3, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
//    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.backgroundColor = APP_WHITECOLOR;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaTopHeight, 0);
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.41)];
    view.backgroundColor = APP_LIGHTGRAYCOLOR;
    view.alpha = 0.5;
    _headerView = [[QDHotelReserveTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.41)];
    QDLog(@"%@ %@", _headerView.dateInStr, _headerView.dateOutStr);
    _headerView.backgroundColor = [UIColor colorWithHexString:@"#C0C5CD"];
    [_headerView.dateIn addTarget:self action:@selector(chooseRoomInOrOut:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.dateOut addTarget:self action:@selector(chooseRoomInOrOut:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.locateBtn addTarget:self action:@selector(myLocation:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.searchBtn addTarget:self action:@selector(startSearch:) forControlEvents:UIControlEventTouchUpInside];

    _dateInPassedVal = _headerView.dateInPassVal;
    _dateOutPassedVal = _headerView.dateOutPassVal;
    _headerView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    _tableView.tableHeaderView = _headerView;
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [QDRefreshHeader headerWithRefreshingBlock:^{
        if (_playShellType == QDHotelReserve) {
            [self requestHotelInfoWithURL:api_GetHotelCondition andIsPushVC:NO];
        }else if (_playShellType == QDCustomTour){
            [self requestDZYList:api_GetDZYList];
        }else{
            [self requestMallList:api_GetMallList];
        }
    }];
    
    _tableView.mj_footer = [QDRefreshFooter footerWithRefreshingBlock:^{
        [self endRefreshing];
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    //手动刷新请求最新数据
    _tableView.mj_footer = [QDRefreshFooter footerWithRefreshingBlock:^{
        QDLog(@"sss");
        [self endRefreshing];
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

- (void)startSearch:(UIButton *)sender{
    QDKeyWordsSearchVC *keyVC = [[QDKeyWordsSearchVC alloc] init];
    keyVC.playShellType = QDHotelReserve;    //酒店预订的类型
    NSString *ss = _headerView.dateIn.titleLabel.text;
    NSString *sss = _headerView.dateOut.titleLabel.text;
    //
//    11ji
    
    keyVC.dateInPassedVal = _dateInPassedVal;
    keyVC.dateOutPassedVal =_dateOutPassedVal;
    keyVC.dateInStr = ss;
    keyVC.dateOutStr = sss;
    keyVC.keyWords = _headerView.locationTF.text;
    keyVC.cityName = _headerView.locationLab.text;
    [self.navigationController pushViewController:keyVC animated:YES];
}

- (void)endRefreshing
{
    if (_tableView) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}
#pragma mark - 选择入住时间(自定义日历)
- (void)chooseRoomInOrOut:(UIButton *)sender{
    QDCalendarViewController * calendar = [[QDCalendarViewController alloc] init];
    calendar.delegate = self;
    calendar.dateInStr = _headerView.dateInStr;
    calendar.dateOutStr = _headerView.dateOutStr;
    [calendar returnDate:^(NSString * _Nonnull startDate, NSString * _Nonnull endDate, NSString * _Nonnull dateInPassedVal, NSString * _Nonnull dateOutPassedVal, int totayDays) {
        [self sendDateStr:startDate andDateOutStr:endDate andDateInPassedVal:dateInPassedVal andDateOutPassedVal:dateOutPassedVal andTotalDays:totayDays];
    }];
    [self presentViewController:calendar animated:YES completion:nil];
}

- (void)sendDateStr:(NSString *)dateInStr andDateOutStr:(NSString *)dateOutStr andDateInPassedVal:(NSString *)dateInPassedStr andDateOutPassedVal:(NSString *)dateOutPassedStr andTotalDays:(int)totalDays{
    QDLog(@"dateInStr = %@", dateInStr);
    [_headerView.dateIn setTitle:dateInStr forState:UIControlStateNormal];
    [_headerView.dateOut setTitle:dateOutStr forState:UIControlStateNormal];
    //
    _dateInStr = dateInStr;
    _dateOutStr = dateOutStr;
    _dateInPassedVal = dateInPassedStr;
    _dateOutPassedVal = dateOutPassedStr;
    _headerView.dateInStr = dateInStr;
    _headerView.dateOutStr = dateOutStr;
    _headerView.totalDayLab.text = [NSString stringWithFormat:@"%d晚", totalDays];
}

#pragma mark - 定位:我的位置
- (void)myLocation:(UIButton *)sender{
    QDCitySelectedViewController *locationVC = [[QDCitySelectedViewController alloc] init];
    locationVC.delegate = self;
    locationVC.selectCity = ^(NSString * _Nonnull cityName) {
        QDLog(@"cityName");
        _headerView.locationLab.text = cityName;
    };
    [self presentViewController:locationVC animated:YES completion:nil];
}


- (void)getChoosedAreaName:(NSString *)areaStr{
    _headerView.locationLab.text = areaStr;
}
#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (_playShellType) {
        case QDHotelReserve:
            return _hotelListInfoArr.count;
            break;
        case QDCustomTour:
            return _dzyListInfoArr.count;
            break;
        case QDMall:
            return _mallInfoArr.count;
            break;
        default:
            break;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (_playShellType) {
        case QDHotelReserve:
            return SCREEN_HEIGHT*0.21;
            break;
        case QDCustomTour:
            return SCREEN_HEIGHT*0.57;
            break;
        case QDMall:
            return SCREEN_HEIGHT*0.225;
            break;
        default:
            break;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (_playShellType) {
        case QDHotelReserve:
            return SCREEN_HEIGHT*0.075;
            break;
        case QDCustomTour:
            return 0.01;
            break;
        case QDMall:
//            return SCREEN_HEIGHT*0.08;
            return 0.01;
            break;
        default:
            break;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 35)];
//    lab.text = @"    为你推荐";
//    lab.font = QDBoldFont(18);
//    lab.textColor = APP_BLACKCOLOR;
//    lab.backgroundColor = APP_WHITECOLOR;
//    return lab;
    if (_playShellType == QDHotelReserve) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 35)];
        lab.text = @"    为你推荐";
        lab.font = QDBoldFont(18);
        lab.textColor = APP_BLACKCOLOR;
        lab.backgroundColor = APP_WHITECOLOR;
        return lab;
    }else{
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
//    else if (_playShellType == QDCustomTour){
//        _customTourHeaderView = [[QDCustomTourSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.06)];
//        _customTourHeaderView.backgroundColor = APP_WHITECOLOR;
//        return _customTourHeaderView;
//    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_playShellType == QDHotelReserve) {
        static NSString *identifier = @"QDHotelTableViewCell";
        QDHotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[QDHotelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_hotelListInfoArr.count) {
            [cell fillContentWithModel:_hotelListInfoArr[indexPath.row] andImgURLStr:_hotelImgArr[indexPath.row]];
        }
        return cell;
    }else if (_playShellType == QDCustomTour){
        static NSString *identifier = @"QDCustomTourCell";
        QDCustomTourCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[QDCustomTourCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_dzyListInfoArr.count > 0) {
            [cell fillCustomTour:_dzyListInfoArr[indexPath.row] andImgURL:_dzyImgArr[indexPath.row]];
        }
        return cell;
    }else{
        static NSString *identifier = @"QDMallTableCell";
        QDMallTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[QDMallTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (_mallInfoArr.count > 0) {
            [cell fillContentWithModel:_mallInfoArr[indexPath.row]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = APP_WHITECOLOR;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_playShellType == QDHotelReserve) {
        if (_hotelListInfoArr.count) {
            QDHotelListInfoModel *model = _hotelListInfoArr[indexPath.row];
            //传递ID
            QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
            bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?id=%ld&&startDate=%@&&endDate=%@", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_HOTELDETAIL, (long)model.id, _dateInPassedVal, _dateOutPassedVal];
            QDLog(@"urlStr = %@", bridgeVC.urlStr);
            bridgeVC.infoModel = model;
            self.tabBarController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bridgeVC animated:YES];
        }
    }else if (_playShellType == QDCustomTour){
        if (_dzyListInfoArr.count) {
            CustomTravelDTO *model = _dzyListInfoArr[indexPath.row];
            //传递ID
            QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
            bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?id=%ld", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_CUSTOMERTRAVEL, (long)model.id];
            QDLog(@"urlStr = %@", bridgeVC.urlStr);
            bridgeVC.customTravelModel = model;
            [self.navigationController pushViewController:bridgeVC animated:YES];
        }
    }else{
        if (_mallInfoArr.count) {
            QDMallModel *model = _mallInfoArr[indexPath.row];
            QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
            bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?id=%ld", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_SHOPPING, (long)model.id];
            QDLog(@"urlStr = %@", bridgeVC.urlStr);
            bridgeVC.mallModel = model;
            self.tabBarController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bridgeVC animated:YES];
        }
    }
}

//取消tableView的悬停效果
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(scrollView == _tableView) {
//        CGFloat sectionHeaderHeight = SCREEN_HEIGHT*0.075;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}
#pragma mark - DZNEmtpyDataSet Delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"emptySource"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    if (_playShellType == QDHotelReserve) {
        return SCREEN_HEIGHT*0.14;
    }else if (_playShellType == QDCustomTour){
        return 0;
    }else{
        return 0;
    }
    return SCREEN_HEIGHT*0.14;
}

//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"This allows you to share photos from your";
//    
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
//                                 NSForegroundColorAttributeName: APP_BLUECOLOR,
//                                 NSParagraphStyleAttributeName: paragraph};
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

#pragma mark - CLLocationManagerDelegate
/**
 *  只要定位到用户的位置，就会调用（调用频率特别高）
 *  @param locations : 装着CLLocation对象
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    NSLog(@"经度=%f 纬度=%f 高度=%f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, currentLocation.altitude);
    
    //根据经纬度反向地理编译出地址信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
        for (CLPlacemark * placemark in array) {
            
            NSDictionary *address = [placemark addressDictionary];
            
            //  Country(国家)  State(省)  City（市）
            NSLog(@"#####%@",address);
            
            NSLog(@"%@", [address objectForKey:@"Country"]);
            
            NSLog(@"%@", [address objectForKey:@"State"]);
            
            NSLog(@"%@", [address objectForKey:@"City"]);
            _headerView.locationLab.text = [address objectForKey:@"City"];
            //发送通知
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    if ([error code] == kCLErrorDenied){
        //访问被拒绝
        [WXProgressHUD showErrorWithTittle:@"访问被拒绝"];
        _headerView.locationLab.text = @"定位失败";
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        [WXProgressHUD showErrorWithTittle:@"无法获取位置信息"];
        _headerView.locationLab.text = @"定位失败";
        QDLog(@"kCLErrorLocationUnknown");
    }
}

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event{
    QDLog(@"123123");
}

- (void)customerTourSearchAction:(UIButton *)sender{
    QDSearchViewController *searchVC = [[QDSearchViewController alloc] init];
    searchVC.playShellType = QDCustomTour;
    [self.navigationController pushViewController:searchVC animated:YES];
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    QDLog(@"textFieldShouldBeginEditing");
////    [_customTourHeaderView.inputTF resignFirstResponder];
//    QDSearchViewController *searchVC = [[QDSearchViewController alloc] init];
//    searchVC.playShellType = QDCustomTour;
//    [self.navigationController pushViewController:searchVC animated:YES];
//    return YES;
//}

@end
