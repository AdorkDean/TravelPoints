//
//  QDHomeHotelListVC.m
//  TravelPoints
//
//  Created by WJ-Shao on 2019/3/21.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDHomeHotelListVC.h"
#import "QDHotelTableViewCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "QDRefreshHeader.h"
#import "QDRefreshFooter.h"
#import "QDBridgeViewController.h"
#import "TABAnimated.h"
#import "TABViewAnimated.h"
#import "UITableView+Animated.h"
#import "UIView+TABControlAnimation.h"
#import "AppDelegate.h"
#import "TFDropDownMenu.h"
@interface QDHomeHotelListVC ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, TFDropDownMenuViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_hotelListInfoArr;
    NSMutableArray *_hotelImgArr;
    NSMutableArray *_array1;
    NSMutableArray *_array2;
    NSMutableArray *_array3;
    TFDropDownMenuView *_menu;
}
@property (nonatomic, getter=isLoading) BOOL loading;

@end

@implementation QDHomeHotelListVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    [self requestHotelInfoWithURL];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_WHITECOLOR;
    _hotelListInfoArr = [[NSMutableArray alloc] init];
    _hotelImgArr = [[NSMutableArray alloc] init];
    //设置筛选header
    _array1 = [[NSMutableArray alloc] initWithObjects:@"全部区域", nil];
    _array2 = [[NSMutableArray alloc] init];
    _array3 = [[NSMutableArray alloc] init];
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_array2.count) {
        [_array2 removeAllObjects];
    }
    _array2 = appD.hotelTypeId;
    if (![_array2[0] isEqualToString:@"酒店类型"]) {
        [_array2 insertObject:@"酒店类型" atIndex:0];
    }
    if (_array3.count) {
        [_array3 removeAllObjects];
    }
    _array3 = appD.hotelLevel;
    if (![_array3[0] isEqualToString:@"星级"]) {
        [_array3 insertObject:@"星级" atIndex:0];
    }
//    [self setDropMenu];
    [self initTableView];
}

//- (void)setDropMenu{
//    NSMutableArray *data1 = [NSMutableArray arrayWithObjects:_array1, _array2, @[@"价格"], _array3, nil];
//    NSMutableArray *data2 = [NSMutableArray arrayWithObjects:@[], @[], @[], @[], nil];
//    _menu = [[TFDropDownMenuView alloc] initWithFrame:CGRectMake(0, 20+SCREEN_HEIGHT*0.1, SCREEN_WIDTH, 50) firstArray:data1 secondArray:data2];
//    _menu.backgroundColor = APP_WHITECOLOR;
//    _menu.delegate = self;
//    _menu.ratioLeftToScreen = 0.35;
//    [self.view addSubview:_menu];
//
//    /*风格*/
//    _menu.menuStyleArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithInteger:TFDropDownMenuStyleTableView], [NSNumber numberWithInteger:TFDropDownMenuStyleTableView], [NSNumber numberWithInteger:TFDropDownMenuStyleCustom], [NSNumber numberWithInteger:TFDropDownMenuStyleTableView], nil];
//    _priceRangeView = [[QDPriceRangeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.38)];
//    _priceRangeView.backgroundColor = APP_WHITECOLOR;
//    [_priceRangeView.resetBtn addTarget:self action:@selector(priceRangeRest:) forControlEvents:UIControlEventTouchUpInside];
//    [_priceRangeView.confirmBtn addTarget:self action:@selector(confirmToSelectPrice:) forControlEvents:UIControlEventTouchUpInside];
//    _priceRangeView.slider.sliderValueChanged = ^(CGFloat minValue, CGFloat maxValue) {
//        if (maxValue < 900) {
//            _minPrice = [NSString stringWithFormat:@"%.f", minValue];
//            _maxPrice = [NSString stringWithFormat:@"%.f", maxValue];
//            _priceRangeView.priceDetailLab.text = [NSString stringWithFormat:@"%.f-%.f", minValue, maxValue];
//
//        }else{
//            _minPrice = [NSString stringWithFormat:@"%.f", minValue];
//            _maxPrice = @"";
//            _priceRangeView.priceDetailLab.text = [NSString stringWithFormat:@"%.f-不限", minValue];
//        };
//        NSLog(@"minValue = %.f, maxValue = %.f", minValue, maxValue);
//    };
//    _menu.customViews = [NSMutableArray arrayWithObjects:[NSNull null], [NSNull null], _priceRangeView, [NSNull null], nil];
//    [self.view addSubview:_menu];
//}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = APP_WHITECOLOR;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView tab_startAnimation];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 130, 0);
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    self.view = _tableView;
    _tableView.mj_header = [QDRefreshHeader headerWithRefreshingBlock:^{
        [self endRefreshing];
    }];
    //手动刷新请求最新数据
    _tableView.mj_footer = [QDRefreshFooter footerWithRefreshingBlock:^{
        [self endRefreshing];
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

#pragma mark - 请求酒店信息
- (void)requestHotelInfoWithURL{
    self.loading = NO;
    if (_hotelListInfoArr.count) {
        [_hotelListInfoArr removeAllObjects];
        [_hotelImgArr removeAllObjects];
    }
    NSString *keyStr = [QDUserDefaults getObjectForKey:@"homeKeyStr"];
    if (keyStr == nil) {
        keyStr = @"";
    }
    NSDictionary * dic1 = @{@"hotelName":keyStr,
                            @"pageNum":@1,
                            @"pageSize":@10
                            };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_GetHotelCondition params:dic1 successBlock:^(QDResponseObject *responseObject) {
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
                [_tableView reloadData];
                [self endRefreshing];
            }else{
                [WXProgressHUD showErrorWithTittle:@"无数据返回,请重试"];
            }
            [_tableView tab_endAnimation];
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
        [_tableView tab_endAnimation];
        [self endRefreshing];
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
    }];
}
#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _hotelListInfoArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.21;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)setLoading:(BOOL)loading
{
    if (self.isLoading == loading) {
        return;
    }
    _loading = loading;
    [_tableView reloadEmptyDataSet];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_hotelListInfoArr.count) {
        QDHotelListInfoModel *model = _hotelListInfoArr[indexPath.row];
        //传递ID
        QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
        bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?id=%ld", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_HOTELDETAIL, (long)model.id];
        QDLog(@"urlStr = %@", bridgeVC.urlStr);
        bridgeVC.infoModel = model;
        self.tabBarController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bridgeVC animated:YES];
    }
}

#pragma mark - emptyDataSource

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.isLoading) {
        return [UIImage imageNamed:@"loading_imgBlue" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    }
    else {
        
        return [UIImage imageNamed:@"icon_noConnect"];
    }
    return nil;
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"页面加载失败";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: APP_BLUECOLOR};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"请检查您的手机网络后点击重试";
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: APP_GRAYLINECOLOR,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}
#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return self.isLoading;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    self.loading = YES;
    [self requestHotelInfoWithURL];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        self.loading = NO;
    //    });
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    self.loading = YES;
    [self requestHotelInfoWithURL];
}

- (void)endRefreshing
{
    if (_tableView) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}
//
//#pragma mark - TFDropDownMenuView Delegate
//- (void)menuView:(TFDropDownMenuView *)menu selectIndex:(TFIndexPatch *)index{
//    QDLog(@"第%ld列 第%ld个", (long)index.column, (long)index.section);
//    switch (index.column) {
//        case 0:             //全部区域
//            QDLog(@"0");
//            break;
//        case 1:             //酒店类型
//            QDLog(@"1");
//            _hotelTypeId = (index.section == 0)? @"": ([NSString stringWithFormat:@"%ld", (long)index.section]);
//            QDLog(@"_hotelTypeId = %@", _hotelTypeId);
//            break;
//        case 2:             //价格
//
//            QDLog(@"2");
//            break;
//        case 3:             //星级
//            _hotelLevel = (index.section == 0)? @"": ([NSString stringWithFormat:@"%ld", (long)index.section]);
//            QDLog(@"_hotelLevel = %@", _hotelLevel);
//            break;
//        default:
//            break;
//    }
//    [self requestHotelInfoWithURL];
//}
//
//- (void)menuView:(TFDropDownMenuView *)menu tfColumn:(NSInteger)column{
//    QDLog(@"column:%ld", (long)column);
//    //让tableView滚动到顶部位置
//    [_tableView setContentOffset:CGPointZero animated:YES];
//}
@end
