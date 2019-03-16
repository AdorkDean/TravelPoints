//
//  QDVipPurchaseVC.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/17.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDVipPurchaseVC.h"
#import "QDVipPurchaseView.h"
#import "NewPagedFlowView.h"
#import "PGCustomBannerView.h"
#import "VipCardDTO.h"
#import "QDReadyToCreateOrderVC.h"
#import "QDBuyOrSellViewController.h"
#import "QDSettingViewController.h"
#import "NSString+QDDecimalNumberHandler.h"
#import "AppDelegate.h"
@interface QDVipPurchaseVC ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource, UITableViewDelegate, UITableViewDataSource>{
    QDVipPurchaseView *_vipPurchaseView;
    UITableView *_tableView;
    BOOL _selected;
    VipCardDTO *_currentModel;
}
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) NSMutableArray *cardArr;
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 指示label
 */
@property (nonatomic, strong) UILabel *indicateLabel;

/**
 轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;

@end

@implementation QDVipPurchaseVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        //设置显示内容的大小，这里表示可以下滑十倍原高度
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT*1.15);
        //设置当滚动到边缘继续滚时是否像橡皮经一样弹回
        _scrollView.bounces = YES;
        //设置滚动条指示器的类型，默认是白边界上的黑色滚动条
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;//还有UIScrollViewIndicatorStyleBlack、UIScrollViewIndicatorStyleWhite
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.maximumZoomScale = 2.0;//最多放大到两倍
        _scrollView.minimumZoomScale = 0.5;//最多缩小到0.5倍
        //设置是否允许缩放超出倍数限制，超出后弹回
        _scrollView.bouncesZoom = YES;
        //设置委托
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员申购";
    [self showBack:YES];
    self.view.backgroundColor = APP_WHITECOLOR;
    _imageArray = [[NSMutableArray alloc] init];
    _cardArr = [[NSMutableArray alloc] init];
    [self.view addSubview:self.scrollView];
    _vipPurchaseView = [[QDVipPurchaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self queryOrderPay:api_FindPurchaseInfos];
    [_vipPurchaseView.returnBtn addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    [_vipPurchaseView.confirmBtn addTarget:self action:@selector(confirmToBuy:) forControlEvents:UIControlEventTouchUpInside];
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _vipPurchaseView.basePrice = appD.basePirceRate;
    QDLog(@"%lf", _vipPurchaseView.basePrice);
    if(_cardArr.count){
        VipCardDTO *model = _cardArr[0];
        _vipPurchaseView.bottomLab2.text = model.vipMoney;
    }
    [_scrollView addSubview:_vipPurchaseView];
    for (int index = 1; index < 6; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"img_card%d", index]];
        [_imageArray addObject:image];
    }
    [self setupCardUI];
    [self initBottomBtn];
    // Do any additional setup after loading the view.
}

- (void)initBottomBtn{
    _confirmBtn = [[UIButton alloc] init];
    [_confirmBtn setTitle:@"确认购买" forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = APP_BLUECOLOR;
    [_confirmBtn setTitleColor:APP_WHITECOLOR forState:UIControlStateNormal];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.89, 50);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点

    [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#159095"] CGColor],(id)[[UIColor colorWithHexString:@"#3CC8B1"] CGColor]]];//渐变数组
    [_confirmBtn.layer addSublayer:gradientLayer];
    _confirmBtn.layer.cornerRadius = 8;
    _confirmBtn.layer .masksToBounds = YES;
    _confirmBtn.titleLabel.font = QDFont(19);
    [_confirmBtn addTarget:self action:@selector(confirmToBuy:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_confirmBtn];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollView.mas_top).offset(SCREEN_HEIGHT*1.02);
        make.centerX.equalTo(_scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - 积分充值卡查询
- (void)queryOrderPay:(NSString *)urlStr{
    if (_cardArr.count) {
        [_cardArr removeAllObjects];
    }
    //先查询全部
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:urlStr params:nil successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            NSArray *hotelArr = [dic objectForKey:@"vipCardInfos"];
            if (hotelArr.count) {
                for (NSDictionary *dic in hotelArr) {
                    VipCardDTO *model = [VipCardDTO yy_modelWithDictionary:dic];
                    [_cardArr addObject:model];
                }
                [self.pageFlowView reloadData];
                //默认数据
                if (_cardArr.count) {
                    VipCardDTO *model = _cardArr.firstObject;
                    
//                    _vipPurchaseView.price.hidden = NO;
//                    _vipPurchaseView.price.text = _currentModel.vipMoney;
                    //折合玩贝
                    NSString *ss = [model.vipMoney stringByDividingBy:model.basePrice withRoundingMode:NSRoundPlain scale:0];
                    _vipPurchaseView.bottomLab2.text = ss;
                    _vipPurchaseView.price.text = model.vipMoney;
                    _vipPurchaseView.priceTF.hidden = YES;

//                    _vipPurchaseView.bottomLab2.text = model.vipMoney;
                }
                [_vipPurchaseView layoutSubviews];
                
            }else{
                [WXProgressHUD showErrorWithTittle:@"暂无VIP售卡信息"];
            }
        }else{
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [_tableView reloadData];
        [WXProgressHUD showErrorWithTittle:@"网络异常"];
    }];
}
- (void)setupCardUI{
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.24, SCREEN_WIDTH, SCREEN_HEIGHT*0.54)];
    pageFlowView.backgroundColor = APP_WHITECOLOR;
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.01;
    pageFlowView.isCarousel = YES;
    pageFlowView.orginPageCount = self.imageArray.count;
    pageFlowView.leftRightMargin = 30;
    pageFlowView.topBottomMargin = 0;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    pageFlowView.isOpenAutoScroll = NO;
    [pageFlowView reloadData];
    [self.scrollView addSubview:pageFlowView];
    self.pageFlowView = pageFlowView;
    //添加到主view上
//    [self.view addSubview:self.indicateLabel];
    
}

- (UILabel *)indicateLabel {
    
    if (_indicateLabel == nil) {
        _indicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, SCREEN_WIDTH, 16)];
        _indicateLabel.textColor = [UIColor blueColor];
        _indicateLabel.font = [UIFont systemFontOfSize:16.0];
        _indicateLabel.textAlignment = NSTextAlignmentCenter;
        _indicateLabel.text = @"指示Label";
    }
    
    return _indicateLabel;
}

- (void)popVC:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确认购买
- (void)confirmToBuy:(UIButton *)sender{
    QDReadyToCreateOrderVC *orderVC = [[QDReadyToCreateOrderVC alloc] init];
    if (_currentModel == nil && _cardArr.count) {
        _currentModel = _cardArr[0];
    }
    if (![_vipPurchaseView.priceTF isHidden] && (_vipPurchaseView.priceTF.text == nil || [_vipPurchaseView.priceTF.text isEqualToString:@""])) {
        [WXProgressHUD showErrorWithTittle:@"请输入充值金额"];
        return;
    }
    if (_cardArr.count == 0) {
        [WXProgressHUD showErrorWithTittle:@"充值卡信息获取失败"];
        return;
    }
    //针对输入金额
    if ([_currentModel.vipMoney isEqualToString:@"0"]) {
        _currentModel.vipMoney = _vipPurchaseView.priceTF.text;
        _currentModel.subscriptCount = _vipPurchaseView.bottomLab2.text;
    }
    orderVC.vipModel = _currentModel;
    [self.navigationController pushViewController:orderVC animated:YES];
}

#pragma mark - NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView{
    return CGSizeMake(SCREEN_WIDTH*0.59, SCREEN_HEIGHT*0.54);
}

- (void)didSelectCell:(PGIndexBannerSubiew *)subView withSubViewIndex:(NSInteger)subIndex{
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    NSLog(@"ViewController 滚动到了第%ld页",pageNumber);
    if (_cardArr.count) {
        _currentModel = _cardArr[pageNumber];
        if ([_currentModel.vipMoney doubleValue] == 0) {
            _vipPurchaseView.price.hidden = YES;
            _vipPurchaseView.priceTF.hidden = NO;
            _vipPurchaseView.bottomLab2.text = @"--";
        }else{
            _vipPurchaseView.price.hidden = NO;
            _vipPurchaseView.price.text = _currentModel.vipMoney;
            //折合玩贝
            NSString *ss = [_currentModel.vipMoney stringByDividingBy:_currentModel.basePrice withRoundingMode:NSRoundPlain scale:0];
            _vipPurchaseView.bottomLab2.text = ss;
            _vipPurchaseView.priceTF.hidden = YES;
        }
    }
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView{
    return self.imageArray.count;
}


- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGCustomBannerView *bannerView = (PGCustomBannerView *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGCustomBannerView alloc] init];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    bannerView.mainImageView.image = self.imageArray[index];
    if (_cardArr.count) {
        [bannerView loadDataWithModel:_cardArr[index]];
    }
    return bannerView;
}

#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCREEN_HEIGHT*0.075;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT*0.225;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

@end
