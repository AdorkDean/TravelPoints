//
//  WMCustomizedPageController.m
//  WMPageControllerExample
//
//  Created by Mark on 2017/6/21.
//  Copyright © 2017年 Mark. All rights reserved.
//

#import "QDPlayingViewController.h"
#import "QDHotelReserveVC.h"
#import "QDDZYViewController.h"
#import "QDMallViewController.h"

@interface QDPlayingViewController ()
@end

@implementation QDPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_WHITECOLOR;
    self.progressViewIsNaughty = YES;
    self.progressWidth = 10;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (UIColor *)progressColor{
    return APP_BLUECOLOR;
}

- (UIColor *)titleColorSelected{
    return APP_BLACKCOLOR;
}

- (CGFloat)titleSizeNormal{
    return 15;
}

- (CGFloat)titleSizeSelected{
    return 16;
}

- (WMMenuViewStyle)menuViewStyle{
    return WMMenuViewStyleLine;
}

- (UIColor *)titleColorNormal{
    return APP_GRAYTEXTCOLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return @"预定酒店";
        case 1: return @"定制游";
        case 2: return @"商城";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0: return [[QDHotelReserveVC alloc] init];
        case 1: return [[QDDZYViewController alloc] init];
        case 2: return [[QDMallViewController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.style = WMMenuViewStyleFloodHollow;
    self.menuView.style = WMMenuViewStyleLine;
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    return CGRectMake(leftMargin, SafeAreaTopHeight-40, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

@end
