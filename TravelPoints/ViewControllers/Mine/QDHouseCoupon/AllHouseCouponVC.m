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
#import "HotelCouponDetailDTO.h"
#import "closeCell.h"
#import "openCell.h"
#import "BaseCell.h"
@interface AllHouseCouponVC ()<UITableViewDelegate, UITableViewDataSource, BaseCellDelegate>{
    UITableView *_tableView;
    QYBaseView *_baseView;
    NSIndexPath *_currentIndexPath;
    NSMutableArray *_houseCouponList;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger isOpen;
@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, strong) NSMutableArray *StatusArray;
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
    _houseCouponList = [[NSMutableArray alloc] init];
    _baseView = [[QYBaseView alloc] initWithFrame:self.view.frame];
    _baseView.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
    self.view = _baseView;
    UIButton *joinBtn = [[UIButton alloc] init];
    joinBtn.backgroundColor = APP_WHITECOLOR;
    [joinBtn setTitle:@"参与房劵活动" forState:UIControlStateNormal];
    [joinBtn setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(joinActivity:) forControlEvents:UIControlEventTouchUpInside];
    joinBtn.titleLabel.font = QDBoldFont(20);
    [_baseView addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.width.equalTo(_baseView);
        make.height.mas_equalTo(58);
        make.bottom.equalTo(_baseView);
    }];
    [_baseView addSubview:self.tableView];
    //查询我的房券
//    [self findAllMyHouseCoupon];
}


- (void)findAllMyHouseCoupon{
    if (_houseCouponList.count) {
        [_houseCouponList removeAllObjects];
    }
    NSDictionary *dic = @{@"isUsed":@4,
                          @"pageNum":@1,
                          @"pageSize":@20
                          };
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_findAllMyHouseCoupon params:dic successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSArray *arr = [responseObject.result objectForKey:@"result"];
            if (arr.count) {
                for (NSDictionary *dic in arr) {
                    HotelCouponDetailDTO *model = [HotelCouponDetailDTO yy_modelWithDictionary:dic];
                    [_houseCouponList addObject:model];
                }
            }
            [_tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)joinActivity:(UIButton *)sender{
    QDLog(@"==============");
}

#pragma mark lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
        _tableView.separatorStyle = 0;
    }
    return _tableView;
}


- (NSMutableArray *)StatusArray{
    if (!_StatusArray) {
        _StatusArray = [NSMutableArray array];
    }
    return _StatusArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _houseCouponList.count;
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *row = [NSString stringWithFormat:@"%ld",indexPath.row];
    BOOL isbool = [self.StatusArray containsObject: row];
    if (isbool == NO){
        return 136+30;
    }else{
        return 176+30;
    }
    return indexPath.row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *identifier = @"AllHouseCouponCell";
//    AllHouseCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[AllHouseCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    if (_houseCouponList.count) {
//        [cell loadCouponViewWithModel:_houseCouponList[indexPath.row]];
//    }
//    cell.reLayoutBlock = ^(BOOL ss) {
//        [_tableView reloadData];
//    };
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = APP_GRAYBACKGROUNDCOLOR;
//    return cell;
    BaseCell *cell = nil;
    //如果有网络请求数据，更改model
    cell.userInteractionEnabled = YES;
    NSString *cellIdentifier;
    
    NSString *row = [NSString stringWithFormat:@"%ld",indexPath.row];
    //是用来判断有没用被打开// YES (BOOL)1// NO  (BOOL)0
    BOOL isbool = [self.StatusArray containsObject: row];
    if (isbool == NO){
        
        cellIdentifier = @"unOpen";
        
    }else{
        
        cellIdentifier = @"open";
        
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        if (isbool == NO){
            
            cell = [[closeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }else{
            
            cell = [[openCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
    }
    cell.delegate = self;
    cell.backgroundColor = APP_WHITECOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = (int)indexPath.row;
    
    cell.indexArr = self.StatusArray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentIndexPath = indexPath;
    [_tableView reloadData];
}

- (void)baseCell:(BaseCell *)baseCell btnType:(BtnType)btnType WithIndex:(int)index withArr:(nonnull NSMutableArray *)array{
    self.isOpen = btnType;
    self.cellIndex = index;
    self.StatusArray = array;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}


@end
