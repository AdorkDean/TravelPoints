//
//  AppDelegate.h
//  TravelPoints
//
//  Created by 冉金 on 2019/1/14.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) double basePirceRate;

@property (nonatomic, strong) NSMutableArray *hotelLevel;
@property (nonatomic, strong) NSMutableArray *hotelTypeId;
@property (nonatomic, strong) NSMutableArray *level;

@end

