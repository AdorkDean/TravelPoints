//
//  QDTradingShellsVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/15.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDTradingViewController.h"
#import "QDTradeShellsSectionHeaderView.h"
#import "RootTableCell.h"
#import "MyTableCell.h"
#import "TFDropDownMenu.h"
#import "SnailQuickMaskPopups.h"
#import "QDFilterTypeOneView.h"
#import "QDFilterTypeTwoView.h"
#import "QDFilterTypeThreeView.h"
#import "QDShellRecommendVC.h"
#import "QDMySaleOrderCell.h"
#import "QDMyPurchaseCell.h"
#import "QDPickUpOrderCell.h"
#import "QDOrderDetailVC.h"
#import <TYAlertView/TYAlertView.h>
#import "BiddingPostersDTO.h"
#import "QDMyPickOrderModel.h"
#import "QDRefreshHeader.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "QDBuyOrSellViewController.h"

#define K_T_Cell @"t_cell"
#define K_C_Cell @"c_cell"

// 要玩贝  转玩贝  我的报单  我的摘单
typedef enum : NSUInteger {
    QDPlayShells = 0,
    QDTradeShells = 1,
    QDMyOrders = 2,
    QDPickUpOrders = 3
} QDShellType;

@interface QDTradingViewController ()<UITableViewDelegate, UITableViewDataSource, RootCellDelegate, SnailQuickMaskPopupsDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    QDTradeShellsSectionHeaderView *_sectionHeaderView;
    QDShellType _shellType;
    UIView *_backView;
    UIButton *_optionBtn;               //要玩贝操作按钮
    NSMutableArray *_ywbArr;            //要玩贝arr
    NSMutableArray *_zwbArr;            //转玩贝arr
    NSMutableArray *_myOrdersArr;       //我的报单
    NSMutableArray *_myPickOrdersArr;   //我的摘单
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dicH;
@property (nonatomic, strong) SnailQuickMaskPopups *popups;
@property (nonatomic, strong) QDFilterTypeOneView *typeOneView;
@property (nonatomic, strong) QDFilterTypeTwoView *typeTwoView;
@property (nonatomic, strong) QDFilterTypeThreeView *typeThreeView;




@end

@implementation QDTradingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

#pragma mark - 请求挂单的全部数据(买入与卖出)
- (void)requestCanTradeData:(NSString *)urlStr{
    //先查询全部
    NSDictionary * dic1 = @{@"postersStatus":@"",
                            @"postersType":@"",
                            @"pageNum":@1,
                            @"pageSize":@100,
                            };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:dic1 successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *hotelArr = [dic objectForKey:@"result"];
            if (hotelArr.count) {
                for (NSDictionary *dic in hotelArr) {
                    BiddingPostersDTO *infoModel = [BiddingPostersDTO yy_modelWithDictionary:dic];
                    if ([infoModel.postersType isEqualToString:@"1"]) {
                        [_ywbArr addObject:infoModel];
                    }else{
                        [_zwbArr addObject:infoModel];
                    }
                    QDLog(@"_ywbArr = %@", _ywbArr);
                    QDLog(@"_zwbArr = %@", _zwbArr);
                }
                [self.tableView reloadData];
            }
        }
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}

#pragma mark - 请求我的报单数据(买入与卖出)
- (void)requestMyBiddingPosters:(NSString *)urlStr{
    if (_myOrdersArr.count) {
        [_myOrdersArr removeAllObjects];
    }
    NSDictionary * paramsDic = @{@"postersStatus":@"",
                                 @"postersType":@"",
                                 @"pageNum":@1,
                                 @"pageSize":@100,
                                 };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:paramsDic successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *hotelArr = [dic objectForKey:@"result"];
            if (hotelArr.count) {
                for (NSDictionary *dic in hotelArr) {
                    BiddingPostersDTO *infoModel = [BiddingPostersDTO yy_modelWithDictionary:dic];
                    [_myOrdersArr addObject:infoModel];
                    QDLog(@"_myOrdersArr = %@", _myOrdersArr);
                }
                [self.tableView reloadData];
            }
        }else if (responseObject.code == 1){
            [_tableView reloadData];
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
        [_tableView emptyDataSetSource];
//        [_tableView emptyDataSetDelegate];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}

#pragma mark - 请求我的摘单数据(买入与卖出)
- (void)requestMyZhaiDanData:(NSString *)urlStr{
    if (_myPickOrdersArr.count) {
        [_myPickOrdersArr removeAllObjects];
    }
    NSDictionary * paramsDic = @{@"postersStatus":@"",
                                 @"postersType":@"",
                                 @"pageNum":@1,
                                 @"pageSize":@100,
                                 };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:paramsDic successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *hotelArr = [dic objectForKey:@"result"];
            if (hotelArr.count) {
                for (NSDictionary *dic in hotelArr) {
                    QDMyPickOrderModel *infoModel = [QDMyPickOrderModel yy_modelWithDictionary:dic];
                    [_myPickOrdersArr addObject:infoModel];
                }
                [self.tableView reloadData];
            }
        }else if (responseObject.code == 1){
            [_tableView reloadData];
            [_tableView reloadEmptyDataSet];
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [_tableView emptyDataSetSource];
        [_tableView emptyDataSetDelegate];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _shellType = QDPlayShells;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setTopView];
    [self initTableView];
    [self requestCanTradeData:api_FindCanTrade];
    _ywbArr = [[NSMutableArray alloc] init];
    _zwbArr = [[NSMutableArray alloc] init];
    _myOrdersArr = [[NSMutableArray alloc] init];
    _myPickOrdersArr = [[NSMutableArray alloc] init];
}
-(void)leftClick
{
    //下落动画 时间短一些
    [UIView beginAnimations:@"text" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    _backView.frame=CGRectMake(0,40, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
    
    //恢复动画 时间长一些
    [UIView beginAnimations:@"text" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5];
    _backView.frame=CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
    
}
-(void)tapclick
{
    [UIView beginAnimations:@"text" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    _backView.frame=CGRectMake(0, -self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
}
- (void)setTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    topView.backgroundColor = APP_WHITECOLOR;
    [self.view addSubview:topView];

}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.05 + 53, SCREEN_WIDTH, SCREEN_HEIGHT+SCREEN_HEIGHT*0.05 + 53) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, SCREEN_HEIGHT*0.24, 0);
    [self.view addSubview:_tableView];
    _tableView.mj_header = [QDRefreshHeader headerWithRefreshingBlock:^{
        [self endRefreshing];
    }];
    //分段选择按钮
    NSArray *segmentedTitles = @[@"要玩贝",@"转玩贝",@"我的报单",@"我的摘单"];
    _segmentControl = [[QDSegmentControl alloc] initWithSectionTitles:segmentedTitles];
    _segmentControl.frame = CGRectMake(0, 33, SCREEN_WIDTH, SCREEN_HEIGHT*0.05);
    [_segmentControl addTarget:self action:@selector(segmentedClicked:) forControlEvents:UIControlEventValueChanged];
    _segmentControl.selectionIndicatorColor = APP_BLACKCOLOR;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.view addSubview:_segmentControl];
    
    _optionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.31, SCREEN_HEIGHT*0.83, SCREEN_WIDTH*0.37, SCREEN_HEIGHT*0.06)];
    [_optionBtn addTarget:self action:@selector(operateAction:) forControlEvents:UIControlEventTouchUpInside];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.37, SCREEN_HEIGHT*0.06);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#159095"] CGColor],(id)[[UIColor colorWithHexString:@"#3CC8B1"] CGColor]]];//渐变数组
    [_optionBtn.layer addSublayer:gradientLayer];
    [_optionBtn setTitle:@"要玩贝" forState:UIControlStateNormal];
    _optionBtn.backgroundColor = [UIColor redColor];
    _optionBtn.layer.cornerRadius = 12;
    _optionBtn.layer.masksToBounds = YES;
    _optionBtn.titleLabel.font = QDFont(17);
    [self.view addSubview:_optionBtn];
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.23)];
//    headerView.backgroundColor = [UIColor whiteColor];
//    _tableView.tableHeaderView = headerView;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, SCREEN_WIDTH*0.03, SCREEN_WIDTH*0.89, SCREEN_HEIGHT*0.225)];
    imgView.image = [UIImage imageNamed:@"shellBanner"];
    _tableView.tableHeaderView = imgView;
//    [headerView addSubview:imgView];
}

- (void)endRefreshing
{
    if (_tableView) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}

- (void)segmentedClicked:(QDSegmentControl *)segmentControl{
    _shellType = (QDShellType)segmentControl.selectedSegmentIndex;
    switch (_shellType) {
        case QDPlayShells: //要玩贝
            QDLog(@"0");
            [_optionBtn setHidden:NO];
            [_optionBtn setTitle:@"要玩贝" forState:UIControlStateNormal];
            if (!_ywbArr.count) {
                [_tableView reloadData];
                [_tableView reloadEmptyDataSet];
            }else{
                [_tableView reloadData];
            }
            break;
        case QDTradeShells: //转玩贝   按钮
            QDLog(@"1");
            [_optionBtn setHidden:NO];
            [_optionBtn setTitle:@"转玩贝" forState:UIControlStateNormal];
            if (!_zwbArr.count) {
                [_tableView reloadEmptyDataSet];
            }
            [_tableView reloadData];
            break;
        case QDMyOrders: //我的报单
            [_optionBtn setHidden:YES];
            [self requestMyBiddingPosters:api_FindMyBiddingPosterse];
            QDLog(@"我的报单");
            break;
        case QDPickUpOrders: //我的摘单
            [_optionBtn setHidden:YES];
            [self requestMyZhaiDanData:api_FindMyOrder];
            break;
        default:
            break;
    }
}

#pragma mark - 撤单操作
- (void)withdrawAction:(UIButton *)sender{
    TYAlertView *alertView = [[TYAlertView alloc] initWithTitle:@"撤销订单" message:@"您确定要撤销这笔订单吗?"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        [WXProgressHUD hideHUD];
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
    }]];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleCancel forState:UIControlStateNormal];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleBlod forState:UIControlStateNormal];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleDestructive forState:UIControlStateNormal];
    [alertView show];
}

#pragma mark - 付款操作
- (void)payAction:(UIButton *)sender{
    QDLog(@"payAction");
}


#pragma mark -- tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_shellType == QDPlayShells || _shellType == QDTradeShells) {
        return 1;
    }else if(_shellType == QDMyOrders){
        return _myOrdersArr.count;
    }else{
        return _myPickOrdersArr.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_HEIGHT*0.075;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_shellType == QDPlayShells || _shellType == QDTradeShells) {
        if (self.dicH[indexPath]) {
            QDLog(@"dicH = %@", self.dicH);
            NSNumber *num = self.dicH[indexPath];
            return [num floatValue];
        } else {
            return 60;
        }
    }else{
        return 192;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_shellType == QDPlayShells || _shellType == QDTradeShells) {
        [tableView registerClass:[RootTableCell class] forCellReuseIdentifier:K_C_Cell];
        RootTableCell *cell = [tableView dequeueReusableCellWithIdentifier:K_C_Cell forIndexPath:indexPath];
        cell.operateBlock = ^(NSUInteger btnTag) {
            QDLog(@"btnTag = %ld", (long)btnTag);
            BiddingPostersDTO *model = _ywbArr[btnTag];
            QDBuyOrSellViewController *operateVC = [[QDBuyOrSellViewController alloc] init];
            operateVC.operateModel = model;
            if (_shellType == QDPlayShells) {
                operateVC.postersType = @"1";
            }else{
                operateVC.postersType = @"0";
            }
            [self.navigationController pushViewController:operateVC animated:YES];
        };
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
        if (_shellType == QDPlayShells) {
            cell.typeStr = @"0";    //
        }else{
            cell.typeStr = @"1";
        }
        cell.indexPath = indexPath;
        if (_shellType == QDPlayShells) {
            if (_ywbArr.count) {
                cell.dataAry = _ywbArr;
                [cell.collectionView reloadData];
            }
        }else if (_shellType == QDTradeShells){
            if (_zwbArr.count) {
                cell.dataAry = _zwbArr;
                [cell.collectionView reloadData];
            }
        }
        return cell;
    }else if (_shellType == QDMyOrders){
        if (_myOrdersArr.count) {
            BiddingPostersDTO *infoModel = _myOrdersArr[indexPath.row];
            if ([infoModel.postersType isEqualToString:@"0"]) {
                static NSString *identifier = @"QDMyPurchaseCell";
                QDMyPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[QDMyPurchaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                [cell loadPurchaseDataWithModel:infoModel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = APP_WHITECOLOR;
                return cell;
            }else{
                static NSString *identifier = @"QDMySaleOrderCell";
                QDMySaleOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[QDMySaleOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                [cell loadSaleOrderDataWithModel:infoModel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = APP_WHITECOLOR;
                return cell;
            }
        }
    }else{
        if (_myPickOrdersArr.count) {
            QDMyPickOrderModel *infoModel = _myPickOrdersArr[indexPath.row];
            if ([infoModel.businessType isEqualToString:@"0"]) {
                static NSString *identifier = @"QDMyPurchaseCell";
                QDMyPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[QDMyPurchaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                [cell loadMyPickPurchaseDataWithModel:infoModel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = APP_WHITECOLOR;
                return cell;
            }else{
                static NSString *identifier = @"QDMySaleOrderCell";
                QDMySaleOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[QDMySaleOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                [cell loadMyPickSaleDataWithModel:infoModel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = APP_WHITECOLOR;
                return cell;
            }
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _sectionHeaderView = [[QDTradeShellsSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    [_sectionHeaderView.filterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    _sectionHeaderView.backgroundColor = APP_WHITECOLOR;
    return _sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_shellType == QDMyOrders) {
        QDOrderDetailVC *detailVC = [[QDOrderDetailVC alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
#pragma mark ====== RootTableCellDelegate ======
- (void)updateTableViewCellHeight:(RootTableCell *)cell andheight:(CGFloat)height andIndexPath:(NSIndexPath *)indexPath {
    if (![self.dicH[indexPath] isEqualToNumber:@(height)]) {
        self.dicH[indexPath] = @(height);
        [self.tableView reloadData];
    }
}


//点击UICollectionViewCell的代理方法
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath withContent:(BiddingPostersDTO *)urlStr{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:urlStr.userId delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (NSMutableDictionary *)dicH {
    if (!_dicH) {
        _dicH = [[NSMutableDictionary alloc] init];
    }
    return _dicH;
}

- (QDFilterTypeOneView *)typeOneView{
    if (_typeOneView) {
        _typeOneView = [[QDFilterTypeOneView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.57)];
        _typeOneView.backgroundColor = APP_WHITECOLOR;
    }
    return _typeOneView;
}

- (void)confirmOptions:(UIButton *)sender{
    [_popups dismissAnimated:YES completion:nil];
}


#pragma mark - 要/转玩贝操作按钮
- (void)operateAction:(UIButton *)sender{
    
    QDShellRecommendVC *recommendVC = [[QDShellRecommendVC alloc] init];
    if (_shellType == QDPlayShells) {
        recommendVC.recommendType = 0;
    }else if (_shellType == QDTradeShells){
        recommendVC.recommendType = 1;
    }
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recommendVC animated:YES];
}

- (void)filterAction:(UIButton *)sender{
    if (_shellType == QDPlayShells || _shellType == QDTradeShells) {
        if (!_typeOneView) {
            _typeOneView = [[QDFilterTypeOneView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.57)];
            [_typeOneView.confirmBtn addTarget:self action:@selector(confirmOptions:) forControlEvents:UIControlEventTouchUpInside];
            _typeOneView.backgroundColor = APP_WHITECOLOR;
        }
        _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:_typeOneView];
        _popups.presentationStyle = PresentationStyleBottom;
        
        _popups.delegate = self;
        [_popups presentInView:self.view animated:YES completion:NULL];
    }else if(_shellType == QDMyOrders){
        if (!_typeTwoView) {
            _typeTwoView = [[QDFilterTypeTwoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.57)];
            [_typeTwoView.confirmBtn addTarget:self action:@selector(confirmOptions:) forControlEvents:UIControlEventTouchUpInside];
            _typeTwoView.backgroundColor = APP_WHITECOLOR;
        }
        _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:_typeTwoView];
        _popups.presentationStyle = PresentationStyleBottom;
        _popups.delegate = self;
        [_popups presentInView:self.view animated:YES completion:NULL];
    }else{
        if (!_typeThreeView) {
            _typeThreeView = [[QDFilterTypeThreeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.57)];
            [_typeThreeView.confirmBtn addTarget:self action:@selector(confirmOptions:) forControlEvents:UIControlEventTouchUpInside];
            _typeThreeView.backgroundColor = APP_WHITECOLOR;
        }
        _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:_typeThreeView];
        _popups.presentationStyle = PresentationStyleBottom;
        _popups.delegate = self;
        [_popups presentInView:self.view animated:YES completion:NULL];
    }
}

#pragma mark - emptyDataSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"empty@2x"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无数据";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
//    return SCREEN_HEIGHT*0.21;
//}

@end
