//
//  QDHomeViewController.h
//  TravelPoints
//
//  Created by 冉金 on 2019/1/14.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface QDHomeViewController : UIViewController
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

NS_ASSUME_NONNULL_END
