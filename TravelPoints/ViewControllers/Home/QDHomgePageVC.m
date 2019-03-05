//
//  QDHomgePageVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/17.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDHomgePageVC.h"
#import "QDHomePageTopView.h"
#import "HYBCardCollectionViewCell.h"
#import "QDHomePageViewCell.h"
#import "ZLCollectionView.h"
#import "QDVipPurchaseVC.h"
#import "NavigationView.h"
#import "QDSearchViewController.h"
#import "QDOrderField.h"
#import "RanklistDTO.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "QDRefreshHeader.h"
#import "QDRefreshFooter.h"
#import "QDCitySelectedViewController.h"
static NSString *cellIdentifier = @"CellIdentifier";

@interface QDHomgePageVC ()<UITableViewDelegate, UITableViewDataSource, NavigationViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, getChoosedAreaDelegate>{
    QDHomePageTopView *_homePageTopView;
    NSMutableArray *_rankTypeArr;             //榜单类型type值数组
    NSMutableArray *_rankTotalArr;            //所有的榜单数据
    NSMutableArray *_rankFirstArr;            //榜单第一名数组
    NSMutableArray *_rankTableViewData;       //tableView数据源数组
    NSMutableArray *_currentTableViewData;    //当前tableView的数据源


}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NavigationView *navigationView;
@property (nonatomic, strong) ZLCollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentTypeIndex;

@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *collectBtn;


@end

@implementation QDHomgePageVC

- (void)test{
    QDLog(@"===================");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(test)
//                                                 name:@"123" object:nil];

    self.tabBarController.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(horizontalSilde:) name:@"horizontalSilde" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)horizontalSilde:(NSNotification *)notification {
    QDLog(@"info = %@", notification.object);
    int ss = [notification.object intValue];
    if (ss == 0) {
        _currentTableViewData = _rankTableViewData[ss];
    }else{
        _currentTableViewData = _rankTableViewData[ss-1];
    }
    //重新刷新第二个section的内容
    [UIView performWithoutAnimation:^{
        [_tableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_WHITECOLOR;
    _rankTypeArr = [[NSMutableArray alloc] init];
    _rankTotalArr = [[NSMutableArray alloc] init];
    _rankFirstArr = [[NSMutableArray alloc] init];
    _rankTableViewData = [[NSMutableArray alloc] init];
    _currentTableViewData = [[NSMutableArray alloc] init];
    [self findRankType];
//    [_navigationView.iconBtn addTarget:self action:@selector(theNewPage:) forControlEvents:UIControlEventTouchUpInside];
}

/*
 
 "interfaceName": "com.quantdo.lyjf.consumer.service.RanklistService",
 "interfaceVersion": "1.0.0",
 "method": "rankTypeToSort",
 "params": [[
 {
 "rankType": 5,
 "rankSort": 1
 
 },
 {
 "rankType": 6,
 "rankSort": 2
 
 }
 ]
 
 ]
 }
 */
/**
 
 */
- (void)getRankedSortingWithTypeStr:(NSString *)typeStr{
    NSDictionary * dic1 = @{@"listType":typeStr};
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_RankedSorting params:dic1 successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            _currentTypeIndex++;
            NSDictionary *dic = responseObject.result;
            NSArray *hotelArr = [dic objectForKey:@"result"];
            NSMutableArray *detailArr = [[NSMutableArray alloc] init];
            if (hotelArr.count) {
                for (NSDictionary *dic in hotelArr) {
                    RanklistDTO *listDTO = [RanklistDTO yy_modelWithDictionary:dic];
                    [detailArr addObject:listDTO];
                }
                [_rankTotalArr addObject:detailArr];
            }
            if (_currentTypeIndex < _rankTypeArr.count) {
                [self getRankedSortingWithTypeStr:_rankTypeArr[_currentTypeIndex]];
            }else{
                QDLog(@"_rankTotalArr = %@", _rankTotalArr);
                //处理数据
                if (_rankFirstArr.count) {
                    [_rankFirstArr removeAllObjects];
                }
                //collectionView的数据源
                for (int i = 0; i < _rankTotalArr.count; i++) {
                    RanklistDTO *model = [_rankTotalArr[i] firstObject];
                    [_rankFirstArr addObject:model];
                }
                QDLog(@"_rankFirstArr = %@", _rankFirstArr);
                
                //tableView的数据源
                for (int i = 0; i < _rankTotalArr.count; i++) {
                    NSMutableArray *arr = _rankTotalArr[i];
                    [arr removeObjectAtIndex:0];
                    [_rankTableViewData addObject:arr];
                }
                _currentTableViewData = _rankTableViewData[0];
                QDLog(@"_rankFirstArr = %@, _rankTableViewData = %@, _currentTableViewData = %@", _rankFirstArr, _rankTableViewData, _currentTableViewData);
                if (_tableView) {
                    [_tableView reloadData];
                }else{
                    [self initTableView];
                }
            }
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
        [self initTableView];
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
    }];
}

/**
榜单类型排序查询
 */
- (void)findRankType{
    if (_rankTypeArr.count) {
        [_rankTypeArr removeAllObjects];
    }
    _currentTypeIndex = 0;
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_FindRankTypeToSort params:nil successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSArray *resultArr = responseObject.result;
            for (NSDictionary *dic in resultArr) {
                [_rankTypeArr addObject:[dic objectForKey:@"rankType"]];
            }
            QDLog(@"_rankTypeArr = %@", _rankTypeArr);
        }
        if (_rankTypeArr.count) {
            [self getRankedSortingWithTypeStr:_rankTypeArr[_currentTypeIndex]];
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
        [self initTableView];
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
    }];
}

- (void)theNewPage:(UIButton *)sender{
    QDSearchViewController *searchVC = [[QDSearchViewController alloc] init];
    searchVC.playShellType = QDHotelReserve;
    searchVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:searchVC animated:YES completion:nil];
}

//会员申购
- (void)hysgAction:(UIButton *)sender{
    switch (sender.tag) {
        case 1001:
        {
            QDVipPurchaseVC *purchaseVC = [[QDVipPurchaseVC alloc] init];
            self.navigationController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:purchaseVC animated:YES];
        }
        break;
        case 1002:
        {
            
        }
            break;
        case 1003:
        {
            
        }
            break;
        case 1004:
        {
            
        }
            break;
        default:
            break;
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = APP_WHITECOLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _homePageTopView = [[QDHomePageTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.36)];
        _homePageTopView.backgroundColor = APP_WHITECOLOR;
        [_homePageTopView.addressBtn addTarget:self action:@selector(getMyLocation:) forControlEvents:UIControlEventTouchUpInside];
        [_homePageTopView.hysgBtn addTarget:self action:@selector(hysgAction:) forControlEvents:UIControlEventTouchUpInside];
        [_homePageTopView.glBtn addTarget:self action:@selector(hysgAction:) forControlEvents:UIControlEventTouchUpInside];
        [_homePageTopView.dzyBtn addTarget:self action:@selector(hysgAction:) forControlEvents:UIControlEventTouchUpInside];
        [_homePageTopView.scBtn addTarget:self action:@selector(hysgAction:) forControlEvents:UIControlEventTouchUpInside];
        [_homePageTopView.searchBtn addTarget:self action:@selector(customerTourSearchAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _homePageTopView.iconBtn.layer.cornerRadius = SCREEN_WIDTH*0.11/2;
        _homePageTopView.iconBtn.layer.masksToBounds = YES;
        _homePageTopView.iconBtn.clipsToBounds = YES;
        //    [self.view addSubview:_homePageTopView];
        _tableView.tableHeaderView = _homePageTopView;
        [self.view addSubview:_tableView];
        _tableView.mj_header = [QDRefreshHeader headerWithRefreshingBlock:^{
            QDLog(@"===================");
            if (_rankTotalArr.count) {
                [_rankTotalArr removeAllObjects];
            }
            [self findRankType];
            [_tableView reloadData];
            [self endRefreshing];
        }];
        _tableView.mj_footer = [QDRefreshFooter footerWithRefreshingBlock:^{
            QDLog(@"===================");
            [self endRefreshing];
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            [_tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }];
    }
    return _tableView;
}

#pragma mark - 定位:我的位置
- (void)getMyLocation:(UIButton *)sender{
    QDCitySelectedViewController *locationVC = [[QDCitySelectedViewController alloc] init];
    locationVC.delegate = self;
    locationVC.selectCity = ^(NSString * _Nonnull cityName) {
        QDLog(@"cityName");
        [_homePageTopView.addressBtn setTitle:cityName forState:UIControlStateNormal];
    };
    [self presentViewController:locationVC animated:YES completion:nil];
}

#pragma mark - 首页搜索
- (void)customerTourSearchAction:(UIButton *)sender{
    QDSearchViewController *searchVC = [[QDSearchViewController alloc] init];
    searchVC.playShellType = QDCustomTour;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)endRefreshing
{
    if (_tableView) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}

- (void)initTableView{
    [self.view addSubview:self.tableView];
    
//    [self configNavigationBar];
//    [self.view addSubview:self.navigationView];
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
- (NavigationView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[NavigationView alloc]init];
        _navigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
        _navigationView.backgroundColor = [UIColor whiteColor];
        _navigationView.backgroundColor = APP_WHITECOLOR;
        _navigationView.alpha = 0.0;
        _navigationView.naviDelegate = self;
    }
    return _navigationView;
}

#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        if (_currentTableViewData.count) {
            return _currentTableViewData.count;
        }else{
            return 1;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.68;
}

- (ZLCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [ZLCollectionView collectionViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.72) itemCount:_rankTypeArr.count];
        _collectionView.rankFirstArr = _rankFirstArr;
    }
    return _collectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identifier = @"UITableViewCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
//        self.collectionView.selectedItems = ^(NSIndexPath *indexPath) {
//            NSLog(@"ItemTag:%ld",indexPath.item);
//            //这里可能要点击切换
//        };
//        [self.collectionView didSelectedItemsWithBlock:^(NSIndexPath *indexPath) {
//            QDLog(@"%ld", (long)indexPath.row);
//        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_collectionView) {
            [_collectionView.mainCollectionView reloadData];
        }else{
            [cell.contentView addSubview:self.collectionView];
        }

//        if () {
//            <#statements#>
//        }
        return cell;
    }else{
        static NSString *identifier2 = @"QDHomePageViewCell";
        QDHomePageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            cell = [[QDHomePageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        QDLog(@"index.row = %ld", (long)indexPath.row);
        if (_currentTableViewData.count) {
            [cell loadTableViewCellDataWithModel:_currentTableViewData[indexPath.row]];
        }else{
            [_tableView reloadEmptyDataSet];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = APP_WHITECOLOR;
        return cell;
    }
    return nil;
}

#pragma mark - ScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    // 计算当前偏移位置
//    CGFloat threholdHeight = (SCREEN_WIDTH * 9 / 16) - 64;
//    if (scrollView.contentOffset.y >= 0 &&
//        scrollView.contentOffset.y <= threholdHeight) {
//        self.alpha = scrollView.contentOffset.y / threholdHeight;
//        self.navigationView.alpha = self.alpha;
//    }
//    else if (scrollView.contentOffset.y < 0){
//        scrollView.contentOffset = CGPointMake(0, 0);
//    }
//    else{
//        self.navigationView.alpha = 1.0;
//        self.shareBtn.alpha = 0.0f;
//        self.collectBtn.alpha = 0.0f;
//    }
//
//    if (self.alpha == 0) {
//        self.shareBtn.alpha = 1.0;
//        self.collectBtn.alpha = 1.0;
//    }
//
//    if (scrollView.contentOffset.y > threholdHeight &&
//        self.navigationView.alpha == 1.0) {
//        [self.navigationView navigationAnimation];
//        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    }else{
//        [self.navigationView resetFrame];
//    }
//}
#pragma mark - NavigationViewDelegate
- (void)NavigationViewWithScrollerButton:(UIButton *)btn{
    
}
- (void)NavigationViewGoBack{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationView navigationAnimation];
    _tableView.contentOffset = CGPointMake(0, 0);
    self.navigationView.alpha = 0;
}
- (void)NavigationViewGoShare{
    
}
- (void)NavigationViewGoCollect{
    
}

#pragma mark - emptyDataSource
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
    return SCREEN_HEIGHT*0.42;
}

@end
