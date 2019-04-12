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
#import "OpenShareHeader.h"
#import "LaunchAnimationTool.h"
#import "TABAnimated.h"
#import "HcdGuideView.h"
#import "CCAppManager.h"
#import "CCGotoUpDateViewController.h"
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

- (UITabBarController *)setRootVC{
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
//    self.window.rootViewController = self.rootTabbarCtr;

    
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
    return self.rootTabbarCtr;
}

- (void)FirstLaunch:(NSNotification *)noti{
    self.window.rootViewController = [self setRootVC];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[CCAppManager sharedInstance] configureApp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldUpdateApp:) name:kNotificationAppShouldUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FirstLaunch:) name:@"FirstLaunch" object:nil];

    [[TABViewAnimated sharedAnimated] initWithDefaultAnimated];
//    self.window.rootViewController = [self setRootVC];
    [self configureAPIKey];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = APP_WHITECOLOR;
    //引导页
    NSMutableArray *images = [NSMutableArray new];
    
    [images addObject:[UIImage imageNamed:@"ggps_1_bg"]];
    [images addObject:[UIImage imageNamed:@"ggps_2_bg"]];
    [images addObject:[UIImage imageNamed:@"ggps_3_bg"]];
    
    HcdGuideView *guideView = [HcdGuideView sharedInstance];
    guideView.window = self.window;
    [guideView showGuideViewWithImages:images
                        andButtonTitle:@"立即体验"
                   andButtonTitleColor:[UIColor whiteColor]
                      andButtonBGColor:[UIColor clearColor]
                  andButtonBorderColor:[UIColor whiteColor]];

    _hotelLevel = [[NSMutableArray alloc] init];    //酒店等级
    _hotelTypeId = [[NSMutableArray alloc] init];   //酒店类型
    _level = [[NSMutableArray alloc] init];         //会员等级
    
    [OpenShare connectQQWithAppId:@"101559247"];
    [OpenShare connectWeiboWithAppKey:@"402180334"];
    [OpenShare connectWeixinWithAppId:@"wx2f631a50a1c2b9c5" miniAppId:@"gh_d43f693ca31f"];
    [QDServiceClient startMonitoringNetworking];
    //获取基准价
    [self getBasicPrice];
    [self findAllMapDict];
    
    //App Update
//    [self getUpdateInfo];
    return YES;
}

- (void)shouldUpdateApp:(NSNotification *)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        id userInfo = notification.object;
        CCGotoUpDateViewController *updateVC = [[CCGotoUpDateViewController alloc] init];
        updateVC.urlStr = [userInfo objectForKey:@"URI"];
        [self.window setRootViewController:updateVC];
    });
}

- (void)getUpdateInfo{
    [self showAlertView];
}

- (void)showAlertView{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"更新" message:@"检测到有新版本" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSString *urlStr =@"https://itunes.apple.com/us/app/%E8%BF%99%E5%A5%BD%E7%8E%A9/id1456067852?l=zh&ls=1&mt=8";

     NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@", APP_ID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
    }];
    [alertVC addAction:action1];
    [self.rootTabbarCtr presentViewController:alertVC animated:YES completion:nil];
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
            [WXProgressHUD showInfoWithTittle:responseObject.message];
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
            [WXProgressHUD showInfoWithTittle:responseObject.message];
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
    QDLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    QDLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    QDLog(@"applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
