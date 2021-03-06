//
//  QDOrderDetailVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDOrderDetailVC.h"
#import "QDPickOrderView.h"
#import "QDDateUtils.h"
#import "QDOrderField.h"
#import <TYAlertView.h>
#import "QDBridgeViewController.h"
#import "YUTimer.h"
@interface QDOrderDetailVC (){
    QDPickOrderView *_pickOrderView;
    NSString *_orderID;
    NSString *_balance;
}

@property (nonatomic, strong) YUTimer * timer;

@property (nonatomic, assign) NSInteger currentEditStatusTime;

@end

@implementation QDOrderDetailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    [self requestOrderDetail];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    QDLog(@"viewWillDisappear");
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

#pragma mark - 查看我的摘单详情
- (void)requestOrderDetail{
    NSDictionary * paramsDic = @{@"orderNumber":_orderModel.orderId,
                                 @"orderType":@4
                                 };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_UserOrderDetail params:paramsDic successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            QDLog(@"123");
            NSDictionary *dic = responseObject.result;
            NSDictionary *orderDetail = [dic objectForKey:@"orderDetail"];
            _pickOrderView.bdNum.text = [orderDetail objectForKey:@"postersId"];
            _orderID = [orderDetail objectForKey:@"orderId"];
            _pickOrderView.zdNum.text = _orderID;
            _pickOrderView.bdTime.text = [QDDateUtils timeStampConversionNSString:[orderDetail objectForKey:@"createTime"]];
            //请求到剩余s数之后 开始计时
            _balance = [NSString stringWithFormat:@"%.2lf",[[orderDetail objectForKey:@"amount"] doubleValue]];
            if ([_orderModel.businessType isEqualToString:@"0"]) {
                _pickOrderView.operationType.text = @"买入";
            }else{
                _pickOrderView.operationType.text = @"卖出";
            }
            _pickOrderView.lab3.text = _balance;
            _pickOrderView.lab5.text = [NSString stringWithFormat:@"%.2lf", [[orderDetail objectForKey:@"number"] doubleValue]];
            _pickOrderView.lab7.text = [NSString stringWithFormat:@"¥%.2lf", [[orderDetail objectForKey:@"price"] doubleValue]];
            _pickOrderView.lab9.text = [NSString stringWithFormat:@"¥%.2lf",[[orderDetail objectForKey:@"poundage"] doubleValue]];
            if ([[orderDetail objectForKey:@"state"] intValue] == 0) {  //待付款情况
                _pickOrderView.statusLab.text = @"待付款";
                NSString *ss = [NSString stringWithFormat:@"%d", [[orderDetail objectForKey:@"countDownSec"] intValue]];
                _pickOrderView.remain.text = [QDDateUtils getMMSSFromSS:ss];
                _currentEditStatusTime = [[orderDetail objectForKey:@"countDownSec"] integerValue];
//                _currentEditStatusTime = 8;
//                if (condition) {
//                    <#statements#>
//                }
                __weak __typeof(self)weakSelf = self;
                [self.timer startTimerWithSpace:1 block:^(BOOL result) {
                    if (result) {
                    }
                    weakSelf.currentEditStatusTime--;
                    if (weakSelf.currentEditStatusTime == 0) {
                        QDLog(@"====================");
//                        [self.timer stopTimer];
                        [self.timer suspend];
                        //倒计时结束 取消订单
                        [self cancelOrderForm];
                    }
                    _pickOrderView.remain.text = [QDDateUtils getMMSSFromSS:[NSString stringWithFormat:@"%ld",weakSelf.currentEditStatusTime]];
                }];
                _pickOrderView.payBtn.hidden = NO;
                _pickOrderView.withdrawBtn.hidden = NO;
                _pickOrderView.infoLab.hidden = NO;
                _pickOrderView.remain.hidden = NO;
                _pickOrderView.remainLab.hidden = NO;
            }else{
                _pickOrderView.infoLab.hidden = YES;
                _pickOrderView.remain.hidden = YES;
                _pickOrderView.remainLab.hidden = YES;
                _pickOrderView.payBtn.hidden = YES;
                _pickOrderView.withdrawBtn.hidden = YES;
                switch ([[orderDetail objectForKey:@"state"] integerValue]) {
                    case QD_HavePurchased:
                        _pickOrderView.statusLab.text = @"已成交";
                        break;
                    case QD_HaveFinished:
                        _pickOrderView.statusLab.text = @"已完成";
                        break;
                    case QD_OverTimeCanceled:
                        _pickOrderView.statusLab.text = @"已取消";
                        break;
                    case QD_ManualCanceled:
                        _pickOrderView.statusLab.text = @"已取消";
                        break;
                    default:
                        break;
                }
            }
            
        }else{
            [WXProgressHUD showInfoWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        QDLog(@"123");
    }];
}

#pragma mark - 取消订单
- (void)cancelOrderForm{
    NSDictionary *dic = @{@"orderId":_orderID};
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_CancelOrderForm params:dic successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            [WXProgressHUD showSuccessWithTittle:@"订单超时取消"];
            [self requestOrderDetail];
        }else{
            [WXProgressHUD showInfoWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
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
    self.title = @"订单详情";
    self.view.backgroundColor = APP_WHITECOLOR;
    [self setLeftBtnItem];
    _pickOrderView = [[QDPickOrderView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _pickOrderView.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
    [_pickOrderView.payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [_pickOrderView.withdrawBtn addTarget:self action:@selector(withdrawAction:) forControlEvents:UIControlEventTouchUpInside];
    [_pickOrderView loadViewWithModel:_orderModel];
    [self.view addSubview:_pickOrderView];
}

- (void)payAction:(UIButton *)sender{
    QDLog(@"payAction");
    TYAlertView *alertView = [[TYAlertView alloc] initWithTitle:@"付款" message:@"您确定要对这笔订单进行付款吗?"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        QDLog(@"取消付款");
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
        bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?amount=%@&&id=%@", QD_JSURL, JS_PAYACTION, _balance, _orderID];
        [self.navigationController pushViewController:bridgeVC animated:YES];
    }]];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleCancel forState:UIControlStateNormal];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleBlod forState:UIControlStateNormal];
    [alertView setButtonTitleColor:APP_BLUECOLOR forActionStyle:TYAlertActionStyleDestructive forState:UIControlStateNormal];
    [alertView show];
}

#pragma mark - 撤单操作
- (void)withdrawAction:(UIButton *)sender{
    TYAlertView *alertView = [[TYAlertView alloc] initWithTitle:@"撤销订单" message:@"您确定要撤销这笔订单吗?"];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        [WXProgressHUD hideHUD];
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        NSDictionary *dic = @{@"orderId":_orderID};
        [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_CancelOrderForm params:dic successBlock:^(QDResponseObject *responseObject) {
            if (responseObject.code == 0) {
                [WXProgressHUD showSuccessWithTittle:@"撤单成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [WXProgressHUD showInfoWithTittle:responseObject.message];
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

- (YUTimer *)timer {
    if (_timer == nil) {
        _timer = [[YUTimer alloc] init];
    }
    return _timer;
}


@end
