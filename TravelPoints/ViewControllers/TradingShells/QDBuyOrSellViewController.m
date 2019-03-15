//
//  QDBuyOrSellViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDBuyOrSellViewController.h"
#import "PPNumberButton.h"
#import "QDShellRecommendVC.h"
#import <TYAlertView.h>
#import "QDBridgeViewController.h"
#define AddBtnWidth SCREEN_WIDTH*0.075
@interface QDBuyOrSellViewController ()<UITableViewDelegate, UITableViewDataSource, PPNumberButtonDelegate>{
    UITableView *_tableView;
    UIButton *_operateBtn;
}
@property (nonatomic, strong) PPNumberButton *numberButton;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *balanceLab;

@end

@implementation QDBuyOrSellViewController

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
    
    if ([_operateModel.postersType isEqualToString:@"1"]) {
        self.title = @"要玩贝";
    }else{
        self.title = @"转玩贝";
    }
    self.view.backgroundColor = APP_WHITECOLOR;
    [self setLeftBtnItem];
    [self initTableView];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.015, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    _operateBtn = [[UIButton alloc] init];
    if ([_operateModel.postersType isEqualToString:@"1"]) {
        [_operateBtn setTitle:@"确认购买" forState:UIControlStateNormal];
    }else{
        [_operateBtn setTitle:@"确认卖出" forState:UIControlStateNormal];
    }
    [_operateBtn setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
    [_operateBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [_operateBtn setTitleColor:APP_WHITECOLOR forState:UIControlStateNormal];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.89, SCREEN_HEIGHT*0.08);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    gradientLayer.masksToBounds = YES;
    gradientLayer.cornerRadius = 4;

    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#159095"] CGColor],(id)[[UIColor colorWithHexString:@"#3CC8B1"] CGColor]]];//渐变数组
    [_operateBtn.layer addSublayer:gradientLayer];
    _operateBtn.titleLabel.font = QDFont(19);
    [_tableView addSubview:_operateBtn];
    [_operateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(SCREEN_WIDTH*0.05);
        make.right.equalTo(self.view.mas_right).offset(-(SCREEN_WIDTH*0.05));
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT*0.4);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.08);
    }];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark -- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return _cellCount;
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.08;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"数量";
        cell.textLabel.font = QDFont(16);
        [cell.contentView addSubview:self.numberButton];
        [_numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-(SCREEN_WIDTH*0.05));
            make.width.mas_equalTo(145);
            make.height.mas_equalTo(SCREEN_HEIGHT*0.06);
        }];
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"价格";
        cell.textLabel.font = QDFont(16);
        self.priceLab.text = _operateModel.price;
        [cell.contentView addSubview:self.priceLab];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-(SCREEN_WIDTH*0.05));
        }];
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"金额";
        cell.textLabel.font = QDFont(16);
        self.balanceLab.text = [NSString stringWithFormat:@"%.2f", self.numberButton.currentNumber * [_operateModel.price floatValue]];
        [cell.contentView addSubview:self.balanceLab];
        [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-(SCREEN_WIDTH*0.05));
        }];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)addAction:(id)sender{
    
}

- (void)subAction:(id)sender{
    
}

- (void)payAction:(UIButton *)sender{
    //直接购买
    [WXProgressHUD showHUD];
    QDLog(@"text = %@", self.balanceLab.text);
    NSDictionary *paramsDic = @{
                                @"userId":_operateModel.userId,
                                @"creditCode":_operateModel.creditCode,
                                @"price":[NSNumber numberWithDouble:[_operateModel.price doubleValue]],
                                @"buyVolume":[NSNumber numberWithFloat:_numberButton.currentNumber],
                                @"balance":self.balanceLab.text,
                                @"postersId":_operateModel.postersId,
                                @"postersType":_operateModel.postersType,
                                @"isPartialDeal":_operateModel.isPartialDeal    //是否允许部分成交
                                };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_BuyAndSellBiddingPosters params:paramsDic successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            //是否确认付款
            [WXProgressHUD hideHUD];
            TYAlertView *alertView = [[TYAlertView alloc] initWithTitle:@"确认付款" message:@"您确定要对这笔订单进行付款操作吗?"];
            [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
                [WXProgressHUD hideHUD];
            }]];
            [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
                //
                QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
                NSString *balance = [NSString stringWithFormat:@"%.2f", [_balanceLab.text doubleValue]];
                bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?amount=%@&&id=%@", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_PAYACTION, balance, _operateModel.postersId];
                [self.navigationController pushViewController:bridgeVC animated:YES];
            }]];
            [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleCancel forState:UIControlStateNormal];
            [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleBlod forState:UIControlStateNormal];
            [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleDestructive forState:UIControlStateNormal];
            [alertView show];
        }else{
            [WXProgressHUD hideHUD];
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络请求失败"];
    }];
//    QDShellRecommendVC *recommendVC = [[QDShellRecommendVC alloc] init];
//    recommendVC.recommendModel = _operateModel;
//    recommendVC.postersType = _postersType;
//    recommendVC.price = [_priceLab.text doubleValue];
//    recommendVC.volume = finalNum;
//    [self.navigationController pushViewController:recommendVC animated:YES];
}

#pragma mark - lazy
- (PPNumberButton *)numberButton
{
    if (!_numberButton) {
        _numberButton = [[PPNumberButton alloc] initWithFrame:CGRectMake(0, 0, 145, 40)];

        _numberButton.shakeAnimation = YES;
        // 设置最小值
        if (_operateModel != nil) {
//            _numberButton.minValue = minNumber;
            _numberButton.currentNumber = 1;
            // 设置最大值
            _numberButton.maxValue = [_operateModel.surplusVolume floatValue];;
        }else{
            _numberButton.minValue = 1;
            _numberButton.currentNumber = 1;
            // 设置最大值
            _numberButton.maxValue = 10000;
        }
        _numberButton.delegate = self;
        _numberButton.increaseImage = [UIImage imageNamed:@"icon_increase"];
        _numberButton.decreaseImage = [UIImage imageNamed:@"icon_grayDecrease"];
        
        // 设置输入框中的字体大小
        _numberButton.inputFieldFont = 16;
        _numberButton.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
            NSLog(@"%lf",number);
        };
    }
    return _numberButton;
}

- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [[UILabel alloc] init];
        _priceLab.text = _operateModel.price;
        _priceLab.font = QDFont(16);
        _priceLab.textColor = APP_BLACKCOLOR;
    }
    return _priceLab;
}

- (UILabel *)balanceLab{
    if(!_balanceLab){
        _balanceLab = [[UILabel alloc] init];
        _balanceLab.text = [NSString stringWithFormat:@"%.2f", self.numberButton.currentNumber * [_operateModel.price floatValue]];
        _balanceLab.font = QDFont(16);
        _balanceLab.textColor = APP_BLACKCOLOR;
    }
    return _balanceLab;
}

- (void)pp_numberButton:(__kindof UIView *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus
{
    NSLog(@"%@",increaseStatus ? @"加运算":@"减运算");
    _balanceLab.text = [NSString stringWithFormat:@"%.2f", number * [_operateModel.price floatValue]];
    if (number == self.numberButton.minValue) {
        _numberButton.decreaseImage = [UIImage imageNamed:@"icon_grayDecrease"];
        _numberButton.increaseImage = [UIImage imageNamed:@"icon_increase"];
    }else if (number == self.numberButton.maxValue) {
        _numberButton.decreaseImage = [UIImage imageNamed:@"icon_decrease"];
        _numberButton.increaseImage = [UIImage imageNamed:@"icon_grayIncrease"];
    }else{
        _numberButton.decreaseImage = [UIImage imageNamed:@"icon_decrease"];
        _numberButton.increaseImage = [UIImage imageNamed:@"icon_increase"];
    }
}


@end
