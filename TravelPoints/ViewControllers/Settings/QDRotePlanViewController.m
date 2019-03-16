//
//  QDRotePlanViewController.m
//  TravelPoints
//
//  Created by WJ-Shao on 2019/3/1.
//  Copyright © 2019 Charles Ran. All rights reserved.
//

#import "QDRotePlanViewController.h"
#import "RadialCircleAnnotationView.h"
#import "ErrorInfoUtility.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "QDRoutePlanHeaderView.h"
#import "QDNavigationService.h"
static const NSString *RoutePlanningViewControllerStartTitle       = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";
static const NSInteger RoutePlanningPaddingEdge                    = 20;


@interface QDRotePlanViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate, AMapSearchDelegate>{
    QDRoutePlanHeaderView *_headerView;
}
//路线规划类型
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapRoute *route;

/*当前路线方案索引值*/
@property (nonatomic, assign) NSUInteger currentCourse;

/*路线方案个数*/
@property (nonatomic, assign) NSInteger totalCourse;

/* 起始点经纬度. */
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
/* 终点经纬度. */
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

/* 用于显示当前路线方案. */
@property (nonatomic) MANaviRoute * naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotation;


@property (nonatomic, strong) UISegmentedControl *showSegment;
@property (nonatomic, strong) UISegmentedControl *headingSegment;
@property (nonatomic, strong) MAPointAnnotation *annotation;
@property (nonatomic, assign) BOOL headingCalibration;
@property (nonatomic, strong) MAPinAnnotationView *annotationView;
@property (nonatomic, assign) CGFloat annotationViewAngle;
@property (nonatomic, strong) CLHeading *heading;

@property (nonatomic, strong) NSMutableArray *regions;
@property (nonatomic, strong) UIButton *gpsButton;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation QDRotePlanViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
}

- (void)makeCall:(UIButton *)sender{
    if (_infoModel.telphone == nil || [_infoModel.telphone isEqualToString:@""]) {
        [WXProgressHUD showErrorWithTittle:@"未找到酒店电话"];
    }else{
        NSString * telStr = [NSString stringWithFormat:@"tel:%@",@"18140547641"];
        UIWebView * webV = [[UIWebView alloc]init];
        [webV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telStr]]];
        [self.view addSubview:webV];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_WHITECOLOR;
    self.regions = [[NSMutableArray alloc] init];
    [self setTopView];
    [self initMapView];
    if (_infoModel) {
        [self setInfoView];
        UIButton *phoneBtn = [[UIButton alloc] init];
        [phoneBtn setImage:[UIImage imageNamed:@"icon_makeCall"] forState:UIControlStateNormal];
        [self.view addSubview:phoneBtn];
        [phoneBtn addTarget:self action:@selector(makeCall:) forControlEvents:UIControlEventTouchUpInside];
        [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headerView.mas_top);
            make.right.equalTo(self.view.mas_right).offset(-(SCREEN_WIDTH*0.06));
            make.width.and.height.mas_equalTo(SCREEN_WIDTH*0.2);
        }];
        [self loadBottomInfoWithModel:_infoModel];
    }
    [self configLocationManager];
    [self addOneAnnotation];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self getCurrentLocation];
}

- (void)loadBottomInfoWithModel:(QDHotelListInfoModel *)infoModel{
    _headerView.titleLab.text = infoModel.hotelName;
    _headerView.info4.text = [NSString stringWithFormat:@"¥%@", infoModel.rmbprice];
    _headerView.info1.text = [NSString stringWithFormat:@"%@", infoModel.price];
    _headerView.addressStr.text = infoModel.address;
}

- (void)getCurrentLocation{
    //终点地名
    NSString *oreillyAddress = [NSString stringWithFormat:@"%@, %@", _cityStr, _addressStr];
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:oreillyAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            self.destinationCoordinate  = CLLocationCoordinate2DMake(firstPlacemark.location.coordinate.latitude, firstPlacemark.location.coordinate.longitude);
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}
/* 展示当前路线方案. */
- (void)presentCurrentCourse
{
    MANaviAnnotationType type = MANaviAnnotationTypeWalking;
    self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentCourse] withNaviType:type showTraffic:YES startPoint:[AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude] endPoint:[AMapGeoPoint locationWithLatitude:self.destinationAnnotation.coordinate.latitude longitude:self.destinationAnnotation.coordinate.longitude]];
    [self.naviRoute addToMapView:self.mapView];
    
    /* 缩放地图使其适应polylines的展示. */
    [self.mapView showOverlays:self.naviRoute.routePolylines edgePadding:UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge) animated:YES];
}

- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)RoutePlanningViewControllerStartTitle;
//    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    startAnnotation.subtitle   =  _currentAddressStr;
    QDLog(@"startAnnotation.subtitle = %@", startAnnotation.subtitle);
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)RoutePlanningViewControllerDestinationTitle;
//    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"%@%@", _cityStr, _addressStr];

    self.destinationAnnotation = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
    
    //计算距离
    MAMapPoint point1 = MAMapPointForCoordinate(_startCoordinate);
    MAMapPoint point2 = MAMapPointForCoordinate(_destinationCoordinate);
    //2.计算距离
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    QDLog(@"distance = %.2lf", distance);
    _headerView.distanceLab.text = [NSString stringWithFormat:@"距离%.2lfkm", distance/1000];
}

#pragma mark - do search
- (void)searchRoutePlanningWalk
{
    self.startAnnotation.coordinate = self.startCoordinate;
    self.destinationAnnotation.coordinate = self.destinationCoordinate;
    
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    
    /* 提供备选方案*/
    navi.multipath = 1;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapWalkingRouteSearch:navi];
}

- (void)addOneAnnotation{
    _annotation = [[MAPointAnnotation alloc] init];
    _annotation.coordinate = self.mapView.centerCoordinate;
    [self.mapView addAnnotation:self.annotation];
}

- (void)returnAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTopView{
    UIButton *returnBtn = [[UIButton alloc] init];
    [returnBtn setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
    [self.view addSubview:returnBtn];
    [returnBtn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    [returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(SCREEN_WIDTH*0.05);
        make.top.equalTo(self.view.mas_top).offset(SCREEN_HEIGHT*0.06);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"酒店位置";
    titleLab.font = QDFont(17);
    titleLab.textColor = APP_BLACKCOLOR;
    [self.view addSubview:titleLab];

    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(returnBtn);
        make.centerX.equalTo(self.view);
    }];


    UIButton *routePlan = [[UIButton alloc] init];
    [routePlan setTitle:@"开始导航" forState:UIControlStateNormal];
    [routePlan addTarget:self action:@selector(startNavigation:) forControlEvents:UIControlEventTouchUpInside];
    [routePlan setTitleColor:APP_BLACKCOLOR forState:UIControlStateNormal];
    routePlan.titleLabel.font = QDFont(14);
    [self.view addSubview:routePlan];
    [routePlan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(returnBtn);
        make.right.equalTo(self.view.mas_right).offset(-(SCREEN_WIDTH*0.05));
    }];
}

- (void)startNavigation:(UIButton *)sender{
    NSString *oreillyAddress = [NSString stringWithFormat:@"%@, %@", _cityStr, _addressStr];
    [QDNavigationService navWithViewController:self WithEndLocation:_destinationCoordinate  andAddress:oreillyAddress];
}

- (void)setInfoView{
    _headerView = [[QDRoutePlanHeaderView alloc] init];
    _headerView.backgroundColor = APP_WHITECOLOR;
    _headerView.layer.cornerRadius = 5;
    _headerView.layer.masksToBounds = YES;
    [self.view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-(SCREEN_HEIGHT*0.1));
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH*0.89);
        make.height.mas_equalTo(SCREEN_HEIGHT*0.25);
    }];
}

- (void)configLocationManager
{
    _headingCalibration = NO;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    //设置期望定位精度
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    //设置允许连续定位逆地理
    [self.locationManager setLocatingWithReGeocode:YES];
    
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        _currentAddressStr = [NSString stringWithFormat:@"%@%@%@", regeocode.district, regeocode.street, regeocode.POIName];
        NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
        self.startCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        [self searchRoutePlanningWalk];
        [self addDefaultAnnotations];
    }];
   
}

- (void)showsHeadingAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex)
    {
        _headingCalibration = YES;
    }
    else
    {
        _headingCalibration = NO;
    }
}

- (void)startHeadingLocation
{
    //开始进行连续定位
    [self.locationManager startUpdatingLocation];
    
    if ([AMapLocationManager headingAvailable] == YES)
    {
        [self.locationManager startUpdatingHeading];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        _headingCalibration = YES;
        [self startHeadingLocation];
    }
    else
    {
        _headingCalibration = NO;
        [self startHeadingLocation];
    }
}

#pragma mark - AMapLocationManager Delegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
//    [self updateTotal];
    self.currentCourse = 0;
    
//    [self updateCourseUI];
//    [self updateDetailUI];
    
    if (response.count > 0)
    {
        [self presentCurrentCourse];
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f, reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);

    //连续定位中, 添加地理围栏
//    if (self.regions.count) {
//        [self.regions removeAllObjects];
//    }
//
//    [self.mapView setCenterCoordinate:location.coordinate];
//    [self.annotation setCoordinate:location.coordinate];
//    [self.mapView setZoomLevel:15.1 animated:NO];
}

- (BOOL)amapLocationManagerShouldDisplayHeadingCalibration:(AMapLocationManager *)manager
{
    return _headingCalibration;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (_annotationView != nil)
    {
//        if (_routeType == QDNearByRestaurant || _routeType == QDNearSpot) {
//            CGFloat angle = newHeading.trueHeading*M_PI/180.0f + M_PI - _annotationViewAngle;
//            NSLog(@"################### heading : %f - %f", newHeading.trueHeading, newHeading.magneticHeading);
//            _annotationViewAngle = newHeading.trueHeading*M_PI/180.0f + M_PI;
//            _heading = newHeading;
//            _annotationView.transform =  CGAffineTransformRotate(_annotationView.transform ,angle);
//        }
    }
}

#pragma mark - Initialization

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.11, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //比例尺
        self.mapView.showsScale = YES;
        //罗盘
        self.mapView.showsCompass = NO;
        //        self.mapView.showsUserLocation = YES;
        [self.mapView setDelegate:self];
        [self.view addSubview:self.mapView];
    }
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:routePlanningCellIdentifier];
        }
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;
        if ([annotation isKindOfClass:[MANaviAnnotation class]])
        {
            switch (((MANaviAnnotation*)annotation).type)
            {
                case MANaviAnnotationTypeRailway:
                    poiAnnotationView.image = [UIImage imageNamed:@"railway_station"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            /* 起点. */
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle])
            {
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
            }
        }
        return poiAnnotationView;
    }
    return nil;
}


#pragma mark - MAMapViewDelegate
//
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth   = 8;
        polylineRenderer.lineDashPattern = @[@10, @15];
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]])
    {
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        
        polylineRenderer.lineWidth = 8;
        
        if (naviPolyline.type == MANaviAnnotationTypeWalking)
        {
            polylineRenderer.strokeColor = self.naviRoute.walkingColor;
        }
        else if (naviPolyline.type == MANaviAnnotationTypeRailway)
        {
            polylineRenderer.strokeColor = self.naviRoute.railwayColor;
        }
        else
        {
            polylineRenderer.strokeColor = self.naviRoute.routeColor;
        }
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        MAMultiColoredPolylineRenderer * polylineRenderer = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        
        polylineRenderer.lineWidth = 8;
        polylineRenderer.strokeColors = [self.naviRoute.multiPolylineColors copy];
        polylineRenderer.gradient = YES;
        
        return polylineRenderer;
    }
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonRenderer *polylineRenderer = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
        polylineRenderer.lineWidth = 5.0f;
        polylineRenderer.strokeColor = [UIColor redColor];
        
        return polylineRenderer;
    }
    else if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.lineWidth = 0.2;
        circleRenderer.strokeColor = [UIColor colorWithHexString:@"#C9F0C1"];
        circleRenderer.alpha = 0.08;
        return circleRenderer;
    }
    return nil;
}

#pragma mark - 定位按钮
- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}

- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
}

- (void)gpsAction {
    
    //    11
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    [self.gpsButton setSelected:YES];
    //    if(self.mapView.userLocation.updating && self.mapView.userLocation.location) {
    //        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    //        [self.gpsButton setSelected:YES];
    //    }
}

@end
