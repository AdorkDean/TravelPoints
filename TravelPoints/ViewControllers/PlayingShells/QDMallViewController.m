//
//  QDPlayingShellsVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/15.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDMallViewController.h"
#import "QDMallTableCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "QDRefreshHeader.h"
#import "QDRefreshFooter.h"
#import "QDMallTableHeaderView.h"
#import "QDMallModel.h"
#import "QDBridgeViewController.h"
#import "QDKeyWordsSearchVC.h"
#import "QDSearchViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "QDMallTableSectionHeaderView.h"
#import "QDPopMenu.h"
//预定酒店 定制游 商城
@interface QDMallViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>{
    QDPlayShellType _playShellType;
    UITableView *_tableView;
    QDMallTableHeaderView *_mallHeaderView;
    NSMutableArray *_mallInfoArr;
    QDMallTableSectionHeaderView *_sectionHeaderView;
    UIView *_backView;
}
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic, strong) NSMutableArray *categoryArr;
@end

@implementation QDMallViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _categoryArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = APP_WHITECOLOR;
    _mallInfoArr = [[NSMutableArray alloc] init];
    [self initTableView];
    [self requestMallList:api_GetMallList];
    //请求商品列表
    [self finGoodsCategory];
}

#pragma mark - 查询商品分类
- (void)finGoodsCategory{
    if (_categoryArr.count) {
        [_categoryArr removeAllObjects];
    }
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_findCategory params:nil successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSArray *arr = responseObject.result;
            for (NSDictionary *dic in arr) {
                [_categoryArr addObject:[dic objectForKey:@"catName"]];
            }
            QDLog(@"_categoryArr = %@", _categoryArr);
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}

- (void)addToCar:(UIButton *)sender{
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_SHOPCART];
    QDLog(@"urlStr = %@", bridgeVC.urlStr);
    [self.navigationController pushViewController:bridgeVC animated:YES];
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
        }else{
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
        [self endRefreshing];
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [_tableView reloadEmptyDataSet];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.backgroundColor = APP_WHITECOLOR;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaTopHeight, 0);
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    _mallHeaderView = [[QDMallTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.08)];
    _mallHeaderView.backgroundColor = APP_WHITECOLOR;
    [_mallHeaderView.carBtn addTarget:self action:@selector(addToCar:) forControlEvents:UIControlEventTouchUpInside];
//    _tableView.tableHeaderView = _mallHeaderView;
    self.view = _tableView;
//    [self.view addSubview:_tableView];
    _tableView.mj_header = [QDRefreshHeader headerWithRefreshingBlock:^{
        [self endRefreshing];
    }];
    //手动刷新请求最新数据
    _tableView.mj_footer = [QDRefreshFooter footerWithRefreshingBlock:^{
        [self requestMallList:api_GetMallList];
    }];
}

- (void)endRefreshing
{
    if (_tableView) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }
}

#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mallInfoArr.count;
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

- (void)allAction:(UIButton *)sender{
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

- (QDMallTableSectionHeaderView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[QDMallTableSectionHeaderView alloc] init];
        _sectionHeaderView.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
        [_sectionHeaderView.allBtn addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sectionHeaderView.baoyouBtn addTarget:self action:@selector(baoyouAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sectionHeaderView.allBtn addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sectionHeaderView;
}

- (void)chooseCategory:(UIButton *)sender{
//    QDPopMenu *menu = [[QDPopMenu alloc] init];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.view addSubview:self.backView];
        [self.backView bringSubviewToFront:self.view];
        [sender setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_blueArrorDown"] forState:UIControlStateNormal];
    }else{
        [self.backView removeFromSuperview];
        [sender setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_arrowDown"] forState:UIControlStateNormal];
    }
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = APP_BLACKCOLOR;
        _backView.alpha = 0.3;
    }
    return _backView;
}

- (void)baoyouAction:(UIButton *)sender{
    if (sender.selected) {
        QDLog(@"选择包邮");
    }else{
        QDLog(@"不包邮");
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    QDMallModel *model = _mallInfoArr[indexPath.row];
    QDBridgeViewController *bridgeVC = [[QDBridgeViewController alloc] init];
    bridgeVC.urlStr = [NSString stringWithFormat:@"%@%@?id=%ld", [QDUserDefaults getObjectForKey:@"QD_JSURL"], JS_SHOPPING, (long)model.id];
    QDLog(@"urlStr = %@", bridgeVC.urlStr);
    bridgeVC.mallModel = model;
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bridgeVC animated:YES];
}

#pragma mark - DZNEmtpyDataSet Delegate
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

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSString *text = @"重新加载";
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName: APP_WHITECOLOR,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSString *imageName = @"button_background_kickstarter";
    if (state == UIControlStateNormal) imageName = [imageName stringByAppendingString:@"_normal"];
    if (state == UIControlStateHighlighted) imageName = [imageName stringByAppendingString:@"_highlight"];
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsMake(0.0, -20, 0.0, -20);
    UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loading = NO;
    });
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    self.loading = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.loading = NO;
    });
}
- (void)setLoading:(BOOL)loading
{
    if (self.isLoading == loading) {
        return;
    }
    _loading = loading;
    [_tableView reloadEmptyDataSet];
}

@end
