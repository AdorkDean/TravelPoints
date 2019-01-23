//
//  AppDelegate.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/14.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "AppDelegate.h"
#import "QDHomeViewController.h"
#import "QDHotelVC.h"
#import "QDRestaurantViewController.h"
#import "QDMallViewController.h"
#import "QDMineInfoViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface AppDelegate ()

@property(nonatomic, strong) UITabBarController *rootTabbarCtr;

@end

@implementation AppDelegate

- (void)configureAPIKey{
    if ([APIKey length] == 0) {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (void)initRootVC{
    QDHomeViewController *homeVC = [[QDHomeViewController alloc] init];
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    
    QDHotelVC *hotelVC = [[QDHotelVC alloc] init];
    UINavigationController *navhotel = [[UINavigationController alloc] initWithRootViewController:hotelVC];
    
    QDRestaurantViewController *restaurantVC = [[QDRestaurantViewController alloc] init];
    UINavigationController *navrestaurant = [[UINavigationController alloc] initWithRootViewController:restaurantVC];
    
    QDMallViewController *mallVC = [[QDMallViewController alloc] init];
    UINavigationController *navMall = [[UINavigationController alloc] initWithRootViewController:mallVC];
    
    QDMineInfoViewController *mineVC = [[QDMineInfoViewController alloc] init];
    UINavigationController *navMine = [[UINavigationController alloc] initWithRootViewController:mineVC];
    navMine.navigationBar.barTintColor = [UIColor whiteColor];
    homeVC.title = @"首页";
    hotelVC.title = @"酒店";
    restaurantVC.title = @"定制游";
    mallVC.title = @"商城";
    mineVC.title = @"我的";
    NSArray *viewCtrs = @[navHome, navhotel, navrestaurant, navMall, navMine];
    self.rootTabbarCtr = [[UITabBarController alloc] init];
    [self.rootTabbarCtr setViewControllers:viewCtrs animated:YES];
    self.window.rootViewController = self.rootTabbarCtr;
    
    UITabBar *tabbar = self.rootTabbarCtr.tabBar;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    UITabBarItem *item1 = [tabbar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabbar.items objectAtIndex:1];
    UITabBarItem *item3 = [tabbar.items objectAtIndex:2];
    UITabBarItem *item4 = [tabbar.items objectAtIndex:3];
    UITabBarItem *item5 = [tabbar.items objectAtIndex:4];
    
    item1.selectedImage = [[UIImage imageNamed:@"icon_tabbar_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"icon_tabbar_homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"icon_tabbar_onsite_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"icon_tabbar_onsite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"icon_tabbar_merchant_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"icon_tabbar_merchant_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"icon_tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"icon_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.selectedImage = [[UIImage imageNamed:@"icon_tabbar_misc_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item5.image = [[UIImage imageNamed:@"icon_tabbar_misc"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initRootVC];
    [self configureAPIKey];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
