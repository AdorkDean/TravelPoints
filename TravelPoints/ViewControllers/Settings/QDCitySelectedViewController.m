//
//  QDCitySelectedViewController.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/18.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "QDCitySelectedViewController.h"
#import "QDLocationTopSelectView.h"
#import "QDCurrentLocationView.h"
@interface QDCitySelectedViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) QDLocationTopSelectView *topView;
@property (nonatomic, strong) QDCurrentLocationView *currentLocationView;
@end

@implementation QDCitySelectedViewController{
    NSArray *_hotCitys;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self setTableView];
//    [self setSearchController];
    [self prepareData];
    if (_openLocation) {
        [self locate];
    }
}

- (void)setSearchController {
    self.resultVc = [[UITableViewController alloc]init];
    _searchVc = [[SYSearchController alloc]initWithSearchResultsController:self.resultVc];
    _searchVc.delegate = self;
    _searchVc.searchResultsUpdater = self;
    _searchVc.searchBar.delegate = self;
    _searchVc.resultDelegate = self;
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    _searchVc.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    _searchVc.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏
    _searchVc.hidesNavigationBarDuringPresentation = NO;
    
    _tableView.tableHeaderView = self.searchVc.searchBar;
}

- (void)setTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.37, SCREEN_WIDTH, SCREEN_HEIGHT*0.63) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor colorWithHexString:@"#F4F4F4"];
    _tableView.sectionIndexColor = [UIColor grayColor]; //设置默认时索引值颜色
}

- (void)initUI{
    _topView = [[QDLocationTopSelectView alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, SCREEN_HEIGHT*0.05)];
    [_topView.cancelBtn addTarget:self action:@selector(cancelSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topView];
    
    _currentLocationView = [[QDCurrentLocationView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.17, SCREEN_WIDTH, SCREEN_HEIGHT*0.2)];
    [self.view addSubview:_currentLocationView];
}

- (void)prepareData {
    _historyCitys = [NSKeyedUnarchiver unarchiveObjectWithFile:SYHistoryCitysPath];
    NSArray *tempIndex = @[];
    
    if (!_cityDict) {
        if (!_citys) {
            NSArray *citys = [self arrayWithPathName:@"city"];
            //    NSArray *citydatas = [self arrayWithPathName:@"citydata"];
            
            __block NSMutableArray *city = @[].mutableCopy;
            [citys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [city addObject:obj[@"name"]];
            }];
            _citys = city.copy;
        }
        _cityNames = [SYPinyinSort sortWithChineses:_citys];
        tempIndex = [[SYPinyinSort defaultPinyinSort] indexArray];
    } else {
        
        NSArray *index = [_cityDict allKeys];
        tempIndex = [index sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSMutableArray *mArr = @[].mutableCopy;
        [tempIndex enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mArr addObject:self.cityDict[obj]];
        }];
        
        _cityNames = mArr.copy;
    }
    
    NSMutableArray *sortCitys = @[].mutableCopy;
    NSMutableArray *sortIndex = @[].mutableCopy;
    
    [sortIndex addObject:@"#"];
    [sortCitys addObject:self.hotCitys];
    _kCount++;
    
    [sortIndex addObjectsFromArray:tempIndex];
    [sortCitys addObjectsFromArray:_cityNames];
    
    _indexArray = sortIndex.copy;
    _cityDicts = [NSMutableDictionary dictionaryWithObjects:sortCitys forKeys:sortIndex];
}

- (void)saveHistoryCitys:(NSString *)cityName {
    NSMutableArray *marr = @[].mutableCopy;
    [marr addObjectsFromArray:self.historyCitys];
    [marr removeObject:cityName];
    [marr insertObject:cityName atIndex:0];
    
    if (marr.count > 4) [marr removeObjectsInRange:NSMakeRange(4, marr.count - 4)];
    self.historyCitys = [marr copy];
    
    [NSKeyedArchiver archiveRootObject:self.historyCitys toFile:SYHistoryCitysPath];
    if (!_selectCity) return;
    _selectCity(cityName);
    [self cancelDidClick];
}

#pragma mark - events
- (void)cancelDidClick {
    if (_searchVc.presentingViewController) {
        [self.navigationController.view addSubview:self.navigationController.navigationBar];
        [_searchVc dismissViewControllerAnimated:NO completion:nil];
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Delegate
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [searchController.searchBar text];
    NSMutableArray *dataArray = @[].mutableCopy;
    //过滤数据
    for (NSArray *arr in self.cityNames) {
        for (NSString *city in arr) {
            if ([city rangeOfString:searchString].location != NSNotFound) {
                [dataArray addObject:city];
                continue;
            }
            NSString *pinyin = [[SYChineseToPinyin pinyinFromChiniseString:city] lowercaseString];
            if ([pinyin hasPrefix:[searchString lowercaseString]]) {
                [dataArray addObject:city];
                continue;
            }
        }
    }
    
    if (dataArray.count <= 0) {
        [dataArray addObject:@"抱歉，未找到相关位置，可尝试修改后重试"];
    }
    
    //刷新表格
    
    _searchVc.maskView.hidden = YES;
    if ([searchController.searchBar.text isEqualToString:@""]) _searchVc.maskView.hidden = NO;
    self.searchVc.results = dataArray;
    self.resultVc.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    self.resultVc.tableView.scrollIndicatorInsets = self.resultVc.tableView.contentInset;
    [self.resultVc.tableView reloadData];
}

#pragma mark - SYSearchResultControllerDelegate
- (void)resultViewController:(SYSearchController *)resultVC didSelectFollowCity:(NSString *)cityName {
    self.searchVc.searchBar.text = @"";
    [self saveHistoryCitys:cityName];
}

#pragma mark - UISearchBarDelegate
// 修改SearchBar的Cancel Button 的Title
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar; {
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn = [searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchVc.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cityDicts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < _kCount) return 1;
    NSArray *categoryCitys = _cityDicts[_indexArray[section]];
    return categoryCitys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *categoryCitys = _cityDicts[_indexArray[indexPath.section]];
    if (indexPath.section < _kCount) {
        SYCitysCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYCitysCell"];
        if (!cell) {
            __weak typeof(self) weakSelf = self;
            cell = [[SYCitysCell alloc] initWithReuseIdentifier:@"SYCitysCell"];
            cell.selectCity = ^(NSString *cityName) {
                __strong typeof(weakSelf) strongSelf = self;
                [strongSelf saveHistoryCitys:cityName];
            };
        }
        cell.citys = categoryCitys;
        return cell;
    }
    
    SYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SYTableViewCell"];
    if (!cell) {
        cell = [[SYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SYTableViewCell"];
    }
    cell.textLabel.font = QDFont(15);
    cell.isShowSeparator = YES;
    if (indexPath.row >= [categoryCitys count] - 1) cell.isShowSeparator = NO;
    cell.textLabel.text = categoryCitys[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section < _kCount) {
        NSArray *categoryCitys = _cityDicts[_indexArray[indexPath.section]];
        CGFloat h = [SYCitysCell heightForCitys:categoryCitys];
        return indexPath.section == _kCount - 1 ? h + 10 : h;
    }
    return SCREEN_HEIGHT*0.08;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SCREEN_HEIGHT*0.07;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerViewId = @"SYHeaderViewId";
    SYHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView) {
        headerView = [[SYHeaderView alloc] initWithReuseIdentifier:headerViewId];
    }
    NSString *title = self.indexArray[section];
    if ([title isEqualToString:@"#"]) {
        title = @"热门城市";
    }
    if (section == 0) {
        SYHotCityHeaderView *hotView = [[SYHotCityHeaderView alloc] init];
        return hotView;
    }else{
        headerView.titleLabel.text = title;
        return headerView;
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < _kCount) return;
    NSArray *categoryCitys = _cityDicts[_indexArray[indexPath.section]];
    [self saveHistoryCitys:categoryCitys[indexPath.row]];
}

//点击右侧索引表项时调用
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark - lazy load
- (NSArray *)arrayWithPathName:(NSString *)pathName {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SYCity" ofType:@"bundle"];
    NSBundle *syBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *path = [syBundle pathForResource:pathName ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

#pragma mark - locate
- (void)locate {
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
        [_locationManager startUpdatingLocation]; //开启定位
        [_tableView reloadData];
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 开始定位
    [_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
/**
 *  只要定位到用户的位置，就会调用（调用频率特别高）
 *  @param locations : 装着CLLocation对象
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //NSLog(@%@,placemark.name);//具体位置
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            [self.tableView reloadData];
            
            //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
            [manager stopUpdatingLocation];
        }
        //         else if (error == nil && [array count] == 0) {
        //             NSLog(@"No results were returned.");
        //         } else if (error != nil) {
        //             NSLog(@"An error occurred = %@", error);
        //         }
    }];
}

- (void)setOpenLocation:(BOOL)openLocation {
    if (_openLocation == openLocation) return;
    _openLocation = openLocation;
    if (_openLocation) {
        [self locate];
        return;
    }
    [_locationManager stopUpdatingHeading];
}

- (void)setBackView:(UIView *)backView {
    if (_backView == backView) return;
    _backView = backView;
    if ([backView isKindOfClass:[UIButton class]]) {
        [(UIButton *)backView addTarget:self action:@selector(cancelDidClick) forControlEvents:UIControlEventTouchUpInside];
    }else {
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelDidClick)];
        [backView addGestureRecognizer:tapGes];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
}

- (void)setBackImageName:(NSString *)backImageName {
    if ([_backImageName isEqualToString:backImageName]) return;
    _backImageName = backImageName;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:backImageName] style:UIBarButtonItemStyleDone target:self action:@selector(cancelDidClick)];
}



- (void)setHotCitys:(NSArray *)hotCitys {
    if (_hotCitys == hotCitys) return;
    _hotCitys = hotCitys;
    if (_cityDicts) {
        [_cityDicts setObject:hotCitys forKey:@"*"];
    }
}

- (NSArray *)hotCitys {
    if (!_hotCitys) {
        _hotCitys = @[@"北京",@"三亚",@"上海",@"广州",@"成都",@"青岛",@"南京",@"杭州",@"厦门",@"深圳",@"重庆",@"大连",@"香港",@"台北"];
    }
    return _hotCitys;
}

- (void)setCitys:(NSArray *)citys {
    if (_citys == citys) return;
    _citys = citys;
}

#pragma mark - 头部取消按钮
- (void)cancelSelect:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [_topView.inputTF resignFirstResponder];
}

- (void)dealloc {
    _searchVc.delegate = nil;
    _searchVc.searchResultsUpdater = nil;
    _searchVc.searchBar.delegate = nil;
    _searchVc.resultDelegate = nil;
    
    _indexArray = nil;
    _historyCitys = nil;
    _cityDicts = nil;
    
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
        _locationManager.delegate = nil;
    }
}
@end
