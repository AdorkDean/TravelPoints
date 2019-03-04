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
static NSString *cellIdentifier = @"CellIdentifier";

@interface QDHomgePageVC ()<UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, NavigationViewDelegate>{
    QDHomePageTopView *_homePageTopView;
    UITableView *_tableView;
    NSMutableArray *_rankTypeArr;             //榜单类型type值数组
    NSMutableArray *_rankTotalArr;            //所有的榜单数据
    NSMutableArray *_rankTypeDetailList;      //榜单类型排序数组
}
@property (nonatomic, strong) NavigationView *navigationView;
@property (nonatomic, strong) ZLCollectionView *collectionView;

@property (nonatomic, assign) CGFloat alpha;


@end

@implementation QDHomgePageVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(horizontalSilde:) name:@"horizontalSilde" object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)horizontalSilde:(NSNotification *)notification {
    QDLog(@"info = %@", notification.userInfo);
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rankTypeArr = [[NSMutableArray alloc] init];
    _rankTotalArr = [[NSMutableArray alloc] init];
    _rankTypeDetailList = [[NSMutableArray alloc] init];
    [self findRankType:api_FindRankTypeToSort];
    self.view.backgroundColor = APP_WHITECOLOR;
    [self configNavigationBar];
    [self.view addSubview:self.navigationView];
    [_navigationView.iconBtn addTarget:self action:@selector(theNewPage:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)getRankedSorting:(NSString *)urlStr andTypeStr:(NSString *)typeStr{
    if (_rankTypeDetailList.count) {
        [_rankTypeDetailList removeAllObjects];
    }
    NSDictionary * dic1 = @{@"listType":typeStr};
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:dic1 successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *hotelArr = [dic objectForKey:@"result"];
            if (hotelArr.count) {
                for (NSDictionary *dic in hotelArr) {
                    RanklistDTO *listDTO = [RanklistDTO yy_modelWithDictionary:dic];
                    [_rankTypeDetailList addObject:listDTO];
                }
                [_rankTotalArr addObject:_rankTypeDetailList];
            }
            [self initTableView];
            QDLog(@"_rankTypeArr = %@", _rankTypeArr);
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}

/**
榜单类型排序查询
 */
- (void)findRankType:(NSString *)urlStr{
    if (_rankTypeArr.count) {
        [_rankTypeArr removeAllObjects];
    }
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:nil successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSArray *resultArr = responseObject.result;
            for (NSDictionary *dic in resultArr) {
                [_rankTypeArr addObject:[dic objectForKey:@"rankType"]];
            }
            QDLog(@"_rankTypeArr = %@", _rankTypeArr);
        }
//        [self initTableView];
        if (_rankTypeArr.count) {
            [self getRankedSorting:api_RankedSorting andTypeStr:_rankTypeArr[0]];
//            for (int i = 0; i < _rankTypeArr.count; i++) {
//                [self getRankedSorting:api_RankedSorting andTypeStr:_rankTypeArr[i]];
//            }
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
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

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = APP_WHITECOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, SCREEN_HEIGHT*0.38, 0);
    _homePageTopView = [[QDHomePageTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.36)];
    _homePageTopView.backgroundColor = APP_WHITECOLOR;
    [_homePageTopView.hysgBtn addTarget:self action:@selector(hysgAction:) forControlEvents:UIControlEventTouchUpInside];
    [_homePageTopView.glBtn addTarget:self action:@selector(hysgAction:) forControlEvents:UIControlEventTouchUpInside];
    [_homePageTopView.dzyBtn addTarget:self action:@selector(hysgAction:) forControlEvents:UIControlEventTouchUpInside];
    [_homePageTopView.scBtn addTarget:self action:@selector(hysgAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _homePageTopView.iconBtn.layer.cornerRadius = SCREEN_WIDTH*0.11/2;
    _homePageTopView.iconBtn.layer.masksToBounds = YES;
    _homePageTopView.iconBtn.clipsToBounds = YES;
    _tableView.tableHeaderView = _homePageTopView;
    [self.view addSubview:_tableView];
}

#pragma mark - UI
//导航栏
- (void)configNavigationBar{
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
        if (_rankTypeDetailList.count) {
            return _rankTypeDetailList.count - 1;
        }else{
            return 1;
        }
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.72;
}

- (ZLCollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [ZLCollectionView collectionViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.72) itemCount:_rankTypeArr.count];
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
       
        
        self.collectionView.selectedItems = ^(NSIndexPath *indexPath) {
            NSLog(@"ItemTag:%ld",indexPath.item);
            //这里可能要点击切换
        };
        [self.collectionView didSelectedItemsWithBlock:^(NSIndexPath *indexPath) {
            QDLog(@"%ld", (long)indexPath.row);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:_collectionView];
        return cell;
    }else{
        static NSString *identifier2 = @"QDHomePageViewCell";
        QDHomePageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            cell = [[QDHomePageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = APP_WHITECOLOR;
        return cell;
    }
    return nil;
}

#pragma mark - CollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_rankTypeArr.count) {
        return _rankTypeArr.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return  1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYBCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier                                                          forIndexPath:indexPath];
//    [cell configWithImage:[NSString stringWithFormat:@"img%ld.png", indexPath.item + 1]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    QDLog(@"%d", (int)indexPath.row);
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
    }
    
    if (self.alpha == 0) {
    }
    
//    if (scrollView.contentOffset.y > threholdHeight &&
//        self.navigationView.alpha == 1.0) {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//        [self.navigationView navigationAnimation];
//        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    }else{
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//        [self.navigationView resetFrame];
//    }
}

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
@end
