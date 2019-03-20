//
//  AppDelegate.m
//  TravelPoints
//
//  Created by 冉金 on 2019/1/14.
//  Copyright © 2019年 Charles Ran. All rights reserved.
//

#import "AppDelegate.h"
#import "QDHomgePageVC.h"
#import "QDPlayingViewController.h"
#import "QDTradingViewController.h"
#import "QDMineInfoViewController.h"
#import "QDBridgeViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <OpenShareHeader.h>
#import "LaunchImageTransition.h"
#import "LaunchAnimationTool.h"
#import "TABAnimated.h"
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
    QDHomgePageVC *homeVC = [[QDHomgePageVC alloc] init];
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    QDPlayingViewController *playShellsVC = [[QDPlayingViewController alloc] init];
    UINavigationController *navPlayShell= [[UINavigationController alloc] initWithRootViewController:playShellsVC];
    
    QDTradingViewController *tradeShellsVC = [[QDTradingViewController alloc] init];
    UINavigationController *navTradeShell = [[UINavigationController alloc] initWithRootViewController:tradeShellsVC];

    QDMineInfoViewController *mineVC = [[QDMineInfoViewController alloc] init];
    UINavigationController *navMine = [[UINavigationController alloc] initWithRootViewController:mineVC];
    navMine.navigationBar.barTintColor = [UIColor whiteColor];
    homeVC.title = @"首页";
    playShellsVC.title = @"用贝";
    tradeShellsVC.title = @"转贝";
    mineVC.title = @"我的";
    NSArray *viewCtrs = @[navHome, navPlayShell, navTradeShell, navMine];
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
    
    item1.selectedImage = [[UIImage imageNamed:@"icon_tabbar_homepage_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"icon_tabbar_homepage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"icon_tabbar_onsite_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"icon_tabbar_onsite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"icon_tabbar_merchant_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"icon_tabbar_merchant_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"icon_tabbar_mine_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"icon_tabbar_mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:APP_GRAYTEXTCOLOR, NSForegroundColorAttributeName, QDFont(12), NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:APP_BLUECOLOR,NSForegroundColorAttributeName,QDFont(12),NSFontAttributeName,nil]forState:UIControlStateSelected];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 在window上放一个imageView
    
    [[TABViewAnimated sharedAnimated] initWithDefaultAnimated];
    [self initRootVC];
//    [LaunchAnimationTool showLaunchAnimationViewToWindow];
    [self configureAPIKey];
    [self.window makeKeyAndVisible];

    self.window.backgroundColor = APP_WHITECOLOR;
    _hotelLevel = [[NSMutableArray alloc] init];    //酒店等级
    _hotelTypeId = [[NSMutableArray alloc] init];   //酒店类型
    _level = [[NSMutableArray alloc] init];         //会员等级
    
    [OpenShare connectQQWithAppId:@"1103194207"];
    [OpenShare connectWeiboWithAppKey:@"402180334"];
    [OpenShare connectWeixinWithAppId:@"wxd930ea5d5a258f4f"];
    
    //添加默认地址
    if ([QDUserDefaults getObjectForKey:@"QD_Domain"] == nil || [[QDUserDefaults getObjectForKey:@"QD_Domain"] isEqualToString:@""]) {
        [QDUserDefaults setObject:@"http://203.110.179.27:60409" forKey:@"QD_Domain"];
//        [QDUserDefaults setObject:@"http://47.101.222.172:8080" forKey:@"QD_Domain"];
//        [QDUserDefaults setObject:@"http://appuat.wedotting.com" forKey:@"QD_Domain"];
    }
    if ([QDUserDefaults getObjectForKey:@"QD_JSURL"] == nil || [[QDUserDefaults getObjectForKey:@"QD_JSURL"] isEqualToString:@""]) {
        [QDUserDefaults setObject:@"http://203.110.179.27:60409/app" forKey:@"QD_JSURL"];
//        [QDUserDefaults setObject:@"http://47.101.222.172:8080/app" forKey:@"QD_JSURL"];
//        [QDUserDefaults setObject:@"http://appuat.wedotting.com/app" forKey:@"QD_JSURL"];
    }    if ([QDUserDefaults getObjectForKey:@"QD_TESTJSURL"] == nil || [[QDUserDefaults getObjectForKey:@"QD_TESTJSURL"] isEqualToString:@""]) {
        [QDUserDefaults setObject:@"http://203.110.179.27:60409/app/#" forKey:@"QD_TESTJSURL"];
//        [QDUserDefaults setObject:@"http://47.101.222.172:8080/app/#" forKey:@"QD_TESTJSURL"];
//        [QDUserDefaults setObject:@"http://appuat.wedotting.com/app/#" forKey:@"QD_TESTJSURL"];
    }
    [QDServiceClient startMonitoringNetworking];
    //获取基准价
    [self getBasicPrice];
    [self findAllMapDict];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
        //这里可以写上其他OpenShare不支持的客户端的回掉,比如支付宝等
    return YES;
}
- (void)findAllMapDict{
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_FindAllMapDict params:nil successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            NSDictionary *dic = responseObject.result;
            if ([[dic allKeys] containsObject:@"hotelLevel"]) {
                if (_hotelLevel.count) {
                    [_hotelLevel removeAllObjects];
                }
                if (_hotelTypeId.count) {
                    [_hotelTypeId removeAllObjects];
                }
                if (_level.count) {
                    [_level removeAllObjects];
                }
                NSArray *aaa = [dic objectForKey:@"hotelLevel"];
                for (NSDictionary *dd in aaa) {
                    [_hotelLevel addObject:[dd objectForKey:@"dictName"]];
                }
                NSArray *bbb = [dic objectForKey:@"hotelTypeId"];
                for (NSDictionary *dd in bbb) {
                    [_hotelTypeId addObject:[dd objectForKey:@"dictName"]];
                }
                NSArray *ccc = [dic objectForKey:@"Level"];
                for (NSDictionary *dd in ccc) {
                    [_level addObject:[dd objectForKey:@"dictName"]];
                }
            }
        }else{
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD hideHUD];
    }];
}
#pragma mark - 个人积分账户详情
- (void)getBasicPrice{
    [[QDServiceClient shareClient] requestWithType:kHTTPRequestTypePOST urlString:api_GetBasicPrice params:nil successBlock:^(QDResponseObject *responseObject) {
        if (responseObject.code == 0) {
            self.basePirceRate = [responseObject.result doubleValue];
        }else{
            [WXProgressHUD showErrorWithTittle:responseObject.message];
        }
    } failureBlock:^(NSError *error) {
        [WXProgressHUD hideHUD];
    }];
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
