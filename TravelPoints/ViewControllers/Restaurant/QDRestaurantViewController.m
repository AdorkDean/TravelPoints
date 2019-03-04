//
//  ViewController.m
//  tewtsdf
//
//  Created by 冉金 on 2019/1/17.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//
#import "QDRestaurantViewController.h"
#import "QDRestaurantTopView.h"
#import "QDRestaurantViewCell.h"
#import "CustomTravelDTO.h"
#import "QDBridgeViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface QDRestaurantViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    NSMutableArray *_dzyList;
    NSMutableArray *_imgList;
}

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation QDRestaurantViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self requestDZYList:api_GetDZYList];

}
- (void)requestDZYList:(NSString *)urlStr{
    if (_dzyList.count) {
        [_dzyList removeAllObjects];
        [_imgList removeAllObjects];
    }
    NSDictionary * dic1 = @{@"travelName":@"",
                            @"pageNum":@1,
                            @"pageSize":@20
                            };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:dic1 successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *hotelArr = [dic objectForKey:@"result"];
            if (hotelArr.count) {
                for (NSDictionary *dic in hotelArr) {
                    CustomTravelDTO *infoModel = [CustomTravelDTO yy_modelWithDictionary:dic];
                    [_dzyList addObject:infoModel];
                    NSDictionary *dic = [infoModel.imageList firstObject];
                    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", QD_Domain, [dic objectForKey:@"imageUrl"]];
                    QDLog(@"urlStr = %@", urlStr);
                    [_imgList addObject:urlStr];
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
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dzyList = [[NSMutableArray alloc] init];
    _imgList = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    QDRestaurantTopView *restView = [[QDRestaurantTopView alloc] init];
    [self.view addSubview:restView];
    [restView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(SCREEN_WIDTH*0.04);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.048);
    }];
    [self initTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }else{
        return SCREEN_HEIGHT*0.03;
    }
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.12, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor blueColor];
//    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
//    if (@available(iOS 11.0, *)) {
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dzyList.count;
}
#pragma mark -- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.375;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"QDRestaurantViewCell";
    QDRestaurantViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[QDRestaurantViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (_dzyList.count > 0) {
        [cell fillContentWithModel:_dzyList[indexPath.section] andImgURL:_imgList[indexPath.section]];
    }
    [self addShadowToView:cell withColor:APP_GRAYCOLOR];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomTravelDTO *model = _dzyList[indexPath.section];
    //传递ID
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?id=%ld", QD_JSURL, JS_CUSTOMERTRAVEL, (long)model.id];
    QDLog(@"urlStr = %@", bridgeVC.urlStr);
    bridgeVC.customTravelModel = model;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bridgeVC animated:YES];
}
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = APP_GRAYCOLOR.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(13,13);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 13;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 6;
    
}

#pragma mark - DZNEmtpyDataSet Delegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"empty@2x"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"未找到相关数据,请重试";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
