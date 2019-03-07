//
//  QDReadyToCreateOrderVC.m
//  TravelPoints
//
//  Created by WJ-Shao on 2019/2/26.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDReadyToCreateOrderVC.h"
#import "QDReadyToPayViewCell.h"
#import "QDSalesInfo.h"
#import "CWActionSheet.h"
#import "QDBridgeViewController.h"
@interface QDReadyToCreateOrderVC ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
    NSString *_allowSelect;
    NSMutableArray *_salesInfoArr;  //代销商数组
}
@property (nonatomic, strong) NSArray *cellTitleArr;
@property (nonatomic, strong) QDSalesInfo *currentSale;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *returnBtn;

//代销申购时需要的参数
@property (nonatomic, strong) NSString *planCode;
@property (nonatomic, strong) NSString *subscriptCount;

@end

@implementation QDReadyToCreateOrderVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
//    self.tabBarController.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
}

#pragma mark - 积分充值卡查询
- (void)readyToCreateOrder:(NSString *)urlStr{
    //判空 如果没有选择卡片 则进来的时候 model为nil
    NSDictionary *paramsDic = @{@"id":[NSNumber numberWithInteger:_vipModel.id],
                                 @"vipTypeName":_vipModel.vipTypeName,
                                 @"vipMoney":[NSNumber numberWithInt:[_vipModel.vipMoney intValue]]
                                 };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:paramsDic successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            _allowSelect = [dic objectForKey:@"allowSelect"];
            if ([_allowSelect intValue] == 0) {
                [WXProgressHUD showErrorWithTittle:@"不允许选择代销商"];
            }else{
                //发行计划代码与申购积分数量
                _planCode = [dic objectForKey:@"planCode"];
                _subscriptCount = [dic objectForKey:@"subscriptCount"];
                if (_salesInfoArr.count) {
                    [_salesInfoArr removeAllObjects];
                }
                NSArray *saleInfoArr = [dic objectForKey:@"salesInfo"];
                if (saleInfoArr.count) {
                    for (NSDictionary *dic in saleInfoArr) {
                        QDSalesInfo *infoModel = [QDSalesInfo yy_modelWithDictionary:dic];
                        [_salesInfoArr addObject:infoModel];
                    }
                }
            }
        }else{
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readyToCreateOrder:api_ReadyToCreateOrder];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    backView.backgroundColor = APP_WHITECOLOR;
    [self.view addSubview:backView];
    
    _returnBtn = [[UIButton alloc] init];
    _salesInfoArr = [[NSMutableArray alloc] init];
    [_returnBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [_returnBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_returnBtn];
    [_returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(SCREEN_WIDTH*0.06);
        make.top.equalTo(self.view.mas_top).offset(32);
    }];
    _titleLab = [[UILabel alloc] init];
    _titleLab.text = @"确认支付";
    _titleLab.textColor = APP_BLACKCOLOR;
    _titleLab.font = QDFont(17);
    [backView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(_returnBtn);
    }];
    
    self.view.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
    _cellTitleArr = [[NSArray alloc] initWithObjects:@"卡名",@"金额",@"基准价",@"玩贝数量",@"承销商", nil];
    [self initTableView];
    UIButton *recommendBtn = [[UIButton alloc] init];
    [recommendBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
    [recommendBtn addTarget:self action:@selector(conformToPayAction:) forControlEvents:UIControlEventTouchUpInside];
    [recommendBtn setTitleColor:APP_WHITECOLOR forState:UIControlStateNormal];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.89, SCREEN_HEIGHT*0.08);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#159095"] CGColor],(id)[[UIColor colorWithHexString:@"#3CC8B1"] CGColor]]];//渐变数组
    [recommendBtn.layer addSublayer:gradientLayer];
    recommendBtn.titleLabel.font = QDFont(19);
    recommendBtn.layer.cornerRadius = 12;
    recommendBtn.layer.masksToBounds = YES;
    [_tableView addSubview:recommendBtn];
    [recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_tableView);
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT*0.55);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.08);
    }];
    // Do any additional setup after loading the view.
}

#pragma mark - 代销申购
- (void)conformToPayAction:(UIButton *)sender{
    if (_currentSale == nil) {
        if (_salesInfoArr.count) {
            //承销商有数据 可以不选择
            QDSalesInfo *salesInfo = [[QDSalesInfo alloc] init];
            salesInfo.saleCode = @"";
            _currentSale = salesInfo;
        }else{
            [WXProgressHUD showErrorWithTittle:@"请选择承销商"];
        }
    }else{
        //先查询全部
        [self showCurrentSaleViewInfo];
    }
}

- (void)popAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.015 + SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    _tableView.dataSource = self;
    _tableView.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
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
    static NSString *identifier = @"QDReadyToPayViewCell";
    QDReadyToPayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[QDReadyToPayViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleLab.text = _cellTitleArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailLab.hidden = NO;
        cell.cxsBtn.hidden = YES;
        cell.detailLab.text = _vipModel.vipTypeName;
        cell.detailLab.textColor = APP_BLACKCOLOR;
    }else if (indexPath.row == 1){
        cell.detailLab.hidden = NO;
        cell.cxsBtn.hidden = YES;
        cell.detailLab.text = [NSString stringWithFormat:@"¥%@",_vipModel.vipMoney];
        cell.detailLab.textColor = APP_BLUECOLOR;
    }else if (indexPath.row == 2){
        cell.detailLab.hidden = NO;
        cell.cxsBtn.hidden = YES;
        cell.detailLab.text = _vipModel.basePrice;
        cell.detailLab.textColor = APP_BLUECOLOR;
    }else if (indexPath.row == 3){
        cell.detailLab.hidden = NO;
        cell.cxsBtn.hidden = YES;
        cell.detailLab.text = _vipModel.subscriptCount;
        cell.detailLab.textColor = APP_GRAYTEXTCOLOR;
    }else{
        if (![_currentSale.saleCode isEqualToString:@""] && _currentSale.saleCode != nil) {
            [cell.cxsBtn setTitle:_currentSale.saleName forState:UIControlStateNormal];
        }
        [cell.cxsBtn addTarget:self action:@selector(selectCxs:) forControlEvents:UIControlEventTouchUpInside];
        cell.detailLab.hidden = YES;
        cell.cxsBtn.hidden = NO;
    }
    return cell;
}

#pragma mark - 下拉选择承销商
- (void)selectCxs:(SPButton *)sender{
    NSMutableArray *infoArr = [[NSMutableArray alloc] init];
    if (_salesInfoArr.count) {
        for (QDSalesInfo *info in _salesInfoArr) {
            [infoArr addObject:info.saleName];
        }
    }
    CWActionSheet *sheet = [[CWActionSheet alloc] initWithTitles:infoArr clickAction:^(CWActionSheet *sheet, NSIndexPath *indexPath) {
        QDLog(@"点击了%ld%@", indexPath.row, _salesInfoArr[indexPath.row]);
        QDSalesInfo *info = _salesInfoArr[indexPath.row];
        _currentSale = info;
        [_tableView reloadData];
    }];
    [sheet show];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 4) {
        NSMutableArray *infoArr = [[NSMutableArray alloc] init];
        if (_salesInfoArr.count) {
            for (QDSalesInfo *info in _salesInfoArr) {
                [infoArr addObject:info.saleName];
            }
        }
        CWActionSheet *sheet = [[CWActionSheet alloc] initWithTitles:infoArr clickAction:^(CWActionSheet *sheet, NSIndexPath *indexPath) {
            QDLog(@"点击了%ld%@", indexPath.row, _salesInfoArr[indexPath.row]);
            QDSalesInfo *info = _salesInfoArr[indexPath.row];
            _currentSale = info;
            [_tableView reloadData];
        }];
        [sheet show];
    }
}

#pragma mark - 弹出承销商选择视图
- (void)showCurrentSaleViewInfo{
    //先查询全部
    NSDecimalNumber *subscribeCountNum = [NSDecimalNumber decimalNumberWithString:_vipModel.subscriptCount];
    NSDecimalNumber *subscribePriceNum = [NSDecimalNumber decimalNumberWithString:_vipModel.basePrice];
    NSDecimalNumber *subscribeTotalPriceNum = [NSDecimalNumber decimalNumberWithString:_vipModel.vipMoney];
    NSDecimalNumber *actualPriceNum = [NSDecimalNumber decimalNumberWithString:_vipModel.subscriptCount];
    
    NSDictionary *paramsDic = @{@"creditCode":@"10001",
                                @"planCode":_planCode,
                                @"subscribeCount":subscribeCountNum,
                                @"subscribePrice":subscribePriceNum,  //基准价
                                @"subscribeTotalPrice":subscribeTotalPriceNum,
                                @"saleCode":_currentSale.saleCode,
                                @"rewardCount":@0,
                                @"actualPrice":subscribeTotalPriceNum,
                                @"subscriptionUnit":actualPriceNum
                                };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_SaleByProxyApply params:paramsDic successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSString *resultNum = responseObject.result;
            QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
            bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?amount=%@&&id=%@", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_PAYACTION,[subscribeTotalPriceNum stringValue], resultNum];
            QDLog(@"urlStr = %@", bridgeVC.urlStr);
            [self.navigationController pushViewController:bridgeVC animated:YES];
        }else{
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}
@end
