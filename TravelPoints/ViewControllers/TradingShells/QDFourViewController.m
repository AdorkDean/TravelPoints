//
//  QDTradingShellsVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/15.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDFourViewController.h"
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
#import "QDRefreshFooter.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "QDBuyOrSellViewController.h"
#import "QDSettingViewController.h"
#import "QDBridgeViewController.h"
#import "QDLoginAndRegisterVC.h"

#define K_T_Cell @"t_cell"
#define K_C_Cell @"c_cell"

// 要玩贝  转玩贝  我的报单  我的摘单
typedef enum : NSUInteger {
    QDPlayShells = 0,
    QDTradeShells = 1,
    QDMyOrders = 2,
    QDPickUpOrders = 3
} QDShellType;

@interface QDFourViewController ()<UITableViewDelegate, UITableViewDataSource, SnailQuickMaskPopupsDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    QDTradeShellsSectionHeaderView *_sectionHeaderView;
    UIView *_backView;
    NSMutableArray *_myPickOrdersArr;   //我的摘单
    int _pageSize;
    int _pageNum;
    int _totalPage;
}
@property (nonatomic, strong) UIImageView *emptyView;
@property (nonatomic, strong) UILabel *tipLab;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dicH;
@property (nonatomic, strong) SnailQuickMaskPopups *popups;
@property (nonatomic, strong) QDFilterTypeOneView *typeOneView;
@property (nonatomic, strong) QDFilterTypeTwoView *typeTwoView;
@property (nonatomic, strong) QDFilterTypeThreeView *typeThreeView;

@property (nonatomic, strong) UIView *vv;




@end

@implementation QDFourViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (UIImageView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[UIImageView alloc] init];
        _emptyView.image = [UIImage imageNamed:@"emptySource@2x"];
        [_tableView addSubview:_emptyView];
        [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tableView);
            make.top.equalTo(_tableView.mas_top).offset(200);
        }];
    }
    return _emptyView;
}

- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc] init];
        _tipLab.text = @"暂无数据";
        _tipLab.font = QDFont(15);
        _tipLab.textColor = APP_BLACKCOLOR;
        [_tableView addSubview:_tipLab];
        [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tableView);
            make.top.equalTo(_tableView.mas_top).offset(350);
        }];
    }
    return _tipLab;
}

- (void)requestHeaderTopData{
    if (_myPickOrdersArr.count) {
        [_myPickOrdersArr removeAllObjects];
    }
    NSDictionary * paramsDic = @{@"postersStatus":@"",
                                 @"postersType":@"",
                                 @"pageNum":@1,
                                 @"pageSize":[NSNumber numberWithInt:_pageSize]
                                 };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_FindMyOrder params:paramsDic successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *hotelArr = [dic objectForKey:@"result"];
            _totalPage = [[dic objectForKey:@"totalPage"] intValue];
            if (hotelArr.count) {
                for (NSDictionary *dic in hotelArr) {
                    QDMyPickOrderModel *infoModel = [QDMyPickOrderModel yy_modelWithDictionary:dic];
                    [_myPickOrdersArr addObject:infoModel];
                }
                if ([self.tableView.mj_header isRefreshing]) {
                    [self.tableView.mj_header endRefreshing];
                }
                [_tableView reloadData];
            }else{
                [_tableView.mj_header endRefreshing];
            }
        }else{
            [_tableView reloadData];
            [_tableView reloadEmptyDataSet];
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}


#pragma mark - 请求我的摘单数据(买入与卖出)
- (void)requestMyZhaiDanData{
    NSString *str = [QDUserDefaults getObjectForKey:@"loginType"];
    if ([str isEqualToString:@"0"] || str == nil) { //未登录
        QDLoginAndRegisterVC *loginVC = [[QDLoginAndRegisterVC alloc] init];
        loginVC.pushVCTag = @"0";
        [self presentViewController:loginVC animated:YES completion:nil];
    }else{
        if (_totalPage != 0) {
            if (_pageNum >= _totalPage) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return;
            }
        }
        NSDictionary * paramsDic = @{@"postersStatus":@"",
                                     @"postersType":@"",
                                     @"pageNum":[NSNumber numberWithInt:_pageNum],
                                     @"pageSize":[NSNumber numberWithInt:_pageSize]
                                     };
        [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_FindMyOrder params:paramsDic successBlock:^(QDResponseObject *responseObject) {
            if (responseObject.code == 0) {
                NSDictionary *dic = responseObject.result;
                NSArray *hotelArr = [dic objectForKey:@"result"];
                _totalPage = [[dic objectForKey:@"totalPage"] intValue];
                if (hotelArr.count) {
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (NSDictionary *dic in hotelArr) {
                        QDMyPickOrderModel *infoModel = [QDMyPickOrderModel yy_modelWithDictionary:dic];
                        [arr addObject:infoModel];
                    }
                    if (arr) {
                        if (arr.count < _pageSize) {   //不满10个
                            [_myPickOrdersArr addObjectsFromArray:arr];
                            [self.tableView reloadData];
                            if ([self.tableView.mj_footer isRefreshing]) {
                                [self endRefreshing];
                                self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                            }
                        }else{
                            [_myPickOrdersArr addObjectsFromArray:arr];
                            self.tableView.mj_footer.state = MJRefreshStateIdle;
                            [self.tableView reloadData];
                        }
                    }
                }else{
                    [_tableView.mj_footer endRefreshing];
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
            }else if (responseObject.code == 2){
                
            }
            else{
                [_tableView reloadData];
                [_tableView reloadEmptyDataSet];
                [WXProgressHUD showErrorWithTittle:responseObject.message];
            }
        } failureBlock:^(NSError *error) {
            [_tableView reloadData];
            [_tableView reloadEmptyDataSet];
            [WXProgressHUD showErrorWithTittle:@"网络异常"];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _myPickOrdersArr = [[NSMutableArray alloc] init];
    _pageSize = 10;
    _pageNum = 1;
    _totalPage = 0; //总页数默认
    self.view.backgroundColor = APP_WHITECOLOR;
    [self initTableView];
    [self requestMyZhaiDanData];
}

- (void)setTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 65)];
    topView.backgroundColor = APP_WHITECOLOR;
    [self.view addSubview:topView];
    
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = APP_WHITECOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:_tableView];
    self.view = _tableView;
    _tableView.mj_header = [QDRefreshHeader headerWithRefreshingBlock:^{
        [self requestHeaderTopData];
    }];
    
    _tableView.mj_footer = [QDRefreshFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [self requestMyZhaiDanData];
    }];
}

- (void)endRefreshing
{
    if (_tableView) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}

#pragma mark - 撤单操作
- (void)withdrawAction:(UIButton *)sender{
    TYAlertView *alertView = [[TYAlertView alloc] initWithTitle:@"撤销订单" message:@"您确定要撤销这笔订单吗?"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        [WXProgressHUD hideHUD];
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        QDMyPickOrderModel *model = _myPickOrdersArr[sender.tag];
        NSDictionary *dic = @{@"orderId":model.orderId};
        [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_CancelOrderForm params:dic successBlock:^(QDResponseObject *responseObject) {
            if (responseObject.code == 0) {
                [WXProgressHUD showSuccessWithTittle:@"撤单成功"];
                [_myPickOrdersArr removeObjectAtIndex:sender.tag];
                [_tableView reloadData];
            }else{
                [WXProgressHUD showErrorWithTittle:responseObject.message];
            }
        } failureBlock:^(NSError *error) {
            [WXProgressHUD showErrorWithTittle:@"网络异常"];
        }];
    }]];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleCancel forState:UIControlStateNormal];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleBlod forState:UIControlStateNormal];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleDestructive forState:UIControlStateNormal];
    [alertView show];
}


#pragma mark - 付款操作
- (void)payAction:(UIButton *)sender{
    QDLog(@"payAction");
    TYAlertView *alertView = [[TYAlertView alloc] initWithTitle:@"付款" message:@"您确定要对这笔订单进行付款吗?"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        QDLog(@"取消付款");
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        QDMyPickOrderModel *model = _myPickOrdersArr[sender.tag];
        QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
        NSString *balance = model.amount;
        bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?amount=%@&&id=%@", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_PAYACTION,balance, model.orderId];

//        bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?id=%@", [QDUserDefaults getObjectForKey:@"QD_TESTJSURL"], JS_PREPARETOPAY,model.orderId];
        [self.navigationController pushViewController:bridgeVC animated:YES];
    }]];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleCancel forState:UIControlStateNormal];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleBlod forState:UIControlStateNormal];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleDestructive forState:UIControlStateNormal];
    [alertView show];
}

- (void)cancelOrderForm:(NSString *)orderId{
    
//    111
//     NSDictionary *paramsDic = @{@"orderId":_model ],
//    [QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_CancelOrderForm params:<#(id)#> successBlock:<#^(QDResponseObject *responseObject)successBlock#> failureBlock:<#^(NSError *error)failureBlock#>
}
#pragma mark -- tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myPickOrdersArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_HEIGHT*0.075;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_myPickOrdersArr.count) {
        static NSString *identifier = @"QDPickUpOrderCell";
        QDPickUpOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[QDPickUpOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.payBtn.tag = (long)_myPickOrdersArr[indexPath.row];
        cell.withdrawBtn.tag = (long)_myPickOrdersArr[indexPath.row];
        [cell.payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.withdrawBtn addTarget:self action:@selector(withdrawAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.payBtn.tag = indexPath.row;
        cell.withdrawBtn.tag = indexPath.row;
        [cell loadPickOrderWithModel:_myPickOrdersArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = APP_WHITECOLOR;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.075)];
    _vv.backgroundColor = APP_WHITECOLOR;
    [_vv addSubview:self.filterBtn];
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.height.equalTo(_vv);
        make.left.equalTo(_vv.mas_left).offset(20);
        make.width.mas_equalTo(70);
    }];
    return _vv;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QDMyPickOrderModel *model = _myPickOrdersArr[indexPath.row];
    QDOrderDetailVC *detailVC = [[QDOrderDetailVC alloc] init];
    detailVC.orderModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
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


- (void)filterAction:(UIButton *)sender{
    if (!_typeThreeView) {
        _typeThreeView = [[QDFilterTypeThreeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.57)];
        [_typeThreeView.confirmBtn addTarget:self action:@selector(confirmOptions:) forControlEvents:UIControlEventTouchUpInside];
        _typeThreeView.backgroundColor = APP_WHITECOLOR;
    }
    _popups = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:_typeThreeView];
    _popups.presentationStyle = PresentationStyleTop;
    _popups.maskAlpha = 0.5;
    _popups.delegate = self;
    [_popups presentInView:_tableView animated:YES completion:NULL];
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

- (SPButton *)filterBtn{
    if (!_filterBtn) {
        _filterBtn = [[SPButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _filterBtn.imagePosition = SPButtonImagePositionRight;
        [_filterBtn setImage:[UIImage imageNamed:@"icon_filter"] forState:UIControlStateNormal];
        _filterBtn.titleLabel.font = QDFont(13);
        [_filterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
        [_filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [_filterBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
    }
    return _filterBtn;
}
@end
