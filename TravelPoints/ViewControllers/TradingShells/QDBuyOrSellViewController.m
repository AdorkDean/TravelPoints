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
#define AddBtnWidth SCREEN_WIDTH*0.075
@interface QDBuyOrSellViewController ()<UITableViewDelegate, UITableViewDataSource, PPNumberButtonDelegate>{
    UITableView *_tableView;
    UIButton *_operateBtn;
    int maxNumber;
    int minNumber;
    int currentNumber;
    
    int finalNum;
}
@property (nonatomic, strong) PPNumberButton *numberButton;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *balanceLab;

@end

@implementation QDBuyOrSellViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    self.tabBarController.tabBar.frame = CGRectZero;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
    self.tabBarController.tabBar.frame = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    minNumber = 0;
    maxNumber = 5;
    self.title = @"要玩贝";
    self.view.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    [self showBack:YES];
    [self initTableView];
    // Do any additional setup after loading the view.
}
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.015 + SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    _operateBtn = [[UIButton alloc] init];
    [_operateBtn setTitle:@"确认并支付" forState:UIControlStateNormal];
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
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(SCREEN_HEIGHT*0.06);
        }];
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"价格";
        cell.textLabel.font = QDFont(16);
        [cell.contentView addSubview:self.priceLab];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-(SCREEN_WIDTH*0.05));
        }];
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"金额";
        cell.textLabel.font = QDFont(16);
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
    QDShellRecommendVC *recommendVC = [[QDShellRecommendVC alloc] init];
    recommendVC.recommendModel = _operateModel;
    recommendVC.postersType = _postersType;
    recommendVC.price = [_priceLab.text doubleValue];
    recommendVC.volume = finalNum;
    [self.navigationController pushViewController:recommendVC animated:YES];
}


#pragma mark - lazy
- (PPNumberButton *)numberButton
{
    if (!_numberButton) {
        _numberButton = [[PPNumberButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];

        _numberButton.shakeAnimation = YES;
        // 设置最小值
        _numberButton.minValue = minNumber;
        // 设置最大值
        _numberButton.maxValue = maxNumber;
        _numberButton.delegate = self;
        _numberButton.increaseImage = [UIImage imageNamed:@"icon_increase"];
        _numberButton.decreaseImage = [UIImage imageNamed:@"icon_decrease"];
        _numberButton.currentNumber = currentNumber;
        
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
        _balanceLab.text = [NSString stringWithFormat:@"%.2f", currentNumber * [_operateModel.price floatValue]];
        _balanceLab.font = QDFont(16);
        _balanceLab.textColor = APP_BLACKCOLOR;
    }
    return _balanceLab;
}

- (void)pp_numberButton:(__kindof UIView *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus
{
    NSLog(@"%@",increaseStatus ? @"加运算":@"减运算");
    _balanceLab.text = [NSString stringWithFormat:@"%.2f", number * [_operateModel.price floatValue]];
    finalNum = (int)number;
    if (number ==  minNumber ) {
        _numberButton.decreaseImage = [UIImage imageNamed:@"icon_grayDecrease"];
        _numberButton.increaseImage = [UIImage imageNamed:@"icon_increase"];
    }else if (number == maxNumber) {
        _numberButton.decreaseImage = [UIImage imageNamed:@"icon_decrease"];
        _numberButton.increaseImage = [UIImage imageNamed:@"icon_grayIncrease"];
    }else{
        _numberButton.decreaseImage = [UIImage imageNamed:@"icon_decrease"];
        _numberButton.increaseImage = [UIImage imageNamed:@"icon_increase"];
    }
}


@end
