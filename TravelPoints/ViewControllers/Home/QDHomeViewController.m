//
//  SerialLocationViewController.m
//  officialDemoLoc
//
//  Created by 刘博 on 15/9/21.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import "QDHomeViewController.h"
#import "QDHomeTopView.h"
@interface QDHomeViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>

@property (nonatomic, strong) UISegmentedControl *showSegment;
@property (nonatomic, strong) UISegmentedControl *headingSegment;
@property (nonatomic, strong) MAPointAnnotation *pointAnnotaiton;
@property (nonatomic, assign) BOOL headingCalibration;
@property (nonatomic, strong) MAPinAnnotationView *annotationView;
@property (nonatomic, assign) CGFloat annotationViewAngle;
@property (nonatomic, strong) CLHeading *heading;
@property (nonatomic, strong) QDHomeTopView *homeTopView;

@property (nonatomic, strong) NSMutableArray *regions;

@end

@implementation QDHomeViewController

#pragma mark - Action Handle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.locationManager stopUpdatingHeading];
    [self.locationManager stopUpdatingLocation];
    [self.navigationController.navigationBar setHidden:NO];
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
    
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    //设置允许连续定位逆地理
    [self.locationManager setLocatingWithReGeocode:YES];
    
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 31.212004;
    coordinate.longitude = 121.534437;
//    [self addCircleReionForCoordinate:coordinate];
}

- (void)showsSegmentAction:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex)
    {
        //停止定位
        [self.locationManager stopUpdatingLocation];
        [self.locationManager stopUpdatingHeading];
        
        //移除地图上的annotation
        [self.mapView removeAnnotations:self.mapView.annotations];
        self.pointAnnotaiton = nil;
        _annotationView = nil;
    }
    else
    {
        [self startHeadingLocation];
    }
    
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
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f, reGeocode:%@}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy, reGeocode.formattedAddress);
    
    //连续定位中, 添加地理围栏
    if (self.regions.count) {
        [self.regions removeAllObjects];
    }
//    [self addCircleReionForCoordinate:location.coordinate];

    //获取到定位信息，更新annotation
    if (self.pointAnnotaiton == nil)
    {
        self.pointAnnotaiton = [[MAPointAnnotation alloc] init];
        [self.pointAnnotaiton setCoordinate:location.coordinate];
        
        [self.mapView addAnnotation:self.pointAnnotaiton];
    }
    
    [self.pointAnnotaiton setCoordinate:location.coordinate];
    
    [self.mapView setCenterCoordinate:location.coordinate];
    [self.mapView setZoomLevel:15.1 animated:NO];
}

- (void)addCircleReionForCoordinate:(CLLocationCoordinate2D)coordinate
{
    //创建圆形地理围栏
    AMapLocationCircleRegion *cirRegion200 = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate
                                                                                       radius:200.0
                                                                                   identifier:@"circleRegion200"];
    
    AMapLocationCircleRegion *cirRegion300 = [[AMapLocationCircleRegion alloc] initWithCenter:coordinate
                                                                                       radius:300.0
                                                                                   identifier:@"circleRegion300"];
    
    //添加地理围栏
    
    
//    [self.locationManager startMonitoringForRegion:cirRegion200];
    [self.locationManager startMonitoringForRegion:cirRegion300];
    
    //保存地理围栏
//    [self.regions addObject:cirRegion200];
    if (self.regions.count) {
        [self.regions removeAllObjects];
    }
    [self.regions addObject:cirRegion300];
    QDLog(@"self.regions.count = %lu", (unsigned long)self.regions.count);
    //添加地理围栏对应的Overlay，方便查看
//    MACircle *circle200 = [MACircle circleWithCenterCoordinate:coordinate radius:200.0];
    MACircle *circle300 = [MACircle circleWithCenterCoordinate:coordinate radius:300.0];
//    [self.mapView addOverlay:circle200];
    [self.mapView addOverlay:circle300];
    
    [self.mapView setVisibleMapRect:circle300.boundingMapRect];
}
- (BOOL)amapLocationManagerShouldDisplayHeadingCalibration:(AMapLocationManager *)manager
{
    return _headingCalibration;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (_annotationView != nil)
    {
        CGFloat angle = newHeading.trueHeading*M_PI/180.0f + M_PI - _annotationViewAngle;
        NSLog(@"################### heading : %f - %f", newHeading.trueHeading, newHeading.magneticHeading);
        _annotationViewAngle = newHeading.trueHeading*M_PI/180.0f + M_PI;
        _heading = newHeading;
        _annotationView.transform =  CGAffineTransformRotate(_annotationView.transform ,angle);
    }
}

#pragma mark - Initialization

- (void)initMapView
{
    if (self.mapView == nil)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.3, SCREEN_WIDTH, SCREEN_HEIGHT*0.7)];
        //比例尺
        self.mapView.showsScale = YES;
        //罗盘
        self.mapView.showsCompass = NO;
        [self.mapView setDelegate:self];
        
        [self.view addSubview:self.mapView];
    }
}

- (void)initUI{
    _homeTopView = [[QDHomeTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*0.3)];
    _homeTopView.backgroundColor = APP_GREENCOLOR;
    [self.view addSubview:_homeTopView];
}
- (void)initToolBar
{
    UIBarButtonItem *flexble = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                             target:nil
                                                                             action:nil];
    
    self.showSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Start", @"Stop", nil]];
    [self.showSegment addTarget:self action:@selector(showsSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.showSegment.selectedSegmentIndex = 0;
    UIBarButtonItem *showItem = [[UIBarButtonItem alloc] initWithCustomView:self.showSegment];
    
    self.headingSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"不校准", @"校准", nil]];
    [self.headingSegment addTarget:self action:@selector(showsHeadingAction:) forControlEvents:UIControlEventValueChanged];
    self.headingSegment.selectedSegmentIndex = 0;
    UIBarButtonItem *showItem2 = [[UIBarButtonItem alloc] initWithCustomView:self.headingSegment];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexble, showItem, flexble, showItem2, flexble, nil];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.regions = [[NSMutableArray alloc] init];
    [self initToolBar];
    
    [self initMapView];
    [self initUI];
    
    [self configLocationManager];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startHeadingLocation];
    
    if ([AMapLocationManager headingAvailable] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持方向功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - MAMapView Delegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        
        MAPinAnnotationView *annotationView = _annotationView;
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.canShowCallout   = NO;
            annotationView.animatesDrop     = NO;
            annotationView.draggable        = NO;
            annotationView.image            = [UIImage imageNamed:@"icon_location.png"];
            _annotationView = annotationView;
            _annotationViewAngle = 0;
        }
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - MAMapViewDelegate
//
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
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

@end
