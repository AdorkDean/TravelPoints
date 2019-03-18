//
//  QDBuyOrSellViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/16.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDFindSatifiedDataVC.h"
#import "PPNumberButton.h"
#import "QDShellRecommendVC.h"
#import "QDRecommendViewController.h"
#import "CWActionSheet.h"
#define AddBtnWidth SCREEN_WIDTH*0.075
@interface QDFindSatifiedDataVC ()<UITableViewDelegate, UITableViewDataSource, PPNumberButtonDelegate>{
    UITableView *_tableView;
    UIButton *_operateBtn;
    int maxNumber;
    int minNumber;
    int currentNumber;
}
@property (nonatomic, strong) PPNumberButton *amountNumBtn;
@property (nonatomic, strong) PPNumberButton *priceNumBtn;

@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *situationLab;
@property (nonatomic, strong) NSString *isPartialDeal;


@end

@implementation QDFindSatifiedDataVC

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
    minNumber = 0;
    maxNumber = 5;
    _isPartialDeal = @"1";
    self.title = @"行点";
    self.view.backgroundColor = APP_WHITECOLOR;
    [self setLeftBtnItem];
    [self initTableView];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.015, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    _tableView.backgroundColor = APP_BLUECOLOR;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    _operateBtn = [[UIButton alloc] init];
    if ([_typeStr isEqualToString:@"1"]) {
        [_operateBtn setTitle:@"确认购买" forState:UIControlStateNormal];
    }else{
        [_operateBtn setTitle:@"确认卖出" forState:UIControlStateNormal];
    }
    [_operateBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 335, 50);
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
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(306);
        make.width.mas_equalTo(335);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark -- tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
        [cell.contentView addSubview:self.amountNumBtn];
        [_amountNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-(SCREEN_WIDTH*0.05));
            make.width.mas_equalTo(145);
            make.height.mas_equalTo(SCREEN_HEIGHT*0.06);
        }];
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"价格";
        cell.textLabel.font = QDFont(16);
        [cell.contentView addSubview:self.priceNumBtn];
        [_priceNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-(SCREEN_WIDTH*0.05));
            make.width.mas_equalTo(145);
            make.height.mas_equalTo(SCREEN_HEIGHT*0.06);
        }];
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"金额";
        cell.textLabel.font = QDFont(16);
        [cell.contentView addSubview:self.priceLab];
        self.priceLab.text = [NSString stringWithFormat:@"%.2lf", _amountNumBtn.currentNumber * _priceNumBtn.currentNumber];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-(SCREEN_WIDTH*0.05));
        }];
    }else{
        cell.textLabel.text = @"是否接受部分成交";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = QDFont(16);
        [cell.contentView addSubview:self.situationLab];
        [_situationLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-(SCREEN_WIDTH*0.05));
        }];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 3) {
        NSArray *titleArr = [[NSArray alloc] initWithObjects:@"是", @"否", nil];
        CWActionSheet *sheet = [[CWActionSheet alloc] initWithTitles:@[@"是", @"否"] clickAction:^(CWActionSheet *sheet, NSIndexPath *indexPath) {
//            _situationLab.text = titleArr[indexPath];
            _situationLab.text = titleArr[indexPath.row];
            QDLog(@"123");
            //该笔挂单是否部分成交0-不允许 1-允许
            if (indexPath.row == 0) {
                _isPartialDeal = @"1";
            }else{
                _isPartialDeal = @"0";
            }
        }];
        [sheet show];
    }
}

- (void)addAction:(id)sender{
    
}

- (void)subAction:(id)sender{
    
}

- (void)payAction:(UIButton *)sender{
    QDRecommendViewController *recommendVC = [[QDRecommendViewController alloc] init];
    
//    QDShellRecommendVC *recommendVC = [[QDShellRecommendVC alloc] init];
    recommendVC.price = [NSString stringWithFormat:@"%.2f",self.priceNumBtn.currentNumber];
    recommendVC.volume = [NSString stringWithFormat:@"%.2f",self.amountNumBtn.currentNumber];
    recommendVC.isPartialDeal = _isPartialDeal;
    recommendVC.postersType = _typeStr;
    [self.navigationController pushViewController:recommendVC animated:YES];
}

#pragma mark - 价格
- (PPNumberButton *)priceNumBtn
{
    if (!_priceNumBtn) {
        _priceNumBtn = [[PPNumberButton alloc] initWithFrame:CGRectMake(0, 0, 145, 40)];
//        _priceNumBtn.inputFieldFont
        _priceNumBtn.shakeAnimation = YES;
        _priceNumBtn.stepValue = 0.1;
        _priceNumBtn.decimalNum = YES;
        // 设置最小值
        _priceNumBtn.minValue = 0.1;
        _priceNumBtn.currentNumber = 0.1;
        // 设置最大值
        [_priceNumBtn.textField addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _priceNumBtn.maxValue = 10000;
        _priceNumBtn.delegate = self;
        _priceNumBtn.increaseImage = [UIImage imageNamed:@"icon_increase"];
        _priceNumBtn.decreaseImage = [UIImage imageNamed:@"icon_grayDecrease"];
        _priceNumBtn.currentNumber = currentNumber;
        
        // 设置输入框中的字体大小
        _priceNumBtn.inputFieldFont = 16;
        _priceNumBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
            NSLog(@"%lf",number);
        };
    }
    return _priceNumBtn;
}

#pragma mark - 数量
- (PPNumberButton *)amountNumBtn
{
    if (!_amountNumBtn) {
        _amountNumBtn = [[PPNumberButton alloc] initWithFrame:CGRectMake(0, 0, 145, 40)];
        _amountNumBtn.shakeAnimation = YES;
        _amountNumBtn.stepValue = 1;
        // 设置最小值
        _amountNumBtn.minValue = 1;
        _amountNumBtn.currentNumber = 1;
        // 设置最大值
        _amountNumBtn.maxValue = 10000;
        _amountNumBtn.delegate = self;
        [_amountNumBtn.textField addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _amountNumBtn.increaseImage = [UIImage imageNamed:@"icon_increase"];
        _amountNumBtn.decreaseImage = [UIImage imageNamed:@"icon_grayDecrease"];
        _amountNumBtn.currentNumber = currentNumber;
        
        // 设置输入框中的字体大小
        _amountNumBtn.inputFieldFont = 16;
        _amountNumBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
            NSLog(@"%lf",number);
        };
    }
    return _amountNumBtn;
}
- (UILabel *)priceLab{
    if(!_priceLab){
        _priceLab = [[UILabel alloc] init];
//        _priceLab.text = _operateModel.price;
        _priceLab.font = QDFont(16);
        _priceLab.textColor = APP_BLACKCOLOR;
    }
    return _priceLab;
}

- (UILabel *)situationLab{
    if(!_situationLab){
        _situationLab = [[UILabel alloc] init];
        _situationLab.text = @"是";
        _situationLab.font = QDFont(16);
        _situationLab.textColor = APP_BLACKCOLOR;
    }
    return _situationLab;
}

- (void)pp_numberButton:(__kindof UIView *)numberButton number:(NSInteger)number increaseStatus:(BOOL)increaseStatus
{
    NSLog(@"%@",increaseStatus ? @"加运算":@"减运算");
    _priceLab.text = [NSString stringWithFormat:@"%.2lf", _amountNumBtn.currentNumber * _priceNumBtn.currentNumber];
    if (numberButton == self.amountNumBtn) {
        if (number ==  self.amountNumBtn.minValue ) {
            _amountNumBtn.decreaseImage = [UIImage imageNamed:@"icon_grayDecrease"];
            _amountNumBtn.increaseImage = [UIImage imageNamed:@"icon_increase"];
        }else if (number == maxNumber) {
            _amountNumBtn.decreaseImage = [UIImage imageNamed:@"icon_decrease"];
            _amountNumBtn.increaseImage = [UIImage imageNamed:@"icon_grayIncrease"];
        }else{
            _amountNumBtn.decreaseImage = [UIImage imageNamed:@"icon_decrease"];
            _amountNumBtn.increaseImage = [UIImage imageNamed:@"icon_increase"];
        }
    }else{
        if (number == self.priceNumBtn.minValue) {
            _priceNumBtn.decreaseImage = [UIImage imageNamed:@"icon_grayDecrease"];
            _priceNumBtn.increaseImage = [UIImage imageNamed:@"icon_increase"];
        }else if (number == maxNumber) {
            _priceNumBtn.decreaseImage = [UIImage imageNamed:@"icon_decrease"];
            _priceNumBtn.increaseImage = [UIImage imageNamed:@"icon_grayIncrease"];
        }else{
            _priceNumBtn.decreaseImage = [UIImage imageNamed:@"icon_decrease"];
            _priceNumBtn.increaseImage = [UIImage imageNamed:@"icon_increase"];
        }
    }
}

- (void)textfieldDidChange:(UITextField *)textField{
    self.priceLab.text = [NSString stringWithFormat:@"%.2lf", _amountNumBtn.currentNumber * _priceNumBtn.currentNumber];
}

@end
