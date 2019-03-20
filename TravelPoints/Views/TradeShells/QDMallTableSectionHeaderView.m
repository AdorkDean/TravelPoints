//
//  QDTradeShellsSectionHeaderView.m
//  TravelPoints
//
//  Created by 冉金 on 2019/2/15.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDMallTableSectionHeaderView.h"
#import "UIButton+ImageTitleStyle.h"
static char *const btnKey = "btnKey";

@interface QDMallTableSectionHeaderView()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL show;
    BOOL baoyou;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backView;
@end

@implementation QDMallTableSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        _allBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
        [_allBtn setImage:[UIImage imageNamed:@"icon_arrowDown"] forState:UIControlStateNormal];
        [_allBtn setTitle:@"全部" forState:UIControlStateNormal];
        [_allBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
//        [_allBtn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
        _allBtn.titleLabel.font = QDFont(14);
        [self addSubview:_allBtn];
        
        _amountBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
        [_amountBtn setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
        [_amountBtn setTitle:@"销量" forState:UIControlStateNormal];
        [_amountBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        _amountBtn.titleLabel.font = QDFont(14);
        _amountBtn.tag = 101;
        [_amountBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_amountBtn];
        objc_setAssociatedObject(_amountBtn, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
        
        _priceBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionRight];
        [_priceBtn setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
        [_priceBtn setTitle:@"价格" forState:UIControlStateNormal];
        [_priceBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        _priceBtn.titleLabel.font = QDFont(14);
        _priceBtn.tag = 102;
        [_priceBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_priceBtn];
        objc_setAssociatedObject(_priceBtn, btnKey, @"2", OBJC_ASSOCIATION_ASSIGN);
        
        _baoyouBtn = [[SPButton alloc] initWithImagePosition:SPButtonImagePositionLeft];
        [_baoyouBtn addTarget:self action:@selector(baoyouAction:) forControlEvents:UIControlEventTouchUpInside];
        [_baoyouBtn setImage:[UIImage imageNamed:@"icon_baoyouNormal"] forState:UIControlStateNormal];
        [_baoyouBtn setTitle:@"包邮" forState:UIControlStateNormal];
        [_baoyouBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        _baoyouBtn.titleLabel.font = QDFont(14);
        [self addSubview:_baoyouBtn];
    }
    return self;
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.backgroundColor = APP_BLACKCOLOR;
        _backView.alpha = 0.3;
    }
    return _backView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 393) style:UITableViewStylePlain];
        _tableView.backgroundColor = APP_BLUECOLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)selectClick:(UIButton *)btn{
    NSString *str;
    MallBtnClickType type = MallBtnClickTypeNormal ;
//    if (btn.tag == 101) {
//        [_priceBtn setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
//        NSString *flag = objc_getAssociatedObject(btn, btnKey);
//        if ([flag isEqualToString:@"1"]) {  //是数量按钮
//            [btn setImage:[UIImage imageNamed:@"icon_shellpositive"] forState:UIControlStateNormal];
//            objc_setAssociatedObject(btn, btnKey, @"2", OBJC_ASSOCIATION_ASSIGN);
//            type = ButtonClickTypeUp;
//            QDLog(@"amountUp");
//            str = @"amountUp";
//            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_AmountUp object:nil];
//        }else if ([flag isEqualToString:@"2"]){
//            [btn setImage:[UIImage imageNamed:@"icon_shellreverse"] forState:UIControlStateNormal];
//            objc_setAssociatedObject(btn, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
//            type = ButtonClickTypeDown;
//            QDLog(@"amountDown");
//            str = @"amountDown";
//            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_AmountDown object:nil];
//
//        }
//    }else if (btn.tag == 102){
//        [_amountBtn setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
//        NSString *flag = objc_getAssociatedObject(btn, btnKey);
//        if ([flag isEqualToString:@"1"]) {
//            [btn setImage:[UIImage imageNamed:@"icon_shellpositive"] forState:UIControlStateNormal];
//            objc_setAssociatedObject(btn, btnKey, @"2", OBJC_ASSOCIATION_ASSIGN);
//            type = ButtonClickTypeUp;
//            QDLog(@"priceUp");
//            str = @"priceUp";
//            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PriceUp object:nil];
//        }else if ([flag isEqualToString:@"2"]){
//            [btn setImage:[UIImage imageNamed:@"icon_shellreverse"] forState:UIControlStateNormal];
//            objc_setAssociatedObject(btn, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
//            type = ButtonClickTypeDown;
//            QDLog(@"priceDown");
//            str = @"priceDown";
//            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_PriceDown object:nil];
//        }
//    }else{
//        //点击全部不复位价格
//        if (btn.tag != 103) {
//            UIButton *button = [self viewWithTag:102];
//            [button setImage:[UIImage imageNamed:@"icon_shellDefault"] forState:UIControlStateNormal];
//            objc_setAssociatedObject(button, btnKey, @"1", OBJC_ASSOCIATION_ASSIGN);
//            type = ButtonClickTypeNormal;
//        }
//    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    [_amountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(100);
        make.width.and.height.equalTo(_allBtn);
    }];
    
    [_priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(200);
        make.width.and.height.equalTo(_allBtn);
    }];
    
    [_baoyouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-36);
        make.width.and.height.equalTo(_allBtn);
    }];
}

- (void)baoyouAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_baoyouBtn setImage:[UIImage imageNamed:@"icon_baoyouSelected"] forState:UIControlStateNormal];
    }else{
        [_baoyouBtn setImage:[UIImage imageNamed:@"icon_baoyouNormal"] forState:UIControlStateNormal];
    }
}

- (void)selectCategory:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self addSubview:self.backView];
        [sender setTitleColor:APP_BLUECOLOR forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_blueArrorDown"] forState:UIControlStateNormal];
        [self addSubview:self.tableView];
    }else{
        [self.backView removeFromSuperview];
        [sender setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"icon_arrowDown"] forState:UIControlStateNormal];
        [self.tableView removeFromSuperview];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"会员等级1";
    return cell;
}

@end
