//
//  AllHouseCouponVC.m
//  TravelPoints
//
//  Created by WJ-Shao on 2019/3/28.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "AllHouseCouponVC.h"
#import "QYBaseView.h"
#import "AllHouseCouponCell.h"
@interface AllHouseCouponVC ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
    QYBaseView *_baseView;
}

@end

@implementation AllHouseCouponVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _baseView = [[QYBaseView alloc] initWithFrame:self.view.frame];
    _baseView.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
    self.view = _baseView;
    [self initTableView];
    UIButton *joinBtn = [[UIButton alloc] init];
    joinBtn.backgroundColor = APP_WHITECOLOR;
    [joinBtn setTitle:@"参与房劵活动" forState:UIControlStateNormal];
    [joinBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(joinActivity:) forControlEvents:UIControlEventTouchUpInside];
    joinBtn.titleLabel.font = QDBoldFont(20);
    [self.view addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.equalTo(_baseView);
        make.height.mas_equalTo(58);
        make.bottom.equalTo(_baseView);
    }];
}

- (void)joinActivity:(UIButton *)sender{
    QDLog(@"==============");
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.showsVerticalScrollIndicator = NO;
    [_baseView addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 171;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AllHouseCouponCell";
    AllHouseCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AllHouseCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell.ruleBtn addTarget:self action:@selector(reLayout:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
    return cell;
}

- (void)reLayout:(UIButton *)sender{
    sender.selected = !sender.selected;
    [_tableView reloadData];
}

@end
