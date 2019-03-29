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
#import "LaunchImageTransition.h"
#import "LaunchAnimationTool.h"
#import "TABAnimated.h"

#import <JhtGuidePages/JhtGradientGuidePageVC.h>
@interface AppDelegate ()
@property (nonatomic, strong) JhtGradientGuidePageVC *introductionView;

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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 在window上放一个imageView
    [self createGuideVC];
    [[TABViewAnimated sharedAnimated] initWithDefaultAnimated];
//    self.window.rootViewController = [self setRootVC];

    [self configureAPIKey];
    [self.window makeKeyAndVisible];

    self.window.backgroundColor = APP_WHITECOLOR;
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

/** 创建引导页 */
- (void)createGuideVC {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *firstKey = [NSString stringWithFormat:@"isFirst%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    NSString *isFirst = [defaults objectForKey:firstKey];
    
    NSMutableArray *backgroundImageNames = [NSMutableArray arrayWithCapacity:3];
    NSMutableArray *coverImageNames = [NSMutableArray arrayWithCapacity:3];
    if (!isFirst.length) {
        for (NSInteger i = 1; i < 4; i ++) {
            NSString *temp1 = [NSString stringWithFormat:@"ggps_%ld_bg", i];
            NSString *temp2 = [NSString stringWithFormat:@"ggps_%ld_text", i];
            if ([[UIApplication sharedApplication] statusBarFrame].size.height > 20) {
                temp1 = [NSString stringWithFormat:@"x_%@", temp1];
                temp2 = [NSString stringWithFormat:@"x_%@", temp2];
            }
            
            [backgroundImageNames addObject:temp1];
            [coverImageNames addObject:temp2];
        }
        
        // NO.1
        //        self.introductionView = [[JhtGradientGuidePageVC alloc] initWithGuideImageNames:backgroundImageNames withLastRootViewController:[[ViewController alloc] init]];
        
        // NO.2
        //        self.introductionView = [[JhtGradientGuidePageVC alloc] initWithCoverImageNames:coverImageNames withBackgroundImageNames:backgroundImageNames withLastRootViewController:[[ViewController alloc] init]];
        
        // NO.3
        // case 1
        UIButton *enterButton = [[UIButton alloc] init];
        [enterButton setTitle:@"点击进入" forState:UIControlStateNormal];
        [enterButton setBackgroundColor:[UIColor purpleColor]];
        enterButton.layer.cornerRadius = 8.0;
        
//        UIButton *_optionBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.3, SCREEN_HEIGHT*0.85, SCREEN_WIDTH*0.44, SCREEN_HEIGHT*0.07)];
//        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
//        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH*0.44, SCREEN_HEIGHT*0.05);
//        gradientLayer.startPoint = CGPointMake(0, 0);
//        gradientLayer.endPoint = CGPointMake(1, 0);
//        gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
//        [gradientLayer setColors:@[(id)[[UIColor colorWithHexString:@"#28BAD3"] CGColor],(id)[[UIColor colorWithHexString:@"#119EC7"] CGColor]]];//渐变数组
//        [_optionBtn.layer addSublayer:gradientLayer];
//        [_optionBtn setTitle:@"立即体验" forState:UIControlStateNormal];
//        [_optionBtn setTitleColor:APP_WHITECOLOR forState:UIControlStateNormal];
//        _optionBtn.layer.cornerRadius = 16;
//        _optionBtn.layer.masksToBounds = YES;
//        _optionBtn.titleLabel.font = QDFont(20);
        // case 2
        //        UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 100) / 2, CGRectGetHeight([UIScreen mainScreen].bounds) - 30 - 50, 100, 30)];
        //        [enterButton setBackgroundImage:[UIImage imageNamed:@"enter_btn"] forState:UIControlStateNormal];
        
//        self.introductionView = [[JhtGradientGuidePageVC alloc] initWithCoverImageNames:coverImageNames withBackgroundImageNames:backgroundImageNames withEnterButton:enterButton withLastRootViewController:[self setRootVC]];
        self.introductionView = [[JhtGradientGuidePageVC alloc] initWithGuideImageNames:backgroundImageNames withLastRootViewController:[self setRootVC]];
//        self.introductionView = [[JhtGradientGuidePageVC alloc] initWithCoverImageNames:backgroundImageNames withBackgroundImageNames:backgroundImageNames withEnterButton:_optionBtn withLastRootViewController:[self setRootVC]];
        // 添加《跳过》按钮
        self.introductionView.isHiddenPageControl = YES;
        self.introductionView.isNeedSkipButton = YES;
        /******** 更多个性化配置见《JhtGradientGuidePageVC.h》 ********/
        
        self.window.rootViewController = self.introductionView;
        
        __weak AppDelegate *weakSelf = self;
        self.introductionView.didClickedEnter = ^() {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *firstKey = [NSString stringWithFormat:@"isFirst%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            NSString *isFirst = [defaults objectForKey:firstKey];
            if (!isFirst) {
                [defaults setObject:@"notFirst" forKey:firstKey];
                [defaults synchronize];
            }
            
            weakSelf.introductionView = nil;
        };
        
    } else {
//        [self initRootVC];
        self.window.rootViewController = [self setRootVC];
    }
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
